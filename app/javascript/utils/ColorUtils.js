import Color from 'color'

const ColorUtils = {
  /**
   * Converts V1 to V2 color data. This clobbers any existing V2 syntax.
   * @param v1ColorData
   */
  convertV1(v1ColorData) {
    let v2ColorData = { ...v1ColorData }

    Object.keys(v1ColorData)
      .filter(k => /-/.test(k))
      .map(k => {
        v2ColorData[
          k.replace(
            /([a-z])-([a-z])/g,
            ($0, $1, $2) => `${$1}${$2.toUpperCase()}`
          )
        ] = v1ColorData[k]
      })

    return v2ColorData
  },

  /**
   * Converts V2 to V1 color data. This does NOT clobber existing V1 syntax.
   * @param v2ColorData
   */
  convertV2(v2ColorData) {
    let v1ColorData = { ...v2ColorData }

    Object.keys(v2ColorData)
      .filter(k => /[a-z][A-Z]/.test(k))
      .map(k => {
        const key = k.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase()
        if (!v1ColorData[key]) v1ColorData[key] = v2ColorData[k]
      })

    return v1ColorData
  },

  /**
   * Generates a V1 + V2 compatible object by converting input->v2->v1 in sequence.
   * @param colorData
   */
  indifferent(colorData) {
    return this.convertV1(this.convertV2(colorData))
  },
}

export default ColorUtils
