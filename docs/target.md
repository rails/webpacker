# Target browsers

By default webpacker provides these front-end tools:
- [@babel/preset-env](https://github.com/babel/babel/tree/master/packages/babel-preset-env)
- [Autoprefixer](https://github.com/postcss/autoprefixer)
- [postcss-preset-env](https://github.com/csstools/postcss-preset-env)

All these tools use [Browserslist](https://github.com/browserslist/browserslist) to detect which environment your users have

Webpacker browserslist default target:
```
defaults
```

`defaults`: `(> 0.5%, last 2 versions, Firefox ESR, not dead)`, [browserl.ist](https://browserl.ist/) is an online tool to check what browsers will be selected by some query.

To keep browsers data up to date, you need to run:
```bash
yarn upgrade caniuse-lite
```

at least once every few months, to prevent such [problems](https://github.com/browserslist/browserslist/issues/492)
