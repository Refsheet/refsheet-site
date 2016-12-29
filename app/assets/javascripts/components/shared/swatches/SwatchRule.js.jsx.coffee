@SwatchRule = (props) ->
  swatches = props.swatches.map (swatch) ->
    `<div className='swatch' key={ swatch.id } style={{ backgroundColor: swatch.color }} />`

  `<section className='character-swatches'>
      <div className='container'>
          <div className='swatch-container z-depth-1'>
              <div className='swatch-row'>
                  { swatches }
              </div>
          </div>
      </div>
  </section>`
