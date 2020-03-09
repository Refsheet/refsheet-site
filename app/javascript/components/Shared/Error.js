export default ({message}) =>
  classNames = ['modal-page-content']

  `<Main className={classNames.join(' ')}>
    <div className='container'>
      <h1>{ message }</h1>
    </div>
  </Main>`
