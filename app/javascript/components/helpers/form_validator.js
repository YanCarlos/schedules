import * as Yup from 'yup'

export const FormValidator = Yup.object().shape({
  starts_at: Yup.string()
    .required('Starts at is required'),
  ends_at: Yup.string()
    .required('Ends at is required'),
  schedules: Yup.array()
    .min(1, 'You have to select one or more schedules')
})
