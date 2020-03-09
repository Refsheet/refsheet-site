@ArrayUtils =
  pluck: (array, key) ->
    array.map (o) -> o[key]

  diff: (array_1, array_2) ->
    array_1.filter (i) -> array_2.indexOf(i) < 0
