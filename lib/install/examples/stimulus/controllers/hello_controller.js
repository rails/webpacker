// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This controller is expecting the following HTML. Paste it with the javascript_pack_tag helper. 
//
// <div data-controller="hello" data-target="hello.output">
// </div>
  

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    this.outputTarget.textContent = 'Hello Stimulus!'
  }
}
