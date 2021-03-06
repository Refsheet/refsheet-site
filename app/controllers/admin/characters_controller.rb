class Admin::CharactersController < AdminController
  before_action :get_character, except: [:index]

  before_action do
    @search = { path: admin_characters_path }
  end

  def index
    @scope = @characters = filter_scope Character.all
    @characters = taper_group @characters if params[:sort].to_s == 'created_at'
  end

  def show; end
  def edit; end

  def update
    if params[:version].present?
      @character.paper_trail_event = 'rollback'
      @character.save
    else
      if @character.update(character_params)
        Changelog.create changelog_params
      end
    end

    respond_with :admin, @character, location: admin_character_path(@character.shortcode)
  end

  private

  def get_character
    @character = Character.find_by_shortcode! params[:id]

    if params[:version]
      @character = @character.versions[params[:version].to_i]&.reify
    end
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
