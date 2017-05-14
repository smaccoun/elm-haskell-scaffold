'use strict';

require('./main.css');
const Elm = require('./Main.elm');

console.log(process.env.NODE_ENV);

const app = Elm.Main.fullscreen({
              nodeEnv: process.env.NODE_ENV
              ,apiBaseUrl: process.env.API_URL
            });
console.log(app);
