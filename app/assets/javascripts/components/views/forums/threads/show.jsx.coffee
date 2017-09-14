@Forums.Threads.Show = React.createClass
  render: ->
    `<Main title='November Update!'>
        <div className='card margin-top--none sp'>
            <div className='card-header padding-bottom--none'>
                <div className='right muted right-align'>
                    About 3 hours ago
                </div>

                <div className='author'>
                    <img src='https://placehold.it/64' className='circle avatar left' />
                    <Link to='/users/MauAbata'>Mau Abata</Link>
                    <div className='muted'>Posted 3 hours ago in <Link>Support</Link></div>
                </div>
            </div>
            <div className='card-content'>
                <h2 className='title'>So, we need to talk about bats...</h2>
                <p>Lorem Ipsum something something bats are cute.</p>
            </div>
        </div>

        <div className='card sp with-avatar'>
            <img src='https://placehold.it/64' className='circle avatar' />
            <div className='card-content'>
                <div className='muted right'>Just now</div>
                <Link to='/users/MauAbata'>Mau Abata</Link>
                <p>Bats really are cute! I can't believe we're still having this discussion, I mean, whai....</p>
            </div>
        </div>
    </Main>`
