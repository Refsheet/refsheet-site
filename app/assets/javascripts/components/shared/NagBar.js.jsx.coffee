@NagBar = React.createClass

  _handleClear: (e) ->
    Cookies.set '_noNagPlease', 1
    $(@refs.nag).fadeOut()
    e.preventDefault()

  render: ->
    return null if Cookies.get '_noNagPlease'
    { children, action, type } = @props

    if action
      actionButton =
        `<Button href={ action.href } target='_blank' className='right'>{ action.text }</Button>`

    classNames = ['nag-bar', 'white-text']

    switch type
      when 'good' then classNames.push 'teal darken-1'
      when 'bad'  then classNames.push 'red darken-1'
      when 'info' then classNames.push 'cyan darken-1'
      else classNames.push 'blue-grey darken 1'

    `<div className={ classNames.join(' ') } ref='nag'>
        <div className='container'>
            <a href='#' className='nag-clear' onClick={ this._handleClear }>
                <Icon>close</Icon>
            </a>

            <div className='nag-content'>
                { children }
            </div>

            <div className='nag-action'>
                { actionButton }
            </div>
        </div>
    </div>`
