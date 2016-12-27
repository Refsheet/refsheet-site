@CharacterApp = React.createClass
  getInitialState: ->
    current_user: @props.currentUser
    user: @props.user
    character: @props.character

  render: ->
    if @state.character != undefined
      `<Loading />`

    else
      `<div>
          <UserBar user={this.state.current_user} />

          <SideNav>
              <CharacterView backgroundImage="/assets/unsplash/sand.jpg" avatar="http://d.facdn.net/art/mauabata/1475972185/1475972185.mauabata_mauflamescrying.png" />
              <SideNavLink icon='perm_identity' href='#top' text='Summary' />
              <SideNavLink icon='palette' href='#swatches' text='Color Swatches' />
              <SideNavLink icon='photo_album' href='#refsheet' text='Main Image' />
          </SideNav>

          <PageHeader backgroundImage="/assets/unsplash/sand.jpg">
              <CharacterCard imageSrc="http://d.facdn.net/art/mauabata/1475972185/1475972185.mauabata_mauflamescrying.png" name="Akhet" />
          </PageHeader>

          <CharacterSwatches swatches={[
              'rgb(253, 244, 221)',
              'rgb(193, 180, 146)',
              'rgb(148, 131, 107)',
              'rgb(108, 96, 78)',
              'rgb(74, 62, 49)',
              'rgb(57, 50, 43)',
              'rgb(48, 43, 36)',
              'rgb(81, 57, 57)',
              'rgb(174, 196, 77)',
              'rgb(53, 73, 42)'
          ]} />
          
          <CharacterStaticReference imageSrc="http://d.facdn.net/art/mauabata/1472002969/1472002969.mauabata_maushamanreference_postres.png" />
      </div>`
