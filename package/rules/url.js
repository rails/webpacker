const imageInlineSizeLimit = parseInt(
  process.env.WEBPACKER_IMAGE_INLINE_SIZE_LIMIT || '10000',
  10
)

module.exports = {
  test: [/\.bmp$/, /\.gif$/, /\.jpe?g$/, /\.png$/],
  loader: require.resolve('url-loader'),
  options: {
    limit: imageInlineSizeLimit,
    name: 'static/media/[name].[hash:8].[ext]'
  }
}
