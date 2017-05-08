const merge = require('webpack-merge');
const path = require('path');

const common = require('./config/webpack.common');
const dev = require('./config/webpack.dev');
const prod = require('./config/webpack.prod');

const config = {
  src: path.join(__dirname, 'src'),
  dist: path.join(__dirname, 'dist'),
  root: __dirname,
  host: '0.0.0.0',
  port: '8080'
};

module.exports = function (env) {
  console.log('env', env);

  if (env === 'prod') {
    return merge([
      common(config),
      prod(config)
    ]);
  } else if (env === 'dev') {
    return merge([
      common(config),
      dev(config)
    ]);
  }
};
