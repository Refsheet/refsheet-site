@Forums.Table = React.createClass
  render: ->
    `<div className='collection-group'>
        <h2 className='group-title'>Support</h2>

        <Row>
            <Column m={4}>
                <Forums.Card title='Site Updates' locked noRp icon='history' threadCount={12}>
                    Check here to hear about the latest in fancy features and cool things.
                </Forums.Card>
            </Column>

            <Column m={4}>
                <Forums.Card title='Customer Service' locked noRp icon='help' threadCount={32}>
                    A place to talk about account-related problems, or to yell at Mau for breaking things.
                </Forums.Card>
            </Column>

            <Column m={4}>
                <Forums.Card title='Feature Requests' noRp icon='edit' threadCount={1210580}>
                    Want to see something new? Mention it here!
                </Forums.Card>
            </Column>
        </Row>
    </div>`
