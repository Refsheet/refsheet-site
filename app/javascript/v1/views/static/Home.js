import React from 'react'
import createReactClass from 'create-react-class'
import { connect } from 'react-redux'
import { Link } from 'react-router-dom'
import Main from '../../../components/Shared/Main'
import Jumbotron from '../../../components/Shared/Jumbotron'
import Section from '../../../components/Shared/Section'
import Row from '../../shared/material/Row'
import Column from '../../shared/material/Column'
import PageHeader from '../../shared/PageHeader'
import Attribute from '../../shared/attributes/attribute'
import SwatchPanel from '../../shared/swatches/SwatchPanel'
import Views from '../../views/_views'
import AttributeTable from '../../shared/attributes/attribute_table'

const cHome = createReactClass({
  componentDidMount() {
    // return $('.materialboxed').materialbox()
  },

  render() {
    if (this.props.currentUser) {
      return <Views.Account.Show {...this.props} />
    }

    const demoSwatches = [
      { name: 'Light Fur', color: '#fdf2d4', id: 0 },
      { name: 'Dark Fur', color: '#b5a67e', id: 1 },
      { name: 'Hair', color: '#402b2b', notes: 'Shades may vary.', id: 2 },
      { name: 'Eyes', color: '#2a3c1e', id: 3 },
      { name: 'Markings', color: '#99b734', id: 4 },
    ]

    return (
      <Main title="Refsheet.net: Your Characters, Organized.">
        <Jumbotron backgroundImage="https://assets.refsheet.net/assets/unsplash/typewriter.jpg">
          <h1>
            Your characters, <strong>organized.</strong>
          </h1>
          <p className="flow-text">
            Let Refsheet help you commission, share, and socialize
          </p>
          <div className="jumbotron-action">
            <Link to="/register" className="btn btn-large">
              Get Started
            </Link>
          </div>
        </Jumbotron>

        <Section container className="pop-out">
          <div className="flow-text center">
            A new, convenient way to organize your character designs and art.
          </div>
          <div className="margin-top--large">
            <Row>
              <Column s={12} m={4}>
                <div className="card card-light">
                  <div className="card-image">
                    <img
                      src="https://assets.refsheet.net/assets/marketing/feature_profile.png"
                      alt="Character Profiles"
                      className="materialboxed"
                    />
                  </div>
                  <div className="card-content">
                    <div className="card-title">Character Profiles</div>
                    <p>
                      One link to your character's profile is worth more than a
                      thousand words. Save time typing out descriptions,{' '}
                      <em>send a Refsheet</em>.
                    </p>
                  </div>
                </div>
              </Column>

              <Column s={12} m={4}>
                <div className="card card-light">
                  <div className="card-image">
                    <img
                      src="https://assets.refsheet.net/assets/marketing/feature_color_palette.png"
                      alt="Color Palettes"
                      className="materialboxed"
                    />
                  </div>
                  <div className="card-content">
                    <div className="card-title">Color Palettes</div>
                    <p>
                      Figuring out what color to sample can be ambiguous. Remove
                      the confusion and define one source of truth for your
                      color palette.
                    </p>
                  </div>
                </div>
              </Column>

              <Column s={12} m={4}>
                <div className="card card-light">
                  <div className="card-image">
                    <img
                      src="https://assets.refsheet.net/assets/marketing/feature_gallery.png"
                      alt="Art Galleries"
                      className="materialboxed"
                    />
                  </div>
                  <div className="card-content">
                    <div className="card-title">Art Galleries</div>
                    <p>
                      A lot of time and money went into your character's
                      artwork. Share and show off your images!
                    </p>
                  </div>
                </div>
              </Column>
            </Row>
          </div>
        </Section>

        <PageHeader backgroundImage="https://assets.refsheet.net/assets/unsplash/bamboo.jpg">
          <div className="character-card">
            <div className="character-details">
              <h1 className="real-name">Beautiful Presentation</h1>
              <p>
                Using modern Material design by Google, and a fast, responsive
                ReactJS powered front-end, your characters will be presented in
                a beautiful and interactive format, suitable for whichever
                device is viewing it.
              </p>
              <p>
                Styles are designed to create visual consistency across the
                site, unifying the presentation of references and making it
                easier to find the information you need. Each character can set
                custom colors for their page, balancing unique and uniform
                styles.
              </p>
            </div>
            <div className="character-image">
              <div className="slant" />
              <img src="https://assets.refsheet.net/assets/unsplash/yawn.jpg" />
            </div>
          </div>
        </PageHeader>

        <Section container id="easy-to-use" className="padded-bottom">
          <div className="row">
            <div className="col m5 s12">
              <div className="card-panel">
                <h2 className="name">James the Hunter</h2>
                <AttributeTable
                  onAttributeUpdate={function (e, cb) {
                    if (cb) {
                      cb(e)
                    }
                  }}
                  sortable={true}
                  hideNotesForm={true}
                  freezeName="true"
                >
                  <Attribute name="Name" value="James the Hunter" />
                  <Attribute name="Species" value="Humanoid" />
                  <Attribute name="Age" value="135 years" />
                  <Attribute name="Favorite Color" value={null} />
                </AttributeTable>
              </div>
            </div>

            <div className="col m6 offset-m1 s12">
              <h1>Easy to Use</h1>
              <p>
                The hard part was making the character, documenting it should be
                easy. This is why we offer in-place editing on many fields
                without the need to ever reload a page.
              </p>
              <p>
                Go ahead and give James over there a favorite color. (It won't
                save, though, James the Hunter isn't a real character. Perhaps
                you should <Link to="/register">make your own?</Link>)
              </p>
            </div>
          </div>
        </Section>

        <Section container className="padded-bottom" id="detailed-reference">
          <div className="padding-bottom--large">
            <SwatchPanel swatches={demoSwatches} expand={true} />
          </div>

          <Row>
            <Column s={12}>
              <h1>Detailed Reference</h1>
            </Column>

            <Column s={12} m={6}>
              <p>
                Sampling colors off an image can be ambiguous and confusing.
                Refsheet removes this confusion by giving character creators an
                easy-to-use color palette to specify the exact color for each
                important aspect of your character.
              </p>
            </Column>

            <Column s={12} m={6}>
              <p>
                Artists can copy the hexadecimal codes into whichever editor
                they are using, or get a pure sample without any compression or
                alias artifacts right from the color swatch or color rule.
              </p>
            </Column>
          </Row>
        </Section>

        <Section container className="center padded-bottom">
          <h2>Ready to show off your characters?</h2>
          <Link to="/register" className="btn">
            Sign Up
          </Link>
        </Section>
      </Main>
    )
  },
})

const mapStateToProps = state => ({ currentUser: state.session.currentUser })
const Home = connect(mapStateToProps)(cHome)
export default Home
