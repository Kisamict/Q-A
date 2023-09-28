const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const handlebars = require('./loaders/handlebars')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: ['popper.js', 'default'],
    toastr: 'toastr/toastr',
    ApexCharts: ['apexcharts', 'default'],
    underscore: ['underscore', 'm'],
    Rails: ['@rails/ujs']
  })
)

environment.loaders.prepend('handlebars', handlebars)

module.exports = environment
