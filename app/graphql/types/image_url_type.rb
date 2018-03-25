Types::ImageUrlType = GraphQL::ObjectType.define do
  name "ImageUrl"

  Image.new.image.styles.keys.each do |style|
    field style, types.String do
      resolve -> (obj, _args, _ctx) {
        obj.url(style)
      }
    end
  end
end
