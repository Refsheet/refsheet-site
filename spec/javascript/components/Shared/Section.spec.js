import React from 'react'
import { mount } from 'enzyme'
import Section from 'components/Shared/Section'

describe('<Section />', function () {
  def('title', () => null)

  subject(() => mount(<Section title={$title} children={"foo"} />))

  it('renders without container', () =>
    expect($subject).not.toContainMatchingElement('.container'))

  context('with container', function () {
    subject(() => mount(<Section container children={"foo"} />))

    return it('renders wit container', () =>
      expect($subject).toContainMatchingElement('.container'))
  })

  return context('with title', function () {
    def('title', () => 'Section Name')

    return it('renders title', function () {
      expect($subject).toContainMatchingElement('h2')
      return expect($subject).toIncludeText('Section Name')
    })
  })
})
