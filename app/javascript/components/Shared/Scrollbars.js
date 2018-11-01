import React from 'react'
import PropTypes from 'prop-types'
import { Scrollbars as CustomScrollbars } from 'react-custom-scrollbars'
import { withTheme } from 'styled-components'

const Scrollbars = ({children, theme, ...otherProps}) => {
  console.log({theme, otherProps})

  const renderThumb = ({style, ...props}) =>
      <div {...props} style={{
        ...style,
        backgroundColor: theme.text,
        opacity: '0.8',
        width: '0.5rem',
        borderRadius: '0.25rem'
      }} />

  const renderTrack = ({style, ...props}) =>
      <div {...props} style={{
        ...style,
        backgroundColor: 'transparent',
        right: '0.25rem',
        width: '0.5rem',
        bottom: '0.25rem',
        top: '0.25rem'
      }} />

  return (
      <CustomScrollbars
          autoHide
          autoHeight
          autoHeightMax={400}
          renderThumbVertical={renderThumb}
          renderTrackVertical={renderTrack}
          children={children} />
  )
}

Scrollbars.propTypes = {}

export default withTheme(Scrollbars)
