import React from 'react'
import PropTypes from 'prop-types'
import { Scrollbars as CustomScrollbars } from 'react-custom-scrollbars'
import { withTheme } from 'styled-components'

const Scrollbars = ({ children, theme, maxHeight, ...otherProps }) => {
  const renderThumb = ({ style, ...props }) => (
    <div
      {...props}
      style={{
        ...style,
        backgroundColor: theme.primary,
        opacity: '0.8',
        width: '0.3rem',
        borderRadius: '0.15rem',
      }}
    />
  )

  const renderTrack = ({ style, ...props }) => (
    <div
      {...props}
      style={{
        ...style,
        backgroundColor: 'transparent',
        right: '0.1rem',
        width: '0.3rem',
        bottom: '0.1rem',
        top: '0.1rem',
      }}
    />
  )

  return (
    <CustomScrollbars
      autoHide
      autoHeight
      autoHeightMax={maxHeight || 400}
      renderThumbVertical={renderThumb}
      renderTrackVertical={renderTrack}
    >
      {children}
    </CustomScrollbars>
  )
}

Scrollbars.propTypes = {}

export default withTheme(Scrollbars)
