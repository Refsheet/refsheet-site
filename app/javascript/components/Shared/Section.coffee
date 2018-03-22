import PropTypes from 'prop-types'

actionHandler = (onClick, id) -> (e) ->
  e.preventDefault()
  onClick(id)

renderTab = (onTabClick) -> ({title, id, onClick}) ->
  onClick ||= onTabClick

  `<li className="tab" key={id}>
    <a href={"#" + id} onClick={actionHandler(onClick, id)}>{title}</a>
  </li>`

Section = ({id, title, tabs, buttons, onTabClick, onButtonClick, children}) ->
  `<section id={ id } className='margin-bottom--large'>
    { title &&
      <div className='container' style={{borderBottom: '1px solid rgba(255,255,255,0.3)'}}>
        <div className='row no-margin'>
          <div className='col s12 m4'>
            <h2 className='margin--none'>{ title }</h2>
          </div>
          <div className='col s12 m8 right-align'>
            { tabs &&
              <ul className='tabs transparent right'>
                { tabs.map(renderTab(onTabClick)) }
              </ul> }
          </div>
        </div>
      </div> }

    <div className='container'>
      { children }
    </div>
  </section>`

actionType =
  PropTypes.shape(
    title: PropTypes.string.isRequired
    id: PropTypes.string.isRequired
    onClick: PropTypes.func
  )

Section.propTypes =
  id: PropTypes.string.isRequired
  children: PropTypes.node.isRequired
  title: PropTypes.string
  tabs: PropTypes.arrayOf(actionType)
  buttons: PropTypes.arrayOf(actionType)
  onTabClick: PropTypes.func
  onButtonClick: PropTypes.func

export default Section
