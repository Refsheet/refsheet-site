import React from 'react'
import PropTypes from 'prop-types'
import { Row, Col } from 'react-materialize'
import c from 'classnames'
import styled from 'styled-components'

H2 = styled.h2"""
  color: #{(props) -> props.theme.primary};
  line-height: 48px;
  margin: 0;
"""

Section = ({id, className, titleClassName, title, tabs, container, onTabClick, children}) ->
  `<section id={ id } className={ c(className, {container}) }>
    { title &&
      <div className={ c(titleClassName, {container}) }>
        <Row className='no-margin'>
          <Col m={4}>
            <H2>{ title }</H2>
          </Col>

          <Col m={8} className='right-align'>
            { tabs &&
              <ul className='tabs transparent right'>
                { tabs.map(renderTab(onTabClick)) }
              </ul> }
          </Col>
        </Row>
      </div> }

    <div className={ c({container}) }>
      { children }
    </div>
  </section>`


actionHandler = (onClick, id) -> (e) ->
  e.preventDefault()
  onClick(id)

renderTab = (onTabClick) -> ({title, id, onClick}) ->
  onClick ||= onTabClick

  `<li className="tab" key={id}>
    <a href={"#" + id} onClick={actionHandler(onClick, id)}>{title}</a>
  </li>`


actionType =
  PropTypes.shape(
    title: PropTypes.string.isRequired
    id: PropTypes.string.isRequired
    onClick: PropTypes.func
  )

Section.propTypes =
  id: PropTypes.string
  children: PropTypes.node.isRequired
  title: PropTypes.string
  tabs: PropTypes.arrayOf(actionType)
  buttons: PropTypes.arrayOf(actionType)
  onTabClick: PropTypes.func
  onButtonClick: PropTypes.func
  container: PropTypes.bool
  className: PropTypes.string
  titleClassName: PropTypes.string

export default Section
