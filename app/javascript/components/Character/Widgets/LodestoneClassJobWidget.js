import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Row, Col } from 'react-materialize'
import Muted, { TextLight } from '../../Styled/Muted'
import { Caption, MutedCaption } from '../../Styled/Caption'
import c from 'classnames'

class LodestoneClassJobWidget extends Component {
  render() {
    const {
      character: { lodestone_character },
    } = this.props

    if (!lodestone_character) {
      return (
        <Caption className={'center card-content'}>No Lodestone Link!</Caption>
      )
    }

    let class_jobs = [...lodestone_character.class_jobs]
    class_jobs.sort((a, b) => b.level - a.level)

    return (
      <div className={'card-content padding-bottom--none'}>
        <Row>
          {class_jobs.map(cj => (
            <Col key={cj.id} s={3} m={2}>
              <div className={c('center-align', { faded: cj.level === 0 })}>
                <img
                  width={50}
                  style={{ margin: '0 auto' }}
                  className={'block responsive-img'}
                  src={cj.class_icon_url}
                  alt={cj.name}
                />
                {cj.level > 0 ? (
                  <Caption className={'larger'}>{cj.level}</Caption>
                ) : (
                  <MutedCaption className={'larger'}>{cj.level}</MutedCaption>
                )}
                <TextLight>
                  <abbr title={cj.job_active ? cj.job_name : cj.class_name}>
                    {cj.job_active ? cj.job_abbr : cj.class_abbr}
                  </abbr>
                </TextLight>
              </div>
            </Col>
          ))}
        </Row>
      </div>
    )
  }
}

LodestoneClassJobWidget.propTypes = {
  character: PropTypes.shape({
    lodestone_character: PropTypes.object,
  }),
}

export default LodestoneClassJobWidget
