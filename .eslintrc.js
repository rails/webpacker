module.exports = {
  "extends": "airbnb",
  "plugins": [
    "react",
    "jsx-a11y",
    "import"
  ],
  "rules": {
    "import/no-unresolved": "off",
    "import/no-extraneous-dependencies": "off",
    "import/extensions": "off",
    "func-names": "off",
    "prefer-arrow-callback": "off",
    "object-shorthand": "off",
    "no-console": "off",
  },
  "globals": {
    "document": true,
    "window": true,
  },
};
