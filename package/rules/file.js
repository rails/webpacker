module.exports = {
  test: [
    /\.bmp$/,
    /\.gif$/,
    /\.jpe?g$/,
    /\.png$/,
    /\.tiff$/,
    /\.ico$/,
    /\.avif$/,
    /\.webp$/,
    /\.eot$/,
    /\.otf$/,
    /\.ttf$/,
    /\.woff$/,
    /\.woff2$/,
    /\.html$/,
    /\.json$/
  ],
  exclude: [/\.(js|mjs|jsx|ts|tsx)$/],
  type: 'asset/resource'
}
