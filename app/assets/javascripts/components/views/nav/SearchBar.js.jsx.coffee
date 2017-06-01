@SearchBar = React.createClass
  contextTypes:
    router: React.PropTypes.object

  propTypes:
    query: React.PropTypes.string

  getInitialState: ->
    query: @props.query || ''
    active: !!@props.query

  componentWillReceiveProps: (newProps) ->
    if newProps.query != @props.query
      @setState query: (newProps.query || ''), active: !!newProps.query


  activate: ->
    @setState active: true

  deactivate: ->
    @setState active: !!@state.query


  _handleSearchSubmit: (e) ->
    newPath = '/browse'
    newPath += '?' + $.param q: @state.query if @state.query
    @context.router.push newPath
    $(@refs.search).blur()
    e.preventDefault()

  _handleInputChange: (e) ->
    @setState query: e.target.value

  render: ->
    classNames = ['search']
    classNames.push 'active' if @state.active

    `<form className={ classNames.join(' ') } onSubmit={ this._handleSearchSubmit }>
        <div className="input-field">
            <input ref='search'
                   id="search"
                   type="search"
                   onChange={ this._handleInputChange }
                   onFocus={ this.activate }
                   onBlur={ this.deactivate }
                   value={ this.state.query } />

            <label htmlFor="search"><i className="material-icons">search</i></label>
        </div>
    </form>`
