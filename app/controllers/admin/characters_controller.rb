class Admin::CharactersController < AdminController
  before_action :get_character, except: [:index]

  before_action do
    @search = { path: admin_characters_path }
  end

  def index
    @characters = filter_scope Character.all
  end

  def show; end
  def edit; end

  def update
    if @character.update_attributes(character_params)
      Changelog.create changelog_params
    end

    respond_with :admin, @character, location: admin_character_path(@character.shortcode)
  end

  private

  def get_character
    @character = Character.find_by_shortcode! params[:id]
  end

  def character_params
    params.require(:character).permit!
  end

  def changelog_params
    {
        user: current_user,
        reason: params[:reason],
        change_data: @character.previous_changes,
        changed_character: @character
    }
  end
end
