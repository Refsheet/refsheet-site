@Static.View = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired
    eagerLoad: React.PropTypes.object

  dataPath: '/static/:pageId'

  paramMap:
    pageId: 'id'


  getInitialState: ->
    page: null
    error: null


  componentDidMount: ->
    props = params: pageId: ( @props.params.pageId || @props.location.pathname.replace(/^\//, '') )
    StateUtils.load @, 'page', props

  componentWillReceiveProps: (newProps) ->
    return if (newProps.location.pathname and newProps.location.pathname is @props.location.pathname) or (newProps.params.pageId and newProps.params.pageId is @props.params.pageId)
    props = params: pageId: ( newProps.params.pageId || newProps.location.pathname.replace(/^\//, '') )
    StateUtils.reload @, 'page', props, params: pageId: @state.page?.id

  #== Render

  render: ->
    if @state.page
      `<Main title={ this.state.page.title }>
          <div dangerouslySetInnerHTML={{__html: this.state.page.content }} />
      </Main>`

    else
      `<Main />`
