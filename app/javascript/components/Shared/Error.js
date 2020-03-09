/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default ({message}) => {
  const classNames = ['modal-page-content'];

  return <Main className={classNames.join(' ')}>
    <div className='container'>
      <h1>{ message }</h1>
    </div>
  </Main>;
};
