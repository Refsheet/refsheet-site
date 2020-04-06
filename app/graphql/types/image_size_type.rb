Types::ImageSizeType = GraphQL::ObjectType.define do
  name "ImageSize"

  Image.new.image.styles.keys.each do |style|
    field style, Types::GeometryType do
      resolve -> (obj, _args, _ctx) {
        current_geometry = obj.instance.geometry rescue nil
        return if current_geometry.nil?
        resize_to = obj.styles[style].geometry

        return unless resize_to.present?
        current_geometry.resize_to(resize_to) rescue nil
      }
    end
  end
end
