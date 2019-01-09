module Paperclip::WatermarkHelper
  DEFAULT_WATERMARK_OPACITY = 0.25
  DEFAULT_WATERMARK_PATH = Rails.root.join("lib/assets/watermarks/RefsheetLogo_White_200.png")
  DEFAULT_WATERMARK_GRAVITY = "Center"

  def watermark?
    image.watermark
  end

  def annotate?
    watermark? and image.annotation
  end

  def watermark_path
    DEFAULT_WATERMARK_PATH
  end

  def watermark_gravity
    # @position = options[:position].nil? ? DEFAULT_WATERMARK_GRAVITY : options[:position]
    # @watermark_offset = options[:watermark_offset]
    DEFAULT_WATERMARK_GRAVITY
  end

  def watermark_opacity
    DEFAULT_WATERMARK_OPACITY
  end

  def annotation_text
    character = image.character
    character ? "ref.st/" + character.shortcode : "Refsheet.net"
  end

  def watermark_command
    params = []

    params << "'#{watermark_path}'"
    params << "-gravity #{watermark_gravity}"
    params << "-geometry +0-25" if annotate?
    params << "-compose dissolve -define compose:args='#{watermark_opacity * 100},100'"
    params << "-composite"

    Rails.logger.info("WATERMARK_COMMAND: " + params.join(' '))
    params
  end

  def annotation_command
    params = []
    stroke = '#000000' + ('%02x' % (255 * watermark_opacity).floor)
    fill   = '#FFFFFF' + ('%02x' % (255 * watermark_opacity).floor)

    params << "-background none"
    params << "-gravity #{watermark_gravity}"
    params << "-font #{Rails.root.join('lib/assets/Roboto-Black.ttf')} -pointsize 20"
    params << "-strokewidth 1"

    params << "-stroke \\#{stroke} -fill \\#{fill} -annotate +0+100 '#{annotation_text}'"
    params
  end
end