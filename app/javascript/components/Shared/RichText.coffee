import { Component } from 'react'

export default class RichText extends Component
  constructor: (props) ->
    super props
    @state =
      content: props.content

  componentWillReceiveProps: (newProps) ->
    if @state.content isnt newProps.content
      @setState content: newProps.content

  handleSubmit: (e) =>
    e.preventDefault()
    data = {}
    data[@props.name] = @state.content
    @props.onChange data

  handleChange: (e) =>
    @setState content: e.target.value

  render: ->
    {contentHtml} = @props
    {content} = @state

    `<div className='rich-text'>
      <div dangerouslySetInnerHTML={{__html: contentHtml}} />
      <form onSubmit={this.handleSubmit}>
        <textarea name='content' value={content} onChange={this.handleChange}/>
        <button type='submit'>Save</button>
      </form>
    </div>`
