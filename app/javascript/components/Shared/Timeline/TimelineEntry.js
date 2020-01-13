import React from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'
import Moment from 'react-moment'

const TimelineEntry = ({
  current,
  onClick,
  time,
  title,
  summary,
  children,
}) => {
  return (
    <li className={c('timeline-entry', { current, active: current })}>
      <div className={'collapsible-header'} onClick={onClick}>
        {time && (
          <Moment format={'L'} withTitle titleFormat={'L LT'} unix>
            {time}
          </Moment>
        )}
        {title && <div className={'title'}>{title}</div>}
        {summary && <div className={'summary'}>{summary}</div>}
      </div>

      <div className={'details collapsible-body'}>{children}</div>
    </li>
  )
}

TimelineEntry.propTypes = {}

export default TimelineEntry
