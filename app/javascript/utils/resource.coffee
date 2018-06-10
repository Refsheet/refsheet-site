import Axios from 'axios'
import { CancelToken } from 'axios'

export get = ({path, request}) ->
  source = CancelToken.source()
  console.log "GET #{path}"

  new Promise (resolve, reject) ->
    Axios.get(path, {cancelToken: source.token})
      .then (req) =>
        { data } = req
        resolve data

      .catch (req) =>
        { data } = req
        error = data?.error || req.statusText
        console.error error, data, req
        reject { error }

    request(source) if request

export put = ({path, params, request}) ->
  source = CancelToken.source()
  console.log "PUT #{path}: #{JSON.stringify(params)}"

  new Promise (resolve, reject) ->
    Axios.put(path, params, {cancelToken: source.token})
      .then (req) =>
        { data } = req
        resolve data

      .catch (req) =>
        { data } = req
        error = data?.error || req.statusText
        console.error error, data, req
        reject { error }

    request(source) if request
