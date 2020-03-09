@NumberUtils =
  format: (i) ->
    n = Math.abs i
    switch
      when n < 1e3
        n + ''
      when n < 1e4
        Math.floor(n/1e2)/10 + 'k'
      when n < 1e6
        Math.floor(n/1e3) + 'k'
      when n < 1e7
        Math.floor(n/1e5)/10 + 'm'
      else
        Math.floor(n/1e6) + 'm'
