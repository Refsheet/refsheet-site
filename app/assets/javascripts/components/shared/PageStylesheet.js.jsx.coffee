@PageStylesheet = (props) ->
  otherClasses = {
    '.cs-background--background-color': [
      'body'
      '.chip, .icon-container'
      '.color-helper'
    ]
    '.cs-text--color': [
      'body'
    ]
    '.cs-text-light--color': [
      '.attribute-table .actions a'
      '.chip .icon-container'
      'body #rootApp footer .footer-copyright'
    ]
    '.cs-text-medium--color': [
      '.chip'
      'section.pop-out .caption'
      'section.pop-out .rich-text.empty'
      '.default-value'
      'nav a, body #rootApp footer'
      'label'
    ]
    '.cs-card-background--background-color': [
      '.card'
      '.character-card'
      '.slant'
      '.pop-out'
      '.collapsible'
      'nav, body #rootApp footer.page-footer'
      '.lightbox'
      '.modal'
    ]
    '.cs-primary--color': [
      'h1'
    ]
    '.cs-accent1--background-color': [
      '.btn'
    ]
    '.cs-accent1--color': [
      'h2'
      'code'
      'label.active'
    ]
    '.cs-accent1--border-color': [
      'input:active, textarea:active'
      'blockquote'
    ]
    '.cs-accent2--color': [
      '.attribute-table li:not(.attribute-form) .attribute-data .key'
      'section.pop-out h2'
    ]
  }

  css = ""

  for color, value of props
    for property in ['background-color', 'color', 'border-color']
      className = ".cs-#{color}--#{property}"
      moreClasses = otherClasses[className]?.join(', ')
      className += ", #{moreClasses}" if moreClasses

      css += """
        #{className} {
          #{property}: #{value} !important;
        }\n
      """

  `<style type='text/css'>
      { css }
  </style>`
