import styled from 'styled-components'
import { buildShadow } from './common'

const SubfolderButton = styled.a`
  display: block;
  background-color: ${props => props.theme.cardBackground} !important;
  box-shadow: ${props => buildShadow(props.theme.cardShadow)};
  padding: 1rem;
  padding-left: 4rem;
  position: relative;

  i.material-icons {
    color: ${props => props.theme.textLight};
    font-size: 2rem;
    position: absolute;
    top: 1rem;
    left: 1rem;
  }

  .gallery-name {
    font-size: 1.2rem;
  }

  .gallery-meta {
    color: ${props => props.theme.textMedium};
    font-size: 0.9rem;
  }
`

export default SubfolderButton
