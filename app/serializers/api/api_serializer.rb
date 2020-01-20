class Api::ApiSerializer < ActiveModel::Serializer
  class << self
    def type(type)
      attribute :_type
      define_method :_type do
        type&.to_s
      end
    end

    def id(field=:guid)
      attribute field, key: :id
    end
  end
end