@Model =
  get: (path, success, error) ->
    @request('GET', path, {}, success, error)

  post: (path, data, success, error) ->
    @request('POST', path, data, success, error)

  put: (path, data, success, error) ->
    @request('PUT', path, data, success, error)

  delete: (path, success, error) ->
    @request('DELETE', path, {}, success, error)

  request: (type, path, data, success, error) ->
    $(document).trigger 'app:loading'
    console.debug "#{type} #{path}", data

    $.ajax
      url: path
      type: type
      data: data
      dataType: 'json'
      success: success

      error: (e) =>
        msg = e.responseJSON || e.responseText
        console.warn "Error sending request: #{JSON.stringify(msg)}"

        if error
          error(msg)
        else
          Materialize.toast msg.error, 3000, 'red' if msg.error

      complete: =>
        $(document).trigger 'app:loading:done'
