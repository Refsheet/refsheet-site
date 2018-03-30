import { Card } from 'react-materialize'
import styled from 'styled-components'

export const div = styled.div`
  background-color: ${props => props.theme.cardBackground} !important;
`

export default styled(Card)`
  background-color: ${props => props.theme.cardBackground};
`
