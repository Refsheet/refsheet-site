import PropTypes from 'prop-types'
import { Query } from 'react-apollo'

const defaultMapDataToProps = (data) => data
const defaultUpdateQuery = (prev) => prev

export default function buildSubscriptionRender(args) {
  const {
    query,
    subscription,
    mapDataToProps = defaultMapDataToProps,
    updateQuery = defaultUpdateQuery
  } = args

  const render = ({Component, ...props}) => ({loading, data, subscribeToMore}) => {
    const subscribe = () => {
      if(loading || !data) return null

      subscribeToMore({
        document: subscription,
        updateQuery: (prev, { subscriptionData }) => {
          console.log({prev, subscriptionData})
          if (!subscriptionData.data) return prev
          return updateQuery(prev, subscriptionData.data)
        }
      })
    }

    const mapped = (data && mapDataToProps && mapDataToProps(data)) || {}
    const wrappedProps = {...props, loading, subscribe, ...mapped}

    const oldUpdate = Component.prototype.componentWillUpdate

    Component.prototype.componentWillUpdate = function(newProps, newState) {
      if (!this._subscribed && !newProps.loading && this.props.loading) {
        console.log("Data found, subscribing for: " + Component.name)
        newProps.subscribe()
        this._subscribed = true
      }

      if(oldUpdate) return oldUpdate.bind(this)(newProps, newState)
    }

    return(<Component {...wrappedProps} />)
  }

  const Wrapped = (props) => (
      <Query query={query}>
        {render(props)}
      </Query>
  )

  Wrapped.propTypes = {
    Component: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.func
    ]).isRequired
  }

  return (Component) => {
    console.log({Component})
    return (props) => <Wrapped {...props} Component={Component} />
  }
}
