class UserSerializer < ActiveModel::Serializer
  include GravatarImageTag::InstanceMethods

  attributes :username, :email, :avatar_url, :path, :name, :profile_image_url, :cover_image_url, :profile

  has_many :characters, serializer: ImageCharacterSerializer

  def avatar_url
    gravatar_image_url object.email
  end

  def profile_image_url
    '/assets/unsplash/fox.jpg'
  end

  def cover_image_url
    '/assets/unsplash/sand.jpg'
  end

  def path
    "/users/#{object.username}/"
  end

  def profile; <<-HTML; end
    <h1>Hey there!</h1>
    <p>
        So profiles are coming soon (I promise!). I just need to figure out how to lay them out, and how to get the React
        component to pick up user chips, like
        <span class='chip' data-user-id='MauAbata'><img src='/assets/unsplash/fox.jpg' /> Mau Abata</span>
        (<code>@MauAbata</code>) for a user chip, and
        <span class='chip' data-user-id='MauAbata' data-character-id='akhet'><img src='/assets/unsplash/sand.jpg' /> Akhet</span>
        (<code>@MauAbata/akhet</code>) for a character chip!
        You should also be able to load up some super cool Avatar-only chips, just double-down on the at-sign!
        So like, <code>@@MauAbata @@MauAbata/akhet</code> becomes:
        <span class='chip textless' data-user-id='MauAbata'><img src='/assets/unsplash/fox.jpg' /></span>
        <span class='chip textless' data-user-id='Inkmaven'><img src='/assets/unsplash/sand.jpg' /></span>
    </p>
    <h2>But Mau, I'm a hopeless romantic and wanna show off our connecting icons!</h2>
    <p>
        Sure, you do you. Join usernames on a plus sign: <code>@@MauAbata+Inkmaven</code> will become
        <span class='chip-group'>
          <span class='chip textless' data-user-id='MauAbata'><img src='/assets/unsplash/fox.jpg' /></span>
          <span class='chip textless' data-user-id='Inkmaven'><img src='/assets/unsplash/sand.jpg' /></span>
        </span>
        which looks like a pill, just like you. <strong>But that's not good enough is it?</strong> You REALLY want to show off
        your little sweet pill, doncha?
    </p>
    <p>Pills, like you, scale to font size. Check it: <code>\#@@MauAbata/mau+MauAbata+MauAabata/akhet+Inkmaven/ink</code> becomes...</p>
    <center><h1>
        <span class='chip-group'>
          <span class='chip textless' data-user-id='MauAbata'><img src='/assets/avatars/mau.png' /></span>
          <span class='chip textless' data-user-id='MauAbata'><img src='/assets/unsplash/fox.jpg' /></span>
          <span class='chip textless' data-user-id='Inkmaven'><img src='/assets/unsplash/sand.jpg' /></span>
          <span class='chip textless' data-user-id='Inkmaven'><img src='/assets/avatars/ink.png' /></span>
        </span>
    </h1></center>
    <p>If you're confused by the last one, <code>#</code> is markdown-speak for <code>&lt;H1&gt;</code>.</p>
  HTML
end
