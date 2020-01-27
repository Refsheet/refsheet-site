import React from 'react'

const ContactLinks = ({ links }) => {
  return (
    <ul className={'contact-links margin--none'}>
      <li className={'contact-link verified'}>
        <a
          href={'https://twitter.com/helixel'}
          target={'_blank'}
          rel="noopener noreferrer"
        >
          <img
            className={'favicon'}
            height={16}
            width={16}
            src={'https://twitter.com/favicon.ico'}
            alt={'twitter'}
          />
          <span className={'title'}>
            ☠️ Isabella | Izzy ☠️ (@Helixel) / Twitter
          </span>
        </a>
      </li>
      <li className={'contact-link broken'}>
        <a
          href={'https://twitter.com/helixel'}
          target={'_blank'}
          rel="noopener noreferrer"
        >
          <i className={'material-icons'}>link_off</i>
          <span className={'title'}>https://furraffinity.net/helixel</span>
        </a>
      </li>
    </ul>
  )
}

ContactLinks.propTypes = {}

export default ContactLinks
