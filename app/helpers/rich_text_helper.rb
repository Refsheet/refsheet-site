module RichTextHelper
  def linkify(text)
    text = $markdown.render(text)

    text.gsub /@(@?)(\S+)/ do |_|
      chips = $2.split('+').collect do |chip|
        username, character = chip.split '/'
        textless = $1 == '@'

        user = User.find_by(username: username)
        next missing_chip(chip, textless) unless user

        if character
          if (char = user.characters.find_by(slug: character))
            character_chip(user, char, textless)
          else
            missing_chip(chip, textless)
          end
        else
          user_chip(user, textless)
        end
      end

      if chips.many?
        <<-HTML
          <div class='chip-group'>#{ chips.join }</div>
        HTML
      else
        chips.first
      end
    end
  end

  def character_chip(user, char, textless=false)
    <<-HTML
      <div class='chip character-chip #{textless ? "textless" : ""}' data-user-id='#{user.username}' data-character-id='#{char.slug}'>
        <img src='#{char.profile_image.image.url}' alt='#{char.name}' />
        #{textless ? '' : char.name}
      </div>
    HTML
  end

  def user_chip(user, textless=false)
    <<-HTML
      <div class='chip user-chip #{textless ? "textless" : ""}' data-user-id='#{user.username}'>
        <img src='/assets/avatars/mau.png' alt='#{user.name}' />
        #{textless ? '' : user.name}
      </div>
    HTML
  end

  def missing_chip(orig, textless=false)
    <<-HTML
      <div class='chip missing-chip #{textless ? "textless" : ""}'>
        <i class='material-icons'>help</i>
        #{textless ? '' : orig}
      </div>
    HTML
  end
end
