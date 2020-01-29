import { Tabs as MaterialTabs } from 'react-materialize'
import styled from 'styled-components'

const Tabs = styled(MaterialTabs)`
  && > li.tab > a {
    color: ${props => props.theme.accent1};

    &:focus,
    &.active:focus {
      background-color: transparent;
    }

    &.active,
    &.active:hover {
      color: ${props => props.theme.primary};
    }

    &:not(.active):hover {
      color: ${props => props.theme.accent2};
    }
  }

  & > li.indicator {
    background-color: ${props => props.theme.primary};
  }
`

export default Tabs
