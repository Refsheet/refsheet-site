import React from 'react'
import { withTheme, injectGlobal } from 'styled-components'

const GlobalStyle = ({theme, children}) => {
  console.log("injecting global")

  injectGlobal`
    body {
      color: ${theme.text} !important;
      background-color: ${theme.background} !important;
    }

    a {
      color: ${theme.accent1};

      &:hover, &:active {
        color: ${theme.accent2};
      }
    }
    
    .card {
      background-color: ${theme.cardBackground} !important;
    }
  `

  console.log("injected");

  return (
      <style></style>
  );
}

export default withTheme(GlobalStyle)
