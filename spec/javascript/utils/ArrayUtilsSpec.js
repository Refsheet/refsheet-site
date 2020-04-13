/* global describe,def,it */

import { expect } from 'chai'
import ArrayUtils from 'utils/ArrayUtils'

describe('ArrayUtils', () => {
  def('list', () => [
    '8154c2547189b463',
    '3737e1da6eb5b383',
    '3e5d46af962d83ed',
    '9b4cc73602c112ec',
    'de70cea81383dc56',
    '7e8058f99e543035',
    '4debec923019babc',
    'fe2de8a36c3478fd',
    'f0f8e36ce5d15cce',
    'e960b5fc8e6959ab',
    '4e6cdce983956d68',
    '24bb869f2a694676',
    '0636fc06b1d93f24',
    '4d4f08be528222f7',
    '3a9eccfd7f3dac64',
    'aa670cf88a97e458',
    '1403f6beb6997d03',
    'fcdee529bb69b0e2',
    '4e609d9672907d63',
    '0826d3bde02fc0a6',
    '2f577021b11e0798',
    '67c0c6f2672076c3',
    '3da4adc7c34ffa32',
    '4945b04bae6fbcd9',
    'f45a885933ed5463',
    '28cba99c1e35e18c',
    '5d5b1307aa3f270a',
    'dc5a537069198706',
    '445d487619bbc73d',
  ])

  it('returns same list on missing', () => {
    const newList = ArrayUtils.move($list, 'nacho', 'frenchfry')
    expect(newList).to.eql($list)
  })

  it('places before, moving up', () => {
    const newList = ArrayUtils.move(
      $list,
      '9b4cc73602c112ec',
      '8154c2547189b463',
      true
    )
    expect(newList[0]).to.eql('9b4cc73602c112ec')
    expect(newList[1]).to.eql('8154c2547189b463')
    expect(newList[3]).to.eql('3e5d46af962d83ed')
  })

  it('places after, moving up', () => {
    const newList = ArrayUtils.move(
      $list,
      '9b4cc73602c112ec',
      '8154c2547189b463',
      false
    )
    expect(newList[0]).to.eql('8154c2547189b463')
    expect(newList[1]).to.eql('9b4cc73602c112ec')
    expect(newList[3]).to.eql('3e5d46af962d83ed')
  })

  it('places before, moving down', () => {
    const newList = ArrayUtils.move(
      $list,
      '8154c2547189b463',
      '9b4cc73602c112ec',
      true
    )
    expect(newList[0]).to.eql('3737e1da6eb5b383')
    expect(newList[2]).to.eql('8154c2547189b463')
    expect(newList[3]).to.eql('9b4cc73602c112ec')
  })

  it('places after, moving down', () => {
    const newList = ArrayUtils.move(
      $list,
      '8154c2547189b463',
      '9b4cc73602c112ec',
      false
    )
    expect(newList[0]).to.eql('3737e1da6eb5b383')
    expect(newList[2]).to.eql('9b4cc73602c112ec')
    expect(newList[3]).to.eql('8154c2547189b463')
  })
})
