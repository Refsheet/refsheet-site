class Api::ApiController < ::ApiController
  skip_before_action :authenticate_from_token, only: [:documentation]
  skip_before_action :force_json, only: [:documentation]

  def documentation
    page_bg_color = '#262626'
    brand_primary = '#26a69a'
    card_bg_color = 'rgb(33,33,33)'
    page_text_color = '#bdbdbd'
    text_light_color = '#c6c6c6'
    border_light_color = '#4c4c4c'

    @redoc_theme = {
        colors: {
            primary: {
                main: brand_primary,
            },
            success: {
                main: '#66bb6a',
            },
            warning: {
                main: '#ff9100',
                contrastText: '#ffffff',
            },
            error: {
                main: '#e53935',
                contrastText: '#ffffff',
            },
            text: {
                primary: page_text_color,
                secondary: text_light_color,
            },
            border: {
                dark: border_light_color,
                light: '#FF00FF',
            }
        },
        schema: {
            linesColor: text_light_color,
            nestedBackground: card_bg_color,
        },
        menu: {
            width: "260px",
            backgroundColor: card_bg_color,
            textColor: page_text_color,
            activeTextColor: brand_primary,
        },
        rightPanel: {
            backgroundColor: card_bg_color,
            width: '40%',
            textColor: page_text_color,
        },
        codeSample: {
            backgroundColor: page_bg_color,
        },
        typography: {
            fontSize: 'inherit',
            lineHeight: 'inherit',
            fontWeightRegular: '400',
            fontWeightBold: '600',
            fontWeightLight: '300',
            fontFamily: 'inherit',
            smoothing: 'antialiased',
            optimizeSpeed: true,
            headings: {
                fontFamily: 'inherit',
                fontWeight: '300',
                lineHeight: '1.6em',
            },
        },
        code: {
            color: '#bdbdbd',
            backgroundColor: card_bg_color,
        }
    }

    render layout: 'static'
  end
end