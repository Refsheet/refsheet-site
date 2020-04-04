module HasImageAttached
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods
    # Defines an attachment, paperclip style, using ActiveStorage as a backer
    # and Vips as a processor.
    #
    # @example
    #   has_image_attached :avatar,
    #                      default_url: -> (_m, style) { "/assets/default-#{style}.png " },
    #                      defaults: {
    #                          crop: :attention,
    #                      },
    #                      styles: {
    #                          thumbnail: { fill: [320, 320] },
    #                          small: { fit: [480, 480] },
    #                          medium: { fit: [640, 640] },
    #                      }
    #
    # ==== Proc Interpolation
    #
    # Any of these options can be set to a proc, which will be called to generate the value:
    #   -> (instance, style) { ... }
    # - <tt>*instance*</tt> (Object)   The instance of the model
    # - <tt>*style*</tt>    (Symbol)   The requested style key
    #
    # @todo Add support for eager-processing background job
    # @todo Move image processing to some other server / image
    #
    # @param [Symbol] name      Attachment name, passed to +has_one_attached+.
    # @param [Hash]   options   Style definition options.
    #
    # @option options [Hash] :defaults      Default options merged with every style.
    # @option options [Hash] :default_url   Default asset path if an image is not attached.
    # @option options [Hash] :styles        Named styles, which override defaults. +fit/fill/pad/limit+ are mutually exclusive.
    #   - <tt>*:crop*</tt>  (Symbol) Target crop priority
    #   - <tt>*:fit*</tt>   (Array) Crop to fit the size given by +[W x H]+
    #   - <tt>*:fill*</tt>  (Array) Crop to fill
    #   - <tt>*:pad*</tt>   (Array) Crop to fit with padding
    #   - <tt>*:limit*</tt> (Array) Resize within the given limits
    #
    def has_image_attached(name, options = {})
      has_one_attached name
      alias_method "as_#{name}", "#{name}"

      define_method name do |*args|
        base = self.send("as_#{name}", *args)
        ImageAttachmentWrapper.new(name, base, options, self)
      end
    end
  end

  # Wrapper for ActiveStorage attachments that provides image
  # handling methods. Any unknown methods are delegated to the
  # underlying AS attachment object, so this is mostly* transparent.
  #
  # @see HasImageAttached::ClassMethods#has_image_attached
  #
  class ImageAttachmentWrapper
    include ActionView::Helpers::AssetUrlHelper

    VALID_CROPS = [:none, :attention, :centre, :entropy]

    def initialize(name, base, options, instance)
      @name = name
      @base = base
      @options = options
      @instance = instance
    end


    # Returns a list of styles associated with this attachment.
    def styles
      @options[:styles]&.keys
    end

    def style(key)
      unless key === :original || @options[:styles].include?(key)
        raise NoStyleError, "Attachment :#{name} does not define style :#{key}, consider: #{@options[:styles].keys.join(', ')}"
      end

      unless @base.attached?
        return nil
      end

      style = @options[:defaults] || {}
      style.merge! @options[:styles][key] || {}

      # Process Procs
      style.each do |skey, value|
        if value.respond_to? :call
          style[skey] = value.call(@instance, key)
        end
      end

      Rails.logger.info("Processing attachment with style: " + style.inspect)

      style_args = []

      resize_type = (style.keys & [:fit, :fill, :limit]).first
      crop_option = []

      if resize_type
        resize_value = style[resize_type]

        unless resize_value.is_a? Array and resize_value.length == 2
          raise InvalidStyleError, "Attachment :#{name}, style :#{key}, option :#{resize_type} must be array of 2 items [WxH]"
        end

        if style[:crop]
          if VALID_CROPS.include? style[:crop]
            crop_option.push(crop: style[:crop])
          else
            raise InvalidStyleError, "Attachment :#{name}, style :#{key}, option :crop must be one of: #{VALID_CROPS.join(', ')} (got: #{style[:crop]})"
          end
        end

        style_args.push(:"resize_to_#{resize_type}" => style[resize_type] + crop_option)
      end

      @base.variant(*style_args)
    end

    # Returns a URL to the image, given a particular style. Style can also be :original,
    # in which case a URL to the original file will be returned.
    #
    # @param [Symbol] style Style requested for the URL, or :original
    # @param [Hash] opts Options to configure URL generation. Unknown opts will be passed to URL helpers.
    # @option opts [Boolean] :allow_nil Return nil instead of default, if default is present.
    #
    # @raise [NoStyleError] Style key was not defined on attachment, check your call.
    # @raise [InvalidStyleError] Style definition was not valid, check your model.
    #
    # @return [String, nil] URL of the attachment, or nil
    #
    def url(style, opts={})
      variant = self.style(style)

      unless @base.attached?
        if !opts[:allow_nil] && @options[:default_url]
          return image_url(@options[:default_url])
        end

        return nil
      end

      url_opts = opts.without(:allow_nil)

      if style === :original
        return Rails.application.routes.url_helpers.rails_blob_url(@base, url_opts)
      end

      Rails.application.routes.url_helpers.rails_representation_url(variant, url_opts)
    end

    def method_missing(sym, *args)
      @base.send(sym, *args)
    end

    class NoStyleError < ArgumentError
    end

    class InvalidStyleError < ArgumentError
    end
  end
end