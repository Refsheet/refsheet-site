module Types
  module Lodestone
    ClassJobType = GraphQL::ObjectType.define do
      name "Lodestone_ClassJob"
      interfaces [Interfaces::ApplicationRecordInterface]

      field :lodestone_character, Types::Lodestone::CharacterType
      field :name, types.String
      field :class_abbr, types.String
      field :class_icon_url, types.String
      field :class_name, types.String
      field :job_abbr, types.String
      field :job_name, types.String
      field :level, types.Int
      field :exp_level, types.Int
      field :exp_level_max, types.Int
      field :exp_level_togo, types.Int
      field :specialized, types.Boolean
      field :job_active, types.Boolean
    end
  end
end