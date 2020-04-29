import * as Actions from '../actions'
import { createReducer } from './index'

import { supportModal as defaultState } from 'App/defaultState.json'

const handlers = {
  [Actions.OPEN_SUPPORT_MODAL]: (state, action) => ({
    ...state,
    isOpen: action.isOpen,
  }),
}

export default createReducer(defaultState, handlers)
