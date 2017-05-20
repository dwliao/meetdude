import React from 'react';
import { Field, reduxForm } from 'redux-form';
import TextField from 'material-ui/TextField';
import RaisedButton from 'material-ui/RaisedButton';
import FontIcon from 'material-ui/FontIcon';

const validate = (values) => {
  const errors = {};
  if (!values.email) {
    errors.email = 'Required';
  } else if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(values.email)) {
    errors.email = 'Invalid email address';
  }
  if (!values.password) {
    errors.password = 'Required';
  } else if (values.password.length < 6) {
    errors.password = 'Must equal or longer than 6 characters';
  }
  return errors;
};

const renderTextField = ({ input, meta: { touched, error }, ...custom }) => (
  <TextField
    errorText={touched && error}
    {...input}
    {...custom}
  />
);

class SignInForm extends React.PureComponent {
  render() {
    const { handleSubmit, pristine, submitting } = this.props;
    return (
      <form onSubmit={handleSubmit}>
        <div>
          <Field
            name="email"
            type="text"
            component={renderTextField}
            floatingLabelText="Your email address"
            hintText="your@email.com"
          />
        </div>
        <div>
          <Field
            name="password"
            type="password"
            component={renderTextField}
            floatingLabelText="Password"
          />
        </div>
        <div>
          <RaisedButton
            label="SIGN IN"
            labelPosition="before"
            type="submit"
            primary
            icon={<FontIcon className="material-icons">keyboard_arrow_right</FontIcon>}
            disabled={pristine || submitting}
          />
        </div>
      </form>
    );
  }
}

export default reduxForm({
  form: 'signInForm',
  validate,
})(SignInForm);
