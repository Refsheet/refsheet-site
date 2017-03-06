class CharactersController < ApplicationController
  before_action :get_user, except: [:index]
  before_action :get_character, except: [:index, :create]

  def index
    @characters = filter_scope
    render json: @characters, each_serializer: ImageCharacterSerializer
  end

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
    head :unauthorized and return unless @character.user == current_user || current_user&.role?(:admin)

    if @character.update_attributes character_params
      render json: @character, serializer: CharacterSerializer
    else
      render json: { errors: @character.errors }, status: :bad_request
    end
  end

  def destroy
    head :unauthorized and return unless @character.user == current_user || current_user&.role?(:admin)

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
                                          :body_type, :personality, :special_notes, :profile, :likes, :dislikes, :slug,
                                          :shortcode)

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

  def filter_scope
    scope = Character.all
    sort = nil
    order = nil
    query = []

    params[:q].split(/\s+/).each do |q|
      case q
        when /sort:(\w+)/i
          sort = $1.downcase
        when /order:(asc|desc)/i
          order = $1.upcase
        else
          query << q
      end
    end

    scope = if %w(created_at updated_at name).include?(sort)
      scope.order("characters.#{sort} #{order}")
    else
      scope.default_order
    end

    scope.search_for(query.join(' '))
  end
end
