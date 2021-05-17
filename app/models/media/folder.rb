class Media::Folder < ApplicationRecord
  include HasGuid
  include RankedModel

  attr_accessor :authenticated

  belongs_to :parent, inverse_of: :children, foreign_key: :parent_media_folder_id, class_name: "Media::Folder", optional: true
  belongs_to :featured_media, class_name: "Image", optional: true
  belongs_to :user, optional: false
  belongs_to :character, optional: false

  has_many :media, class_name: "Image", inverse_of: :folder
  has_many :children, inverse_of: :parent, class_name: "Media::Folder", foreign_key: :parent_media_folder_id

  has_guid
  ranks :row_order, with_same: :character_id

  def password_protected?
    get_parent_password.present?
  end

  def authenticate!(pw)
    if pw == get_parent_password
      @authenticated = true
    else
      @authenticated = false
    end
  end

  private

  def get_parent_password
    record = self
    seen = Set[]

    begin
      pw = record.password
      unless pw.nil? && seen.add?(record.id)
        break
      end

      record = record.parent
    end until record.nil?

    pw
  end
end
