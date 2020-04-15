import React from 'react'
import PropTypes from 'prop-types'
import { CustomPicker } from 'react-color'
import { Hue, Saturation, Alpha } from 'react-color/lib/components/common'
import styled from 'styled-components'

const ColorPickerOverlay = styled.div`
  background-color: ${props => props.theme.cardBackground};
  position: absolute;
  top: 3rem;
  left: 0;
  width: 14.5rem;
  min-height: 13rem;
  z-index: 99;
  border-radius: 2px;

  &:before {
    display: block;
    content: '';
    position: absolute;
    top: -0.25rem;
    left: 0.5rem;
    height: 0.75rem;
    width: 0.75rem;
    background-color: ${props => props.color};
    transform: rotate(45deg);
    box-shadow: 0 0 4px -1px rgba(0, 0, 0, 0.3);
    z-index: -1;
  }

  .header {
    padding: 0rem 1rem;
    line-height: 2.5rem;
    background-color: ${props => props.color};
    color: ${props => (props.hsl.l > 0.7 ? 'black' : 'white')} !important;
    border-top-right-radius: 2px;
    border-top-left-radius: 2px;

    a {
      color: ${props => (props.hsl.l > 0.7 ? 'black' : 'white')} !important;
      display: block;
      float: right;
      border-top-right-radius: 2px;
      padding: 0 0.5rem;
      margin-right: -1rem;

      i.material-icons {
        line-height: 2.5rem;
        height: 2.5rem;
        font-size: 1.2rem;
      }

      &:hover {
        background-color: rgba(0, 0, 0, 0.5);
      }
    }
  }

  .saturation {
    position: relative;
    height: 9rem;
    width: 100%;
  }

  .hue,
  .alpha {
    position: relative;
    height: 1.5rem;
    width: 100%;
    border-bottom-left-radius: ${props => (props.noColors ? '2px' : '0')};
    border-bottom-right-radius: ${props => (props.noColors ? '2px' : '0')};
  }

  .colors {
    padding: 0.25rem;

    .color {
      height: 1.5rem;
      width: 1.5rem;
      margin: 0.25rem;
      float: left;
      border-radius: 2px;
    }
  }
`

function ColorPicker({
  onChange,
  hsl,
  hsv,
  rgb,
  hex,
  colors = [],
  alpha,
  onClose,
  onFocus,
}) {
  const handleClose = e => {
    e.preventDefault()
    onClose && onClose()
  }

  const applyColor = color => e => {
    e.preventDefault()
    onChange && onChange(color)
  }

  const handleFocus = e => {
    onFocus && onFocus(e)
  }

  return (
    <ColorPickerOverlay
      className={'color-picker-overlay z-depth-2'}
      color={hex}
      hsl={hsl}
      onFocus={handleFocus}
      tabIndex={-1}
      noColors={colors.length === 0}
    >
      <div className={'header'}>
        <a href={'#'} className={'right'} onClick={handleClose}>
          <i className={'material-icons'}>close</i>
        </a>
        {hex}
      </div>
      <div className="saturation">
        <Saturation hsl={hsl} hsv={hsv} hex={hex} onChange={onChange} />
      </div>
      <div className="hue">
        <Hue hsl={hsl} hsv={hsv} hex={hex} onChange={onChange} />
      </div>
      {alpha && (
        <div className={'alpha'}>
          <Alpha hsl={hsl} hsv={hsv} hex={hex} rgb={rgb} onChange={onChange} />
        </div>
      )}
      {colors.length > 0 && (
        <div className="colors">
          {colors.map(color => (
            <a
              key={color}
              href={'#'}
              className={'color'}
              onClick={applyColor(color)}
              style={{ backgroundColor: color }}
            />
          ))}
          <br className="clearfix" />
        </div>
      )}
    </ColorPickerOverlay>
  )
}

ColorPicker.propTypes = {
  color: PropTypes.oneOfType([PropTypes.string, PropTypes.object]),
  colors: PropTypes.arrayOf(PropTypes.string),
  onChangeComplete: PropTypes.func,
}

export default CustomPicker(ColorPicker)
