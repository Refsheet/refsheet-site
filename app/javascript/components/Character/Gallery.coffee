import { PropTypes } from 'prop-types'

Gallery = ({images}) ->
  imageTiles = images.map (img) ->
    `<div className='col s6 m3'>
      <img src={img.small_square} className='responsive-img block black z-depth-1' />
    </div>`

  `<section id='gallery' className='margin-bottom--large'>
    <div className='container'>
      <div className='row no-margin margin-bottom--large' style={{borderBottom: '1px solid rgba(255,255,255,0.3)'}}>
        <div className='col s12 m4'>
          <h2 className='margin--none'>Main Gallery</h2>
        </div>
        <div className='col s12 m8 right-align'>
          <ul className='tabs transparent margin-bottom--small right'>
            <li className="tab"><a href="#">Scraps</a></li>
            <li className='tab'><a href="#">WIPs</a></li>
          </ul>
        </div>
      </div>

      <div className='row'>
        { imageTiles }
      </div>
    </div>
  </section>`

Gallery.propTypes =
  images: PropTypes.arrayOf(PropTypes.object)

export default Gallery
