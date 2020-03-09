/* eslint-disable
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.InfiniteScroll = React.createClass({
  propTypes: {
    onLoad: React.PropTypes.func.isRequired,
    params: React.PropTypes.object.isRequired,
    perPage: React.PropTypes.number,
    scrollOffset: React.PropTypes.number,
    count: React.PropTypes.number,

    stateLink: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.func
    ]).isRequired
  },

  getDefaultProps() {
    return {
      perPage: 24,
      count: 0
    };
  },

  getInitialState() {
    return {
      page: 1,
      lastPage: false, // @props.count > 0 and @props.count < @props.perPage
      loading: false
    };
  },

  componentWillReceiveProps(newProps) {},
//    if newProps.count < newProps.perPage
//      @setState lastPage: true
//    else
//      @setState lastPage: false

  componentDidMount() {
    return $(window).on('scroll.infinite-scroll', () => {
      if (!this.state.lastPage && !this.state.loading && (($(window).scrollTop() + $(window).height()) > ($(document).height() - (this.props.scrollOffset || 100)))) {
        return this._fetch();
      }
    });
  },

  componentWillUnmount() {
    return $(window).off('scroll.infinite-scroll');
  },

  _fetch() {
    const fetchUrl = StateUtils.getFetchUrl(this.props.stateLink, {params: (this.props.match != null ? this.props.match.params : undefined)});
    const data = {page: parseInt(this.state.page) + 1};

    return this.setState({loading: true}, () => {
      return Model.request('GET', fetchUrl, data, fetchData => {
        const path = typeof this.props.stateLink === 'function' ? this.props.stateLink().statePath : this.props.stateLink.statePath;
        const items = ObjectPath.get(fetchData, path);
        const meta  = fetchData.$meta;

        console.debug("Infinite done:", items, meta);

        const lastPage = items.length < (this.props.perPage || 24);
        return this.setState({page: meta.page, lastPage, loading: false}, () => {
          return this.props.onLoad(items);
        });
      });
    });
  },

  _loadMore(e) {
    this._fetch();
    return e.preventDefault();
  },

  render() {
    return <div className='infinite-scroll'>
        { !this.state.lastPage && !this.state.loading &&
            <div className='margin-top--large center'>
                <Button href='#' onClick={ this._loadMore } large block className='btn-flat grey darken-4 white-text'>Load More...</Button>
            </div> }

        { this.state.loading &&
            <div className='margin-top--large center'>
                <Spinner small />
            </div> }
    </div>;
  }
});

