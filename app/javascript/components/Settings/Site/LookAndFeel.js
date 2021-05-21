import React, { useState } from 'react'
import { div as Card } from '../../Styled/Card'
import Button from '../../Styled/Button'
import { Col, Select, Switch } from 'react-materialize'
import Restrict from '../../Shared/Restrict'
import { connect } from 'react-redux'
import PropTypes from 'prop-types'
import { setThemeSettings } from '../../../actions'
import InputRow from '../shared/InputRow'

const LookAndFeel = ({ theme = {}, setThemeSettings }) => {
  const [saving, setSaving] = useState(false)

  const handleSubmit = e => {
    setSaving(true)
    setTimeout(() => setSaving(false), 3000)
    e.preventDefault()
  }

  const handleChange = (value, id) => {
    const name = id.replace('theme_', '')
    let newTheme = {}
    newTheme[name] = value
    setThemeSettings(newTheme)
  }

  return (
    <form onSubmit={handleSubmit}>
      <Card className={'card sp'}>
        <div className={'card-header'}>
          <h2>Look and Feel</h2>
        </div>

        <div className={'card-content'}>
          <InputRow
            id={'theme_name'}
            hint={'Default color scheme to apply site-wide.'}
            label={'Color Scheme'}
            input={Select}
            onChange={handleChange}
            value={theme.name}
          >
            <option value={'dark'}>Dark (Default)</option>
            <option value={'light'}>Light</option>
            <option value={'black'}>Pitch Black</option>
            <option value={'white'}>Paper White</option>
            <Restrict development>
              <option value={'debug'}>Debug</option>
            </Restrict>
          </InputRow>

          <InputRow
            id={'theme_allow_override'}
            label={'Allow Override'}
            hint={'Allow character profiles to override site color theme.'}
            input={Switch}
            onChange={handleChange}
            value={theme.allowOverride}
          />

          <InputRow
            id={'theme_allow_holidays'}
            label={'Allow Holiday Themes'}
            hint={
              'Automatically apply various holiday and special event themes.'
            }
            input={Switch}
            onChange={handleChange}
            value={theme.allowHoliday}
          />

          <div className={'row'}>
            <Col s={12}>
              <strong>inb4</strong>: This feature isn't finished, the color
              scheme will revert when you reload the page, save does nothing,
              and the two toggle buttons don't actually really work.
              <br />
              <br />
              If for some reason it does start working, I forgot to remove this
              error message. It's just that way sometimes, I'm doing like 90
              things at once and really want to get features out but like, just
              out enough to be *there* to play with, and I'll finish them later
              when I've had a break and a beer.
              <br />
              <br />
              If you REALLY, REALLY want this feature done, I GUESS you can ask.
            </Col>
          </div>
        </div>

        <div className={'card-action right-align'}>
          <Button type={'submit'} disabled={saving}>
            {saving ? 'Saving...' : 'Save Settings'}
          </Button>
        </div>
      </Card>
    </form>
  )
}

LookAndFeel.propTypes = {
  theme: PropTypes.shape({
    id: PropTypes.string,
    name: PropTypes.string,
    allowHoliday: PropTypes.bool,
    allowOverride: PropTypes.bool,
  }),
  setThemeSettings: PropTypes.func,
}

const mapStateToProps = ({ theme }) => ({
  theme,
})

const mapDispatchToProps = {
  setThemeSettings,
}

export default connect(mapStateToProps, mapDispatchToProps)(LookAndFeel)
