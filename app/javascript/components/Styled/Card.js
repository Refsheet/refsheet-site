import { Card } from 'react-materialize'
import styled from 'styled-components'
import { buildShadow } from './common'

// TODO: Try and mix admin/moderator colors with the current theme.

export const div = styled.div`
  && {
    background-color: ${props => props.theme.cardBackground};
    box-shadow: ${props => buildShadow(props.theme.cardShadow)};

    &.admin {
    }

    &.moderator {
    }

    .card-header,
    .card-footer,
    .card-action {
      background-color: ${props => props.theme.cardHeaderBackground} !important;
      background-color: rgba(0, 0, 0, 0.1);
    }
  }
`

export default styled(Card)`
  && {
    background-color: ${props => props.theme.cardBackground};
    box-shadow: ${props => buildShadow(props.theme.cardShadow)};

    &.admin {
    }

    &.moderator {
    }

    .card-header,
    .card-footer,
    .card-action {
      background-color: ${props => props.theme.cardHeaderBackground} !important;
      background-color: rgba(0, 0, 0, 0.1);
    }
  }
`
