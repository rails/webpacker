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
    /\.svg$/
  ],
  exclude: [/\.(js|mjs|jsx|ts|tsx)$/],
  type: 'asset/resource',
  generator: {
    filename: 'static/[hash][ext][query]'
  }
}
