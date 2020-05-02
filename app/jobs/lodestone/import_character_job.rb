class Lodestone::ImportCharacterJob < ApplicationJob
  queue_as :default

  # @param [String] lodestone_id
  def perform(character_id: nil, lodestone_id: nil, lodestone_character_id: nil)
    character = nil

    if !lodestone_character_id
      if !character_id || !lodestone_id
        raise ArgumentError, "character_id and lodestone_id required"
      end
    else
      character = Lodestone::Character.find(lodestone_character_id)
      character.touch
      lodestone_id = character.lodestone_id
      character_id = character.character.id
    end

    Rails.logger.info("Fetching character #{lodestone_id} from the Lodestone...")
    xiv = XIVAPI::Client.new(api_key: ENV['XIVAPI_API_KEY'])
    remote = xiv.character(id: lodestone_id, extended: true, data: %w(CJ))
    rc = remote.character

    character = build_character(rc, character_id)
    character.server = build_server(rc)
    character.race = build_race(rc)
    character.class_jobs = build_class_jobs(character, rc)
    character.active_class_job = find_active_job(character, rc)

    character.save!
    character
  end

  private

  def build_character(rc, character_id)
    data = {
        bio: rc.bio,
        name: rc.name,
        nameday: rc.nameday,
        remote_updated_at: Time.at(rc.parse_date),
        portrait_url: rc.portrait,
        title: rc.title&.name,
        title_top: rc.title_top,
        town: rc.town&.name,
        tribe: rc.tribe&.name,
        diety: rc.guardian_deity&.name,
        gc_name: rc.grand_company&.company&.name,
        gc_rank_name: rc.grand_company&.rank&.name,
    }

    character = Lodestone::Character.find_or_initialize_by(lodestone_id: rc.id, character_id: character_id)
    character.assign_attributes(data)
    character
  end

  def build_race(rc)
    data = {
        name: rc.race.name
    }

    race = Lodestone::Race.find_or_initialize_by(lodestone_id: rc.race.id)
    race.assign_attributes(data)
    race
  end

  def build_server(rc)
    data = {
        name: rc.server,
        datacenter: rc.dc
    }

    id = "#{rc.dc}/#{rc.server}"
    server = Lodestone::Server.find_or_initialize_by(lodestone_id: id)
    server.assign_attributes(data)
    server
  end

  def build_class_jobs(character, rc)
    class_jobs = rc.class_jobs&.collect do |cj|
      rclass = cj[:class]
      job = cj[:job]

      data = {
          class_abbr: rclass.abbreviation,
          class_icon_url: "https://xivapi.com" + rclass.icon,
          class_name: rclass.name.capitalize,
          job_abbr: job.abbreviation,
          job_icon_url: "https://xivapi.com" + job.icon,
          job_name: job.name.capitalize,
          level: cj.level,
          exp_level: cj.exp_level,
          exp_level_max: cj.exp_level_max,
          exp_level_togo: cj.exp_level_togo,
          specialized: cj.is_specialised,
      }

      class_job = character.class_jobs.find_or_initialize_by(name: cj.name)
      class_job.assign_attributes(data)
      class_job
    end

    class_jobs
  end

  def find_active_job(character, rc)
    rclass = rc.gear_set[:class]&.name
    class_job = character.class_jobs.find { |cj| cj.class_name.downcase == rclass }
    if class_job
      class_job.assign_attributes(job_active: rc.gear_set[:job]&.name)
      class_job
    end
  end
end
