module Paperclip
  class UploadProcessor < Processor
    include WatermarkHelper

    def initialize(file, options = {}, attachment = nil)
      super
      geometry = options[:geometry]
      @resize_to = geometry
      @file = file
      @crop = geometry[-1,1] == '#'
      @target_geometry = Geometry.parse geometry
      @current_geometry = Geometry.from_file @file
      @convert_options = options[:convert_options]
      @whiny = options[:whiny].nil? ? true : options[:whiny]
      @format = options[:format]

      @instance = attachment.instance
      @options = options

      @overlay = options[:overlay].nil? ? true : false
      @current_format = File.extname(@file.path)
      @basename = File.basename(@file.path, @current_format)
      # Rails.logger.info "watermark initialized"
    end

    # Returns true if the +target_geometry+ is meant to crop.
    def crop?
      @crop
    end

    # Returns true if the image is meant to make use of additional convert options.
    def convert_options?
      not @convert_options.blank?
    end

    # Performs the conversion of the +file+ into a watermark. Returns the Tempfile
    # that contains the new image.

    def make
      # Rails.logger.info "watermark make method"
      dst = Tempfile.new([@basename, '.' + @format.to_s])
      dst.binmode

      command = "convert"
      params  = %W['#{fromfile}']
      params += transformation_command
      params << "-quality 100"

      if watermark?
        params += watermark_command
      end

      if annotate?
        params += annotation_command
      end

      params << "'#{tofile(dst)}'"

      Rails.logger.info 'params:' + params.to_s

      begin
        Paperclip.run(command, params.join(' '))
      rescue ArgumentError, Cocaine::CommandLineError
        raise Paperclip::Error.new("There was an error processing the watermark for #{@basename}") if @whiny
      end

      dst
    end


    #== SUBCOMMAND GENERATORS

    def transformation_command
      scale, crop = @current_geometry.transformation_to(@target_geometry, crop?)
      trans = %W[-resize '#{scale}']
      trans += %W[-crop '#{crop}' +repage] if crop
      trans << @convert_options if @convert_options.present?
      trans
    end


    #== MISC HELPERS

    def fromfile
      File.expand_path(@file.path)
    end

    def tofile(destination)
      File.expand_path(destination.path)
    end
  end
end