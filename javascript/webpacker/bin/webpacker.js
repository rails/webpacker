#!/usr/bin/env node
/* eslint no-case-declarations: 0 */

const spawn = require('cross-spawn')

const script = process.argv[2]
const args = process.argv.slice(3)

switch (script) {
  case 'build':
  case 'start':
  case 'test':
    const result = spawn.sync('node', [require.resolve(`../scripts/${script}`)].concat(args), { stdio: 'inherit' })
    process.exit(result.status)
    break
  default:
    console.log(`Unknown script ${script}`) /* eslint no-console: 0 */
    break
}
