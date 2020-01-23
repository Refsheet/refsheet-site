import { Card } from 'react-materialize'
import styled from 'styled-components'

export const div = styled.div`
  background-color: ${props => props.theme.cardBackground} !important;
  
  .card-header, .card-footer, .card-action {
    // background-color: ${props => props.theme.cardBackground} !important;
    background-color: rgba(0,0,0,0.1) !important;
  } 

  .caption {
    color: ${props => props.theme.textMedium} !important;
  }
`

export default styled(Card)`
  background-color: ${props => props.theme.cardBackground};

  .card-header, .card-footer, .card-action {
    // background-color: ${props => props.theme.cardBackground} !important;
    background-color: rgba(0,0,0,0.1) !important;
  }

  .caption {
    color: ${props => props.theme.textMedium} !important;
  }
`
