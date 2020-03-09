@Views.Character.Attributes = React.createClass
  propTypes:
    characterPath: React.PropTypes.string.isRequired
    attributes: React.PropTypes.array.isRequired
    onChange: React.PropTypes.func.isRequired
    editable: React.PropTypes.bool

  _handleAttributeUpdate: (attr, complete, error) ->
    Model.post @props.characterPath + '/attributes', custom_attributes: attr, (data) =>
      @props.onChange(data)
      complete() if complete
    , error

  _handleAttributeDelete: (id) ->
    Model.delete @props.characterPath + '/attributes/' + id, (data) =>
      @props.onChange(data)

  render: ->
    if @props.editable
      updateCallback = @_handleAttributeUpdate
      deleteCallback = @_handleAttributeDelete

    else
      return null if !@props.attributes || @props.attributes.length <= 0

    attributes = @props.attributes.map (attr) ->
      `<Attribute key={ attr.id } {...attr} />`

    `<AttributeTable onAttributeUpdate={ updateCallback }
                     onAttributeDelete={ deleteCallback }
                     onAttributeCreate={ updateCallback }
                     defaultValue='Unspecified'
                     className='char-custom-attrs'
                     editable={ this.props.editable }
                     hideNotesForm
                     hideIcon
                     sortable
    >
        { attributes }
    </AttributeTable>`
