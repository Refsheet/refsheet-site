import React, { Component } from "react";
import ReactTextareaAutocomplete from "@webscopeio/react-textarea-autocomplete";
import emoji from "@jukben/emoji-search";

import "@webscopeio/react-textarea-autocomplete/style.css";

const Item = ({ entity: { name, char } }) => <div>{`${name}: ${char}`}</div>;

class App extends Component {
  render() {

    return (
        <ReactTextareaAutocomplete
            className="my-textarea"
            ref={r => this.r = r}
            onChange={e => console.log(React.version, this.r && this.r.state, this.r, e.target.value)}
            loadingComponent={() => <span>Loading</span>}
            trigger={{
              ":": {
                dataProvider: (token) => {
                  return [
                    { name: "smile", char: "🙂" },
                    { name: "heart", char: "❤️" }
                  ];
                },
                component: Item,
                output: (item, trigger) => item.char
              }
            }}
        />
    )
  }
}

export default App;
