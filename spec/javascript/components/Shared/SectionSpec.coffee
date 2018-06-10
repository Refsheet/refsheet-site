import React from 'react'
import { expect } from 'chai'
import { mount } from 'enzyme'
import Section from 'Shared/Section'

describe '<Section />', ->
  def 'title', ->
    null

  subject ->
    mount `<Section title={$title} />`

  it 'renders without container', ->
    expect($subject).to.not.have.descendants('.container')

  context 'with container', ->
    subject ->
      mount `<Section container />`

    it 'renders wit container', ->
      expect($subject).to.have.descendants('.container')

  context 'with title', ->
    def 'title', ->
      'Section Name'

    it 'renders title', ->
      expect($subject).to.have.descendants('h2')
      expect($subject).to.have.text('Section Name')
