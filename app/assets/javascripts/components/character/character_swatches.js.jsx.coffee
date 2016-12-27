@CharacterSwatches = (props) ->
  swatches = props.swatches.map (swatch) ->
    `<div className='swatch tooltipped' style={{backgroundColor: swatch}} data-tooltip={ swatch } data-position="top" data-delay='0' />`

  `<section className='character-swatches'>
      <div className='container'>
          <div className='swatch-row'>
              { swatches }
          </div>
      </div>
  </section>`
