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
      url: @props.swatchesPath + data.id
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
      url: @props.swatchesPath + key
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
                                        sortable={ true }
                                        valueType='color'>
                            { swatchDetails }
                        </AttributeTable>
                    </div>
                </li>
            </ul>
        </div>
    </section>`
