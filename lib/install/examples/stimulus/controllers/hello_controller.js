// Visit https://github.com/stimulusjs/stimulus for more details 
import { Controller } from "stimulus"

export default class extends Controller {
  greet() {
    console.log(`Hello, ${this.name}, This is Stimulus.js!`, this.element)
  }

  get name() {
    return this.targets.find("name").value
  }
}