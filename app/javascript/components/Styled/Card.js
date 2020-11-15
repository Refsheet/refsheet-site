import { Card } from 'react-materialize'
import styled from 'styled-components'

// TODO: Try and mix admin/moderator colors with the current theme.

export const div = styled.div`
  && {
    background-color: ${(props) => props.theme.cardBackground};

    &.admin {
    }

    &.moderator {
    }

    .card-header,
    .card-footer,
    .card-action {
      // background-color: ${(props) => props.theme.cardBackground};
      background-color: rgba(0, 0, 0, 0.1);
    }
  }
`

export default styled(Card)`
  && {
    background-color: ${(props) => props.theme.cardBackground};

    &.admin {
    }

    &.moderator {
    }

    .card-header,
    .card-footer,
    .card-action {
      // background-color: ${(props) => props.theme.cardBackground}
      background-color: rgba(0, 0, 0, 0.1);
    }
  }
`
