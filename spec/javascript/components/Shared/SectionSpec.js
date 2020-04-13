/* do-not-disable-eslint
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react'
import { expect } from 'chai'
import { mount } from 'enzyme'
import Section from 'Shared/Section'

describe('<Section />', function() {
  def('title', () => null)

  subject(() => mount(<Section title={$title} />))

  it('renders without container', () =>
    expect($subject).to.not.have.descendants('.container'))

  context('with container', function() {
    subject(() => mount(<Section container />))

    return it('renders wit container', () =>
      expect($subject).to.have.descendants('.container'))
  })

  return context('with title', function() {
    def('title', () => 'Section Name')

    return it('renders title', function() {
      expect($subject).to.have.descendants('h2')
      return expect($subject).to.have.text('Section Name')
    })
  })
})
