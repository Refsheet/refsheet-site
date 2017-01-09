module RichTextHelper
  def linkify(text)
    return if text.nil?
    text = $markdown.render(text)

    text.gsub /@(@?)([a-z0-9_\/+-]+)/i do |_|
      chips = $2.split('+').collect do |chip|
        username, character = chip.split '/'
        textless = $1 == '@'

        user = User.lookup username
        next missing_chip(chip, textless) unless user

        if character
          if (char = user.characters.lookup character)
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
          <span class='chip-group'>#{ chips.join }</span>
        HTML
      else
        chips.first
      end
    end.gsub(/[\n\t]/,' ').squish
  end

  def character_chip(user, char, textless=false)
    <<-HTML
      <a href='/#{user.username}/#{char.slug}' class='chip character-chip #{textless ? "textless" : ""}' data-user-id='#{user.username}' data-character-id='#{char.slug}'>
        <img src='#{char.profile_image.image.url}' alt='#{char.name}' />
        #{textless ? '' : char.name}
      </a>
    HTML
  end

  def user_chip(user, textless=false)
    <<-HTML
      <a href='/#{user.username}' class='chip user-chip #{textless ? "textless" : ""}' data-user-id='#{user.username}'>
        <img src='/assets/avatars/mau.png' alt='#{user.name}' />
        #{textless ? '' : user.name}
      </a>
    HTML
  end

  def missing_chip(orig, textless=false)
    <<-HTML
      <span class='chip missing-chip #{textless ? "textless" : ""}'>
        <span class='icon-container'><i class='material-icons'>help</i></span>
        #{textless ? '' : orig}
      </span>
    HTML
  end
end
