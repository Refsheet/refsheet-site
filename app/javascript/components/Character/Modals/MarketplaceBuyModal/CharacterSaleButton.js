import React from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import c from 'classnames'
import { Icon } from 'react-materialize'
import Button from '../../../Styled/Button'

const CharacterSaleButton = ({ character, className, ...props }) => {
  const {
    marketplace_listing: { amount_currency, amount_cents },
  } = character

  return (
    <Button
      {...props}
      className={c(className, 'btn-secondary character-sale-button')}
    >
      <span className={'for-sale'}>
        <Icon>add_shopping_cart</Icon>
      </span>
      <span className={'price'}>
        {new Intl.NumberFormat('en-US', {
          style: 'currency',
          currency: amount_currency,
        }).format(amount_cents / 100)}
      </span>
    </Button>
  )
}

CharacterSaleButton.propTypes = {
  character: PropTypes.shape({
    marketplace_listing: PropTypes.object.isRequired,
  }),
  className: PropTypes.string,
}

export default styled(CharacterSaleButton)`
  float: right;
  line-height: 3rem;
  height: 3rem;
  vertical-align: middle;
  padding: 0;

  .price {
    padding: 0 1rem;
    display: inline-block;
  }

  .for-sale {
    padding: 0 1rem;
    background-color: rgba(0, 0, 0, 0.1);
    display: inline-block;
  }

  i.material-icons {
    line-height: 3rem;
    vertical-align: middle;
    height: 3rem;
    font-size: 1.5rem;
  }
`
