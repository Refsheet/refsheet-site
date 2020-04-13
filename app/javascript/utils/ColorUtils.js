import Color from 'color'

const ColorUtils = {
  convertV1(v1ColorData) {
    let v2ColorData = { ...v1ColorData }

    Object.keys(v1ColorData).map(k => {
      if (/-/.test(k)) {
        v2ColorData[
          k.replace(/([a-z])-([a-z])/g, ($1, $2) => `${$1}${$2.toUpperCase()}`)
        ] = v1ColorData[k]
      }
    })

    return v2ColorData
  },
}

export default ColorUtils
