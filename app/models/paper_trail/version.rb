# == Schema Information
#
# Table name: versions
#
#  id             :bigint(8)        not null, primary key
#  item_type      :string           not null
#  item_id        :bigint(8)        not null
#  event          :string           not null
#  whodunnit      :string
#  created_at     :datetime
#  object         :jsonb
#  object_changes :jsonb
#
# Indexes
#
#  index_versions_on_item_type_and_item_id  (item_type,item_id)
#

module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern

    def whodunnit
      id = attributes['whodunnit']

      if id =~ /^gid/
        GlobalID::Locator.locate(id)
      else
        User.find_by(id: id)
      end
    end
  end
end
