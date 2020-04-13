# TODO: Is this mutation trying too hard?
#
class Mutations::CharacterMutations < Mutations::ApplicationMutation
  before_action :get_character, only: [
      :update, :convert, :destroy, :transfer, :set_avatar_blob, :set_cover_blob]

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
      @character.cover_image.detach
    else
      @character.cover_image.attach(params[:blob])
    end
    @character.save!
    @character
  end

  action :sort_gallery_image do
    type Types::CharacterType

    argument :sourceImageId, !types.ID
    argument :targetImageId, !types.ID
    argument :dropBefore, types.Boolean
  end

  def sort_gallery_image
    @source_image = Image.find_by!(guid: params[:sourceImageId])
    @target_image = Image.find_by!(guid: params[:targetImageId])

    @character = @source_image.character
    authorize @character, :update?

    if @target_image.character_id != @character.id
      @target_character = @target_image.character
      authorize @target_character, :update?

      # Handle image transfers here:
      @source_image.character = @target_character
    end

    position = if @target_image.row_order_rank > @source_image.row_order_rank
                 @target_image.row_order_rank + (params[:dropBefore] ? -1 : 0)
               else
                 @target_image.row_order_rank + (params[:dropBefore] ? 0 : 1)
               end

    Rails.logger.info({position: position, trr: @target_image.row_order_rank, srr: @source_image.row_order_rank, db: params[:dropBefore]}.inspect)
    @source_image.update(row_order_position: position)
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
