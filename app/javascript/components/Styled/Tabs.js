import { default as MaterialTabs, Tab as MaterialTab } from 'Shared/Tabs'
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

const Tab = styled(MaterialTab)``

export { Tab }

export default Tabs
