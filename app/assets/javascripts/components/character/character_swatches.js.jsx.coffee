@CharacterSwatches = React.createClass
  getInitialState: ->
    swatches: null
    
  editSwatch: (key, data) ->
    $.ajax
      url: '/users/mauabata/akhet/swatches'
      type: 'PATCH'
      success: (data) =>
        @setState swatches: data
    
  newSwatch: (data) ->
    $.post '/users/mauabata/akhet/swatches', (data) =>
      @setState swatches: data
  
  removeSwatch: (key) ->
    $.ajax
      url: '/users/mauabata/akhet/swatches/' + key
      type: 'DELETE'
      success: (data) =>
        @setState swatches: data

  componentDidMount: ->
    $.get @props.characterPath + '/swatches', (data) =>
      @setState swatches: data

  componentDidUpdate: ->
    $('#swatch-menu').collapsible()

  render: ->
    if !@state.swatches?
      `<section className='character-swatches'>
      </section>`

    else
      swatches = @state.swatches.map (swatch) ->
        `<div className='swatch' key={ swatch.guid } style={{backgroundColor: swatch.color}} />`

      if @props.artistView
        swatchDetails = @state.swatches.map (swatch) ->
          `<Attribute key={ swatch.guid } value={ swatch.color } {...swatch} />`

        `<section className='character-swatches'>
            <div className='container'>
                <ul id='swatch-menu' className='collapsible'>
                    <li>
                        <div className='collapsible-header swatch-container'>
                            <div className='swatch-row'>
                                { swatches }
                                <div className='swatch tooltipped' data-tooltip='More Details' data-position='bottom'>
                                    <i className='material-icons'>palette</i>
                                </div>
                            </div>
                        </div>
                        <div className='collapsible-body'>
                            <AttributeTable onAttributeChange={ this.editSwatch }
                                            onAttributeAdd={ this.newSwatch }
                                            onAttributeDelete={ this.removeSwatch }
                                            reorder={ true }>
                                { swatchDetails }
                            </AttributeTable>
                        </div>
                    </li>
                </ul>
            </div>
        </section>`

      else
        `<section className='character-swatches'>
            <div className='container'>
                <div className='swatch-container z-depth-1'>
                    <div className='swatch-row'>
                        { swatches }
                    </div>
                </div>
            </div>
        </section>`
