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
    { contentHtml, title, placeholder } = @props
    { content } = @state

    outerClassNames = []
    headerClassNames = []
    bodyClassNames = ['rich-text']

    if @props.renderAsCard
      outerClassNames.push 'card'
      headerClassNames.push 'card-header'
      bodyClassNames.push 'card-content'

    `<div className={ outerClassNames.join(' ') }>
      { title &&
        <div className={ headerClassNames.join(' ') }>
          <h2>{ title }</h2>
        </div> }

      <div className={ bodyClassNames.join(' ') }>
        { content && content.length > 0
            ? <div dangerouslySetInnerHTML={ { __html: contentHtml } }/>
            : <p className='caption'>{ placeholder || "This section unintentionally left blank." }</p> }
      </div>
    </div>`
