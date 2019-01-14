# Yarn

Webpacker by default uses `yarn` as a package manager for `node_modules`


## Add a new npm module

To add any new JS module you can use `yarn`:

```bash
yarn add bootstrap material-ui
```

## Add an npm module to `devDependencies`
To add a new JS module that will only be available to local development:

```bash
yarn add --dev browser-sync
```

Be careful not to add any build or app related JS modules in this fashion. Adding JS modules to `devDependencies` [will block them from being installed in **any** production environment](https://yarnpkg.com/lang/en/docs/cli/install/#toc-yarn-install-production-true-false).

Docs from JS modules may instruct you to use `--dev` or `devDependencies`, but this is generally under the assumption that you are using a `node.js` workflow.
