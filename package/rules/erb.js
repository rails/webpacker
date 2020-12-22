const { loaderCheckingExists } = require('../utils/helpers')

const runner = /^win/.test(process.platform) ? 'ruby ' : ''

module.exports = loaderCheckingExists('rails-erb-loader',
    (loaderPath) => (
        {
            test: /\.erb$/,
            enforce: 'pre',
            exclude: /node_modules/,
            use: [
                {
                    loader: loaderPath,
                    options: { runner: `${runner}bin/rails runner` }
                }
            ]
        }
    ))
