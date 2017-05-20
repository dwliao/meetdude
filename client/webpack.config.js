const path = require('path');

module.exports = {
  entry: './index.jsx',
  output: {
    path: path.resolve('../app/assets/javascripts'),
    filename: 'bundle.js',
  },
  module: {
    loaders: [
      { test: /\.(js|jsx)$/, loader: 'babel-loader', exclude: /node_modules/ },
      { test: /\.(css|scss)$/, loader: 'style-loader!css-loader?modules=true!sass-loader' },
    ],
  },
  resolve: {
    extensions: ['.js', '.jsx'],
  },
};
