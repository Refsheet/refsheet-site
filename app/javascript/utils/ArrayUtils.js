const ArrayUtils = {
  move(list, sourceItem, targetItem, dropBefore = false) {
    let newList = [...list]
    const sourceIndex = newList.indexOf(sourceItem)
    newList.splice(sourceIndex, 1)

    const targetIndex = newList.indexOf(targetItem) + (dropBefore ? 0 : 1)

    if (sourceIndex < 0 || targetIndex < 0) {
      return [...list]
    }

    newList.splice(targetIndex, 0, sourceItem)
    return newList
  },
}

window.ArrayUtils = ArrayUtils

export default ArrayUtils
