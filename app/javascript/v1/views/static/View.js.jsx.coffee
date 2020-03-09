import React from 'react'
import PropTypes from 'prop-types'
import createReactClass from 'create-react-class'

@View = createReactClass
  contextTypes:
    router: PropTypes.object.isRequired
    eagerLoad: PropTypes.object

  dataPath: '/static/:pageId'

  paramMap:
    pageId: 'id'


  getInitialState: ->
    page: null
    error: null


  componentDidMount: ->
    props = match: params: pageId: ( @props.match?.params.pageId || @props.location.pathname.replace(/^\//, '') )
    StateUtils.load @, 'page', props

  componentWillReceiveProps: (newProps) ->
    return if (newProps.location.pathname and newProps.location.pathname is @props.location.pathname) or (newProps.match?.params.pageId and newProps.match?.params.pageId is @props.match?.params.pageId)
    props = match: params: pageId: ( newProps.match?.params.pageId || newProps.location.pathname.replace(/^\//, '') )
    StateUtils.reload @, 'page', props, params: pageId: @state.page?.id

  #== Render

  render: ->
    if @state.page
      `<Main title={ this.state.page.title }>
          <div dangerouslySetInnerHTML={{__html: this.state.page.content }} />
      </Main>`

    else
      `<Main />`
export default @View