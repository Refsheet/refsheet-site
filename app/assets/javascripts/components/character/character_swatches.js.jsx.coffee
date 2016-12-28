@CharacterSwatches = React.createClass
  getInitialState: ->
    swatches: null

  swatchParams: (data) ->
    if data.rowOrderPosition?
      swatch:
        row_order_position: data.rowOrderPosition
    else
      swatch:
        color: data.value || ''
        name:  data.name  || ''
        notes: data.notes || ''

  editSwatch: (data, onSuccess, onFail) ->
    $.ajax
      url: @props.characterPath + '/swatches/' + data.id
      data: @swatchParams(data)
      type: 'PATCH'
      success: (_data) =>
        @setState swatches: _data
        onSuccess(_data) if onSuccess?
      error: (error) ->
        d = error.responseJSON.errors
        onFail(value: d.color, name: d.name, notes: d.notes) if onFail?
    
  newSwatch: (data, onSuccess, onFail) ->
    $.ajax
      url: @props.characterPath + '/swatches'
      data: @swatchParams(data)
      type: 'POST'
      success: (_data) =>
        @setState swatches: _data
        onSuccess(_data) if onSuccess?
      error: (error) ->
        d = error.responseJSON.errors
        onFail(value: d.color, name: d.name, notes: d.notes) if onFail?
  
  removeSwatch: (key) ->
    $.ajax
      url: @props.characterPath + '/swatches/' + key
      type: 'DELETE'
      success: (_data) =>
        @setState swatches: _data

  componentDidMount: ->
    $.get @props.characterPath + '/swatches', (_data) =>
      @setState swatches: _data

  componentDidUpdate: ->
    $('#swatch-menu').collapsible()

  render: ->
    if !@state.swatches?
      `<section className='character-swatches'>
          <div class="progress">
              <div class="indeterminate"></div>
          </div>
      </section>`

    else
      swatches = @state.swatches.map (swatch) ->
        `<div className='swatch' key={ swatch.id } style={{backgroundColor: swatch.color}} />`

      if @props.artistView
        swatchDetails = @state.swatches.map (swatch) ->
          `<Attribute key={ swatch.id }
                      value={ swatch.color }
                      iconColor={ swatch.color }
                      icon='palette'
              {...swatch} />`

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
                            <AttributeTable onAttributeUpdate={ this.editSwatch }
                                            onAttributeCreate={ this.newSwatch }
                                            onAttributeDelete={ this.removeSwatch }
                                            sortable={ true }>
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
