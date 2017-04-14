@PageStylesheet = React.createClass
  propTypes:
    colorData: React.PropTypes.object.isRequired


  getInitialState: ->
    colorData: @props.colorData

  componentWillReceiveProps: (newProps) ->
    colorData: @props.colorData

  componentDidMount: ->
    $(document).on 'app:color_scheme:update', (e, color_scheme) =>
      @setState colorData: color_scheme.color_data

  componentWillUnmount: ->
    $(document).off 'app:color_scheme:update'


  render: ->
    isDark = (c) ->
      c = c.substring(1) if c[0] == '#'
      rgb = parseInt(c, 16)
      r = rgb >> 16 & 0xff
      g = rgb >> 8 & 0xff
      b = rgb >> 0 & 0xff
      luma = 0.2126 * r + 0.7152 * g + 0.0722 * b
      console.log "Scheme luma: #{luma}"
      luma < 100

    otherClasses = {
      '.cs-background--background-color': [
        'body'
        '.chip, .icon-container'
        '.color-helper'
        '.dropdown-content li:hover'
      ]
      '.cs-text--color': [
        'body'
        'nav a'
      ]
      '.cs-text-light--color': [
        '.attribute-table .actions a'
        '.chip .icon-container'
        '::-moz-placeholder, ::placeholder, ::-webkit-placeholder'
      ]
      '.cs-text-medium--color': [
        '.chip'
        'section.pop-out .caption'
        'section.pop-out .rich-text.empty'
        '.default-value'
        'body #rootApp footer'
        'label'
        '.rich-text.empty'
        '.character-details .date'
        '.lightbox .image-actions a'
        'body #rootApp footer .footer-copyright'
      ]
      '.cs-text-medium--background-color': [
        '.btn.grey.darken-3'
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
        '.modal-header'
        '.modal-footer'
        '.dropdown-content'
        '.card-panel'
      ]
      '.cs-primary--color': [
        'h1'
        'a:not(.btn)'
      ]
      '.cs-accent1--background-color': [
        '.btn'
      ]
      '.cs-accent1--color': [
        'h2'
        '.character-card .character-details h2'
        'code'
        'label.active'
      ]
      '.cs-accent1--border-color': [
        'blockquote'
      ]
      '.cs-accent2--color': [
        '.attribute-table li:not(.attribute-form) .attribute-data .key'
        'section.pop-out h2'
      ]
    }

    css = ""

    for color, value of @state.colorData
      for property in ['background-color', 'color', 'border-color']
        className = ".cs-#{color}--#{property}"
        moreClasses = otherClasses[className]?.join(', ')
        className += ", #{moreClasses}" if moreClasses

        css += """
          #{className} {
            #{property}: #{value} !important;
          }\n
        """

    if @props['accent1']
      css += """
        input:active, textarea:active, input:focus, textarea:focus {
          border-bottom: 1px solid #{@state.colorData['accent1']} !important;
          box-shadow: 0 1px 0 0 #{@state.colorData['accent1']} !important;
        }
      """

    addlCssLight = """
      .logo img, .patreon img {
        filter: brightness(0) invert(1);
      }

      .logo .site-name,
      .logo .dot-net,
      nav a.patreon {
        color: white !important;
      }
    """

    addlCssDark = """
      .logo img, .patreon img {
        filter: brightness(0);
      }

      .logo .site-name,
      .logo .dot-net,
      nav a.patreon {
        color: black !important;
      }
    """

    if @state.colorData['card-background']? && @state.colorData['card-background'] != ''
      hasWhiteLogo = isDark(@state.colorData['card-background'])
      hasDarkLogo  = !isDark(@state.colorData['card-background'])

    `<style type='text/css'>
        { css }
        { hasWhiteLogo && addlCssLight }
        { hasDarkLogo && addlCssDark }
    </style>`
