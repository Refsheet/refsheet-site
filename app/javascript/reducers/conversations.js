import { createReducer } from 'reducers'
import * as Actions from 'actions'
import defaultState from 'App/defaultState.json'

const handlers = {
  [Actions.OPEN_CONVERSATION]: (state, action) => {
    const openConversations = state.openConversations.filter(
      i => i !== action.conversationId
    )

    return {
      ...state,
      openConversations: [...openConversations, action.conversationId],
    }
  },

  [Actions.CLOSE_CONVERSATION]: (state, action) => {
    const openConversations = state.openConversations.filter(
      i =>
        i !== action.conversationId &&
        action.conversationId &&
        action.conversationId.username &&
        i.username !== action.conversationId.username
    )

    return {
      ...state,
      openConversations,
    }
  },
}

export default createReducer(defaultState.conversations, handlers)
