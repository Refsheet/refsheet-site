import { Col, Switch, TextInput } from 'react-materialize'
import React, { useState } from 'react'

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

export default InputRow
