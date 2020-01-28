module HasImageAttached
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods
    # Defines an attachment, paperclip style, using ActiveStorage as a backer
    # and Vips as a processor.
    #
    # Options:
    #   - defaults: Default options merged with every style
    #   - styles: Named styles, which override defaults
    #   - direct_upload: Not yet supported
    #
    # Style Options:
    #   - fit/fill/pad/limit - Crop modes, mutually exclusive. See Vips docs
    #   - crop - Crop option, one of :none, :attention, :centre, and :entropy
    #   - composite - not yet supported
    #
    def has_image_attached(name, options = {})
      has_one_attached name
      alias_method "as_#{name}", "#{name}"

      define_method name do |*args|
        base = self.send("as_#{name}", *args)
        ImageAttachmentWrapper.new(name, base, options)
      end
    end
  end

  # Wrapper for ActiveStorage attachments that provides image
  # handling methods. Any unknown methods are delegated to the
  # underlying AS attachment object, so this is mostly* transparent.
  #
  class ImageAttachmentWrapper
    VALID_CROPS = [:none, :attention, :centre, :entropy]

    def initialize(name, base, options)
      @name = name
      @base = base
      @options = options
    end

    def style(key)
      unless key === :original || @options[:styles].include?(key)
        raise NoStyleError, "Attachment :#{name} does not define style :#{key}"
      end

      unless @base.attached?
        return nil
      end

      style = @options[:defaults] || {}
      style.merge! @options[:styles][key] || {}
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
            raise InvalidStyleError, "Attachment :#{name}, style :#{key}, option :crop must be one of #{VALID_CROPS.join(', ')}"
          end
        end

        style_args.push(:"resize_to_#{resize_type}" => style[resize_type] + crop_option)
      end

      @base.variant(*style_args)
    end

    def url(style, *args)
      variant = self.style(style)

      unless @base.attached?
        return nil
      end

      if style === :original
        return Rails.application.routes.url_helpers.rails_blob_url(@base, *args)
      end

      Rails.application.routes.url_helpers.rails_representation_url(variant, *args)
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