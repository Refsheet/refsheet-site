# TODO: Is this mutation trying too hard?
#
class Mutations::CharacterMutations < Mutations::ApplicationMutation
  before_action :get_character, only: [:update, :convert, :destroy, :transfer, :set_avatar_blob, :set_cover_blob]

  action :update do
    type Types::CharacterType

    argument :id, !types.ID

    argument :name, types.String
    argument :species, types.String
    argument :special_notes, types.String
    argument :slug, types.String
    argument :shortcode, types.String
    argument :nsfw, types.Boolean
    argument :hidden, types.Boolean
    argument :color_scheme_id, types.ID
  end

  def update
    authorize @character

    @character.update_attributes! update_params
    @character
  end

  action :transfer do
    type Types::CharacterType

    argument :id, !types.ID
    argument :destination, !types.String
  end

  def transfer
    authorize @character

    @character.transfer_to_user = params[:destination]
    @character.save!

    @character
  end

  action :convert do
    type Types::CharacterType
    argument :id, !types.ID
  end

  def convert
    authorize @character

    ConvertProfileV2Job.perform_now(@character)
    @character
  end

  # TODO: Rename to :autocomplete, update mutation type.
  action :search do
    type types[Types::CharacterType]

    argument :username, type: types.String
    argument :slug, type: types.String
  end

  def search
    q = params[:slug].downcase + '%'
    user = if params[:username] == "me"
             context.current_user.call
           else
             User.lookup!(params[:username])
           end

    scope = user.characters
    scope.where('LOWER(characters.slug) LIKE ? OR LOWER(characters.name) LIKE ?', q, q).limit(10).order(:name)
  end

  action :destroy do
    type Types::CharacterType

    argument :id, !types.ID
    argument :confirmation, !types.String
  end

  def destroy
    authorize @character

    if params[:confirmation] == @character.slug
      @character.destroy
    else
      @character.errors.add(:confirmation, "does not match slug")
    end
  end

  action :set_avatar_blob do
    type Types::CharacterType

    argument :id, !types.ID
    argument :blob, types.String
  end

  def set_avatar_blob
    authorize @character, :update?
    if params[:blob].blank?
      @character.avatar.detach
    else
      @character.avatar.attach(params[:blob])
    end
    @character.save!
    @character
  end

  action :set_cover_blob do
    type Types::CharacterType

    argument :id, !types.ID
    argument :blob, types.String
  end

  def set_cover_blob
    authorize @character, :update?
    if params[:blob].blank?
      @character.avatar.detach
    else
      @character.cover_image.attach(params[:blob])
    end
    @character.save!
    @character
  end

  private

  def get_character
    @character = Character.find_by! shortcode: params[:id]
  end

  def update_params
    _params = params.permit(
        :name,
        :species,
        :special_notes,
        :slug,
        :shortcode,
        :nsfw,
        :hidden
    )

    if params.include? :color_scheme_id
      _params.merge(color_scheme: ColorScheme.find_by!(guid: params[:color_scheme_id]))
    end

    _params
  end
end
