@Forums.Index = React.createClass
  render: ->
    `<Main title='Forums'>
        <Jumbotron>
            <h1>Discuss & Socialize</h1>
        </Jumbotron>

        <Container className='padding-top--large'>
            <Forums.Table />
        </Container>
    </Main>`
