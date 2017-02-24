/* global document */
/* eslint import/no-unresolved:0 */
/* eslint import/no-extraneous-dependencies:0 */
/* eslint import/extensions:0 */

// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react';
import ReactDOM from 'react-dom';

const Hello = props => (
  <div>Hello {props.name}!</div>
);

Hello.defaultProps = {
  name: 'David',
};

Hello.propTypes = {
  name: React.PropTypes.string,
};

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Hello name="React" />,
    document.body.appendChild(document.createElement('div')),
  );
});
