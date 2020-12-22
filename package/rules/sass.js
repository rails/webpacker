
const getStyleRule = require('../utils/get_style_rule')
const { loaderCheckingExists } = require('../utils/helpers')
const { additional_paths: includePaths } = require('../config')

module.exports = loaderCheckingExists('sass',
    () => {
        /* eslint global-require: 0 */
        const sass = require('sass')

        return getStyleRule(/\.(scss|sass)(\.erb)?$/i, [
            {
                loader: require.resolve('sass-loader'),
                options: {
                    sassOptions: { includePaths },
                    implementation: sass
                }
            }
        ])
    }
)
