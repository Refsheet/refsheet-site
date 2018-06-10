import PropTypes from 'prop-types'

RichTextWidget = ({content, contentHtml, title}) ->
  `<div className='rich-text-widget'>
    { title &&
      <div className='card-header'>
        <h2>{ title }</h2>
      </div> }

    <div className='card-content rich-text'>
      { contentHtml && contentHtml.length > 0
          ? <div dangerouslySetInnerHTML={ { __html: contentHtml } }/>
          : <p className='caption'>This section unintentionally left blank.</p> }
    </div>
  </div>`

RichTextWidget.propTypes =
  content: PropTypes.string
  contentHtml: PropTypes.string.isRequired

export default RichTextWidget
