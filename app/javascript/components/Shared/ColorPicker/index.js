import React from 'react'
import PropTypes from 'prop-types'
import { CustomPicker, SketchPicker } from 'react-color'
import { Hue, Saturation, Alpha } from 'react-color/lib/components/common'

function ColorPicker({onChange, hsl, hsv, hex, colors}) {
  const styles = {
    overlay: {
      position: "absolute",
      left: 0,
      right: 0,
      height: "15rem",
      zIndex: 99,
      top: "3.5rem",
      backgroundColor: "white",
    },

    hue: {
      position: "relative",
      height: "1rem",
      width: "100%",
    },

    saturation: {
      position: "relative",
      height: "9rem",
      width: "100%",
    },

    colorWrapper: {
      height: "3rem",
      padding: "0.25rem",
    },

    colors: {
      height: "1.5rem",
      width: "20%",
      float: "left",
      margin: "0.25rem",
    }
  }

  colors = [
    'black', 'white', 'red', 'yellow', 'green', 'cyan', 'blue', 'magenta', 'orange'
  ]

  return (
    <div className={'color-picker-overlay z-depth-2'} style={styles.overlay}>
      <div style={styles.saturation}>
        <Saturation hsl={hsl} hsv={hsv} hex={hex} onChange={onChange} style={styles.saturation} />
      </div>
      <div style={styles.hue}>
        <Hue hsl={hsl} hsv={hsv} hex={hex} onChange={onChange} style={styles.hue} />
      </div>
      <div style={styles.colorWrapper}>{
        colors.map(color => (
          <div key={color} style={{...styles.colors, backgroundColor: color}} />
        ))
      }</div>
    </div>
  )
}

ColorPicker.propTypes = {
  color: PropTypes.string,
  colors: PropTypes.arrayOf(PropTypes.string),
  onChangeComplete: PropTypes.func
}

export default CustomPicker(ColorPicker)