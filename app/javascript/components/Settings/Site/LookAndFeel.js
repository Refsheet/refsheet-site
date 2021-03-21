import React, { useState } from 'react'
import { div as Card } from '../../Styled/Card'
import Button from '../../Styled/Button'
import { Col, Select, TextInput, Switch } from 'react-materialize'
import Restrict from '../../Shared/Restrict'
import { connect } from 'react-redux'
import PropTypes from 'prop-types'
import { setThemeSettings } from '../../../actions'

const InputRow = ({
  label,
  id,
  hint,
  input: Component = TextInput,
  children,
  onChange = () => {},
  value: defaultValue,
  ...props
}) => {
  const [value, setValue] = useState(defaultValue)
  let inputContainer

  const handleChange = e => {
    if (Component !== Switch) {
      setValue(e.target.value)
      onChange(e.target.value, id)
    } else {
      setValue(e.target.checked)
      onChange(e.target.checked, id)
    }
  }

  if (Component !== Switch) {
    inputContainer = (
      <Component
        id={id}
        s={12}
        m={4}
        value={value}
        onChange={handleChange}
        {...props}
      >
        {children}
      </Component>
    )
  } else {
    inputContainer = (
      <Col s={12} m={4} className={'right-align'}>
        <Component
          id={id}
          checked={value}
          onLabel={''}
          offLabel={''}
          onChange={handleChange}
          {...props}
        >
          {children}
        </Component>
      </Col>
    )
  }

  return (
    <div className={'row no5-margin form-fix'}>
      <Col s={12} m={8} className={'input-height'}>
        <label htmlFor={id} className={'default'}>
          {label}
        </label>
        {hint && <div className={'hint'}>{hint}</div>}
      </Col>
      {inputContainer}
    </div>
  )
}

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
