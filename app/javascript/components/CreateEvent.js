import React from "react"
import PropTypes from "prop-types"
import {
  FormFeedback,
  FormGroup,
  Label,
  Input,
  Button,
  Col,
  Row
} from 'reactstrap';
import { Formik, Form, Field, ErrorMessage, FieldArray } from 'formik';
import DatePicker from 'react-datepicker';
import EventService from '../services/eventService';
import { FormValidator } from './helpers/form_validator';
import { TimePicker } from 'antd';
var moment = require('moment-timezone');
import Select from 'react-select';

const format = 'HH:mm';
const initialTime = moment('12:08', format).tz('America/Bogota');

const initialValues= {
  starts_at: '',
  ends_at: '',
  schedules: [ 
    { 
      'day': 'monday',
      'time': initialTime
    }
  ],
}

class CreateEvent extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      errors: [],
      success: ''
    } 
  }

  renderDays() {
    var days = this.props.days.map((day) => {
      return({ 'label': day, 'value': day })
    })

    return days;
  }

  render () {
    return (
      <div className="mt-5">
        { this.state.errors.length > 0 &&
          <div className="alert alert-danger">
            {
              this.state.errors.map((error, key) => (
                <div key={key}>
                  <span>{error}</span>
                  <br/>
                </div>
              ))
            }

          </div>
        }
        { this.state.success !== "" &&
          <div className="alert alert-success">
            <span>{this.state.success}</span>
          </div>
        }
        <Formik
          initialValues={initialValues}
          validationSchema={FormValidator}
          onSubmit={(values, { setSubmitting, resetForm }) => {
            EventService.create(values)
              .then(
                () => {
                  this.setState({
                    errors: [],
                    success: 'The data has been created successfully.'
                  })
                  resetForm(initialValues);
                  setSubmitting(false);
                },
                err => {
                  this.setState({ success: '', errors: err.data.message })
                  setSubmitting(false)
                }
              )
          }}
        >
          {({ values, errors, isSubmitting, touched, setFieldValue, setFieldTouched }) => (
            <Form className="py-4">
              <Row>
                <Col>
                  <FormGroup>
                    <Label for="starts_at" className="font-weight-bold">Starts at: *</Label>
                    <Input
                      type="date"
                      name="starts_at"
                      id="starts_at"
                      tag={Field}
                      invalid={Boolean(touched.starts_at && errors.starts_at)}
                      aria-required
                    />
                    <ErrorMessage name="starts_at" component={FormFeedback} />
                  </FormGroup>
                </Col>
                <Col>
                  <FormGroup>
                    <Label for="ends_at" className="font-weight-bold">Ends at: *</Label>
                    <Input
                      type="date"
                      name="ends_at"
                      id="ends_at"
                      tag={Field}
                      invalid={Boolean(touched.ends_at && errors.ends_at)}
                      aria-required
                    />
                    <ErrorMessage name="ends_at" component={FormFeedback} />
                  </FormGroup>
                </Col>
              </Row>
              <Row>
                <Col>
                  <h3 className="mt-4">Schedules</h3>
                  <FormGroup>
                    {
                      Boolean(touched.schedules && errors.schedules) &&
                      <div className="invalid-feedback d-block">
                        {errors.schedules}
                      </div>
                    }
                    <FieldArray
                      name="schedules"
                      render={ arrayHelpers => (
                        <div className="schedule-selector">
                          {values.schedules.map((schedules, index) => (
                            <div key={index} className="mb-10">
                              <Row>
                                <Col  md={2}>
                                  <FormGroup>
                                    <Label 
                                      for={`schedules[${index}].day`}
                                      className="font-weight-bold"
                                    >
                                      Day
                                    </Label>
                                    <Select
                                      classNamePrefix='schedule_day'
                                      name={`schedules[${index}].day`}
                                      id={`schedules[${index}].day`}
                                      value={
                                        { 'label': values.schedules[index].day, 'value': values.schedules[index].day
                                        }
                                      }
                                      onChange={(selected) => setFieldValue(`schedules[${index}].day`, selected.value)} 
                                      onBlur={(selected) => setFieldTouched(`schedules[${index}].day`,selected.value)}
                                      options={this.renderDays()}
                                      menuPlacement="auto"
                                    />
                                  </FormGroup>
                                </Col>
                                <Col  md={2}>
                                  <FormGroup>
                                    <Label 
                                      for={`schedules[${index}].time`} 
                                      className="font-weight-bold"
                                    >
                                      Hour:Minute
                                    </Label>
                                    <br/>
                                    <TimePicker
                                      name={`schedules[${index}].time`}
                                      defaultValue={values.schedules[index].time} 
                                      format={format}
                                      onChange={ time => setFieldValue(`schedules[${index}].time`, time)
                                      }
                                    />
                                  </FormGroup>
                                </Col>
                                <Col md={2} className="d-flex align-items-center">
                                  <div className="d-flex align-items-center">
                                    { index > 0 &&
                                      <Button 
                                        className="round-button delete height-32 mr-2" 
                                        onClick={() => arrayHelpers.remove(index)}>
                                        -
                                      </Button>
                                    }
                                    <Button 
                                      className="round-button add height-32" 
                                      onClick={() => arrayHelpers.push({ day: this.props.days[0], time: initialTime })}>
                                      +
                                    </Button>
                                  </div>
                                </Col>
                              </Row>
                            </div>
                          ))}
                        </div>
                      )}
                    />
                  </FormGroup>
                </Col>
              </Row>
              <Button
                type="submit"
                color="primary"
                disabled={isSubmitting}
              >
                Save
              </Button>
            </Form>
          )}
        </Formik>
      </div>
    );
  }
}

export default CreateEvent
