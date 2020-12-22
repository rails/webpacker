const { loaderCheckingExists } = require('../utils/helpers')

module.exports = loaderCheckingExists('coffee-loader',
    (loaderPath) => (
        {
            test: /\.coffee(\.erb)?$/,
            use: [
                { loader: loaderPath }
            ]
        }
    ))
