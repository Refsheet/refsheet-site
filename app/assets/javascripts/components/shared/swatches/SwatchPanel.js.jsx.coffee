@SwatchPanel = React.createClass
  getInitialState: ->
    swatches: @props.swatches

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
      url: '/swatches/' + data.id
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
      url: @props.swatchesPath
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
      url: '/swatches/' + key
      type: 'DELETE'
      success: (_data) =>
        @setState swatches: _data

  componentDidMount: ->
    $('#swatch-menu').collapsible()

  componentDidUpdate: ->
    $('#swatch-menu').collapsible()

  render: ->
    swatches = @state.swatches.map (swatch) ->
        `<div className='swatch' key={ swatch.id } style={{backgroundColor: swatch.color}} />`

    swatchDetails = @state.swatches.map (swatch) ->
      `<Attribute key={ swatch.id }
                  value={ swatch.color }
                  iconColor={ swatch.color }
                  icon='palette'
          {...swatch} />`

    if @props.swatchesPath?
      updateCallback = @editSwatch
      createCallback = @newSwatch
      deleteCallback = @removeSwatch
      
    if @props.expand
      activeClass = 'active'

    `<ul id='swatch-menu' className='collapsible character-swatches'>
        <li>
            <div className={ 'collapsible-header swatch-container ' + activeClass }>
                <div className='swatch-row'>
                    { swatches }
                    <div className='swatch tooltipped' data-tooltip='More Details' data-position='bottom'>
                        <i className='material-icons'>palette</i>
                    </div>
                </div>
            </div>
            <div className='collapsible-body'>
                <AttributeTable onAttributeUpdate={ updateCallback }
                                onAttributeCreate={ createCallback }
                                onAttributeDelete={ deleteCallback }
                                sortable={ true }
                                valueType='color'>
                    { swatchDetails }
                </AttributeTable>
            </div>
        </li>
    </ul>`
