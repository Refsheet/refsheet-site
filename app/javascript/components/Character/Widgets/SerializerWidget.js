/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const SerializerWidget = props => <div className='card-content'>
  <code>{ JSON.stringify(props) }</code>
</div>;

export default SerializerWidget;
