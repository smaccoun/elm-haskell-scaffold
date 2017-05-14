const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const ClosureCompilerPlugin = require('webpack-closure-compiler');
const ChunkManifestPlugin = require('chunk-manifest-webpack-plugin');
const WebpackChunkHash = require('webpack-chunk-hash');

module.exports = function (config) {
  return {
    entry: {
      path: config.src
    },

    output: {
      path: config.dist,
      filename: '[name].[chunkhash].js'
    },

    module: {
      rules: [
        {
          test: /\.elm$/,
          include: config.src,
          use: 'elm-webpack-loader'
        },
        {
          test: /\.css$/,
          include: config.src,
          use: ExtractTextPlugin.extract({
            use: [
              'css-loader',
              {
                loader: 'postcss-loader',
                options: {
                  plugins: function () {
                    return [
                      require('autoprefixer')
                    ];
                  }
                }
              }
            ],
            fallback: 'style-loader'
          })
        }
      ]
    },

    plugins: [
      new ExtractTextPlugin('[name].[contenthash].css'),
      new CleanWebpackPlugin([config.dist], {root: config.root}),
      new ClosureCompilerPlugin({
        compiler: {
          language_in: 'ECMASCRIPT6',
          language_out: 'ECMASCRIPT5',
          compilation_level: 'SIMPLE'
        },
        concurrency: 3
      }),
      new webpack.optimize.CommonsChunkPlugin({
        name: ['vendor', 'manifest'],
        minChunks: Infinity
      }),
      new webpack.HashedModuleIdsPlugin(),
      new WebpackChunkHash(),
      new ChunkManifestPlugin({
        filename: 'chunk-manifest.json',
        manifestVariable: 'webpackManifest'
      }),
      new webpack.EnvironmentPlugin({
                    NODE_ENV: 'production', // use 'development' unless process.env.NODE_ENV is defined
                    API_URL: 'http://api:80'
                  })
    ]
  };
};
