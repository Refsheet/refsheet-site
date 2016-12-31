@App = React.createClass
  render: ->
    `<div id='rootApp'>
        <UserBar />

        <main>
            { this.props.children }
        </main>

        <Footer />
    </div>`
