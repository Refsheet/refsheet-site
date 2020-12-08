export default function e(cb, getArgs = null) {
  return e => {
    e.preventDefault()
    cb && cb(getArgs && getArgs())
  }
}
