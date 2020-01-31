@Spinner = v1 -> (props) ->
  classNames = ['preloader-wrapper']
  classNames.push 'active' unless props.inactive
  classNames.push 'big' unless props.small
  classNames.push 'center-by-margin' if props.center
  classNames.push props.className if props.className

  `<div className={ classNames.join(' ') }>
      <div className="spinner-layer spinner-teal">
          <div className="circle-clipper left">
              <div className="circle"></div>
          </div>
          <div className="gap-patch">
              <div className="circle"></div>
          </div>
          <div className="circle-clipper right">
              <div className="circle"></div>
          </div>
      </div>
  </div>`
