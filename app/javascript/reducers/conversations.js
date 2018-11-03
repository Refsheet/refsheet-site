import { createReducer } from 'reducers'
import * as Actions from 'actions'

const handlers = {
  [Actions.OPEN_CONVERSATION]: (state, action) => {
    const openConversations = state.openConversations.filter(i => i !== action.conversationId)

    return {
        ...state,
        openConversations: [
            ...openConversations,
            action.conversationId
        ]
    }
  }
}

export default createReducer({}, handlers)
