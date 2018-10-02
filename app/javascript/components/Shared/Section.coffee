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

Button = styled.a"""
  background-color: #{(props) -> props.theme.cardBackground} !important;
  display: inline-block;
  margin: 6px 0 6px 1.5rem;
  float: right;
"""

Section = ({id, className, titleClassName, title, tabs, container, onTabClick, buttons, children}) ->
  `<section id={ id } className={ c(className, {container}) }>
    { title &&
      <div className={ c(titleClassName, {container}) }>
        <Row className='no-margin'>
          <Col m={4}>
            <H2>{ title }</H2>
          </Col>

          <Col m={8} className='right-align'>
            { buttons && buttons.map(renderAction) }

            { tabs &&
              <ul className='tabs transparent right' style={{ display: 'inline-block', width: 'auto' }}>
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
  onClick(id) if onClick

renderTab = (onTabClick) -> ({title, id, onClick}) ->
  onClick ||= onTabClick

  `<li className="tab" key={id}>
    <a href={"#" + id} onClick={actionHandler(onClick, id)}>{title}</a>
  </li>`

renderAction = ({title, id, onClick, icon}) ->
  `<Button className='btn' onClick={actionHandler(onClick, id)}>
    { icon && <Icon className='left'>{ icon }</Icon> }
    { title }
  </Button>`


actionType =
  PropTypes.shape(
    icon: PropTypes.string.isRequired
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
