import Color from 'color'

export const buildShadow = (color, zDepth = 1) => {
  let c = new Color(color)
  return (
    `0 2px 2px 0 rgb(${c.red()} ${c.green()} ${c.blue()} / 14%), ` +
    `0 3px 1px -2px rgb(${c.red()} ${c.green()} ${c.blue()} / 12%), ` +
    `0 1px 5px 0 rgb(${c.red()} ${c.green()} ${c.blue()} / 20%)`
  )
}
