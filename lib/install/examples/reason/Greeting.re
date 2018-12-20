/* For more examples please have a look at:
   https://reasonml.github.io/reason-react/docs/en/counter
*/

let component = ReasonReact.statelessComponent("Greeting");

let make = (~name, _children) => {
  ...component,
  render: _self => {
    let msg = {j|Hello $(name)!|j};
    <button>
      {ReasonReact.string(msg)}
    </button>
  }
};
