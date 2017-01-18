@Footer = (props) ->
  `<footer className="page-footer grey darken-3">
      <Section>
          <p className='center-align'>Twitter <a target='_blank' href='https://twitter.com/refsheet'>@refsheet</a> for news and bug reports.</p>
      </Section>
      <Section className="footer-copyright">
          <Row>
              <Column s='12' m='6'>
                  &copy;2017 // A Sitehive project
              </Column>
              <Column s='12' m='6' className='right-align'>
                  We're in OPEN alpha! <Link to='/register'>Try it out!</Link>
              </Column>
          </Row>
      </Section>
  </footer>`
