import PropTypes from 'prop-types'
import { Query } from 'react-apollo'
import React from 'react'

const defaultMapDataToProps = data => data
const defaultUpdateQuery = prev => prev
const defaultMapPropsToVariables = props => props

export default function buildSubscriptionRender(args) {
  const {
    query,
    subscription,
    mapDataToProps = defaultMapDataToProps,
    updateQuery = defaultUpdateQuery,
    mapPropsToVariables = defaultMapPropsToVariables,
  } = args

  const render = ({ Component, ...props }) => ({
    loading,
    data,
    subscribeToMore,
    ...more
  }) => {
    const subscribe = () => {
      if (loading || !data) return null

      const variables = mapPropsToVariables(props)

      console.debug('Subscription info: ', { variables, subscription })

      subscribeToMore({
        document: subscription,
        variables,
        updateQuery: (prev, { subscriptionData }) => {
          console.log({ prev, subscriptionData })
          if (!subscriptionData.data) return prev
          return updateQuery(prev, subscriptionData.data)
        },
      })
    }

    const mapped = (data && mapDataToProps && mapDataToProps(data)) || {}
    const wrappedProps = {
      ...props,
      loading,
      subscribe,
      data,
      ...mapped,
      ...more,
    }

    if (!Component._subscribed && !loading) {
      console.debug('Data found, subscribing for: ' + Component.name)
      subscribe()
      Component._subscribed = true
    }

    return <Component {...wrappedProps} />
  }

  const Wrapped = props => (
    <Query query={query} variables={mapPropsToVariables(props)}>
      {render(props)}
    </Query>
  )

  // Wrapped.propTypes = {
  //   Component: PropTypes.oneOfType([PropTypes.string, PropTypes.func])
  //     .isRequired,
  // }

  return Component => {
    return props => <Wrapped {...props} Component={Component} />
  }
}
