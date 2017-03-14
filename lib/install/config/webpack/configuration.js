// Common configuration for webpacker loaded from config/webpack/paths.yml

const path = require('path')
const process = require('process')
const yaml = require('js-yaml')
const fs = require('fs')

const env = process.env
const configPath = path.resolve('config', 'webpack')
const { paths } = yaml.safeLoad(fs.readFileSync(path.join(configPath, 'paths.yml'), 'utf8'))
const { dev_server } = yaml.safeLoad(fs.readFileSync(path.join(configPath, 'dev_server.yml'), 'utf8'))
const publicPath = env.NODE_ENV !== 'production' && dev_server.enabled ?
              `http://${dev_server.host}:${dev_server.port}/` : `/${paths.dist_dir}/`

module.exports = {
  dev_server,
  env,
  paths,
  publicPath
}
