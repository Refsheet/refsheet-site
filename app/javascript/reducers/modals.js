import * as Actions from '../actions'
import { createReducer } from './index'

import defaultState from 'App/defaultState.json'


const handlers = {
  [Actions.OPEN_MODAL]: (state, action) => ({
    ...state,
    [action.modal]: {
      ...state[action.modal],
      open: action.open,
    },
  }),
}

export default createReducer(defaultState.modals, handlers)
