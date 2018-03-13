import PropTypes from 'prop-types'
import ProfileColumn from './ProfileColumn'
import { Component } from 'react'

#ProfileSection = ({columns, id}) ->
export default class ProfileSection extends Component
  @propTypes:
    columns: PropTypes.array.isRequired
    id: PropTypes.string.isRequired
    onChange: PropTypes.func
    editable: PropTypes.bool

  constructor: (props) ->
    super props
    @state =
      editable: false

  toggleLock: (e) =>
    e.preventDefault()
    @setState editable: !@state.editable

  render: ->
    { columns } = @props
    { editable } = @state

    sectionColumns = columns.map (column) ->
      `<ProfileColumn key={column.id} {...column} editable={editable} />`

    `<div className='row'>
      <div className='col s12 right-align'>
        <a href='#' onClick={this.toggleLock} className='btn btn-flat'>Edit Section</a>
      </div>
      { sectionColumns }
    </div>`

#ProfileSection.prototype.propTypes =
#  columns: PropTypes.array.isRequired
#  id: PropTypes.string.isRequired
#  onChange: PropTypes.func
#  editable: PropTypes.bool
#
#export default ProfileSection
