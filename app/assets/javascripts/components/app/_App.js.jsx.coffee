@App = React.createClass
  render: ->
    `<div id='rootApp'>
        <UserBar />

        <main>
            <RouteHandler />
        </main>

        <Footer />
    </div>`
