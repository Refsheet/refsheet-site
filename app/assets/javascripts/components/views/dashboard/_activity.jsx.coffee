@Dashboard.Activity = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  render: ->
    fakeUrl = ->
      i = [
        'https://s3.amazonaws.com/refsheet-prod/images/images/000/000/006/%s/1483044380.wolnir_ych101.png?1492920243'
        'https://s3.amazonaws.com/refsheet-prod/images/images/000/001/398/%s/MauPort_PostRes.png?1493006941'
        'https://s3.amazonaws.com/refsheet-prod/images/images/000/001/399/%s/MauPort_Night_PostRes.png?1492919942'
        'https://s3.amazonaws.com/refsheet-prod/images/images/000/001/545/%s/FiresightRedux_PostRes.png?1494397581'
      ]

      img = i[Math.floor(Math.random() * i.length)]
      end = {}

      for s in ['medium', 'medium_square', 'small', 'small_square']
        end[s] = img.replace '%s', s
      end

    fakeActivity = (count) =>
      end = {
        user: @context.currentUser
        activityType: 'Image'
        date: '2017-09-01 08:34'
        dateHuman: '1 hour'
        images: []
      }

      for i in [1..count]
        end.images.push { caption: "Image #{i}", url: fakeUrl() }
      end

    activity = []

    for i in [1..10]
      activity.push fakeActivity(i)

    out = activity.map (item, i) ->
      `<Dashboard.ActivityCard {...item} key={i} />`

    `<div>{ out }</div>`
