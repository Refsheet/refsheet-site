class CharactersController < ApplicationController
  before_action :get_user
  before_action :get_character, except: [:create]

  def show
    set_meta_tags(
        twitter: {
            card: 'photo',
            image: {
                _: @character.profile_image.image.url(:medium)
            }
        },
        og: {
            image: @character.profile_image.image.url(:medium)
        },
        title: @character.name,
        description: @character.profile.presence || 'This character has no description!',
        image_src: @character.profile_image.image.url(:medium)
    )

    respond_to do |format|
      format.html { render 'application/show' }
      format.json { render json: @character, serializer: CharacterSerializer }
    end
  end

  def create
    @character = Character.new character_params.merge(user: current_user)
    if @character.save
      render json: @character
    else
      render json: { errors: @character.errors }, status: :bad_request
    end
  end

  def update
    if @character.update_attributes character_params
      render json: @character, serializer: CharacterSerializer
    else
      render json: { errors: @character.errors }, status: :bad_request
    end
  end

  def destroy
    if @character.destroy
      render json: @character, serializer: CharacterSerializer
    else
      render json: { errors: @character.errors }, status: :bad_request
    end
  end

  private

  def get_user
    @user = User.lookup! params[:user_id]
  end

  def get_character
    @character = @user.characters.lookup! params[:id]
  end

  def character_params
    p = params.require(:character).permit(:name, :nickname, :gender, :species, :height, :weight,
                                          :body_type, :personality, :special_notes, :profile, :likes, :dislikes, :slug)

    if params[:character].include? :color_scheme_attributes
      p[:color_scheme_attributes] = { color_data: params[:character][:color_scheme_attributes][:color_data].permit!, id: @character.color_scheme_id }
    end

    if params[:character].include? :profile_image_guid
      p[:profile_image] = @character.images.find_by!(guid: params[:character][:profile_image_guid])
    end

    if params[:character].include? :featured_image_guid
      p[:featured_image] = @character.images.find_by!(guid: params[:character][:featured_image_guid])
    end

    p
  end
end
