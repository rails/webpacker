# Webpacker has been retired 🌅

Webpacker has served the Rails community for over five years as a bridge to compiled and bundled JavaScript. This bridge is no longer needed for most people in most situations following [the release of Rails 7](https://rubyonrails.org/2021/12/15/Rails-7-fulfilling-a-vision). We now have [three great default answers to JavaScript in 2021+](https://world.hey.com/dhh/rails-7-will-have-three-great-answers-to-javascript-in-2021-8d68191b), and thus we will no longer be evolving Webpacker in an official Rails capacity.

For applications currently using Webpacker, the first recommendation is to switch to [jsbundling-rails with Webpack](https://github.com/rails/jsbundling-rails/) (or another bundler). You can follow [the switching guide](https://github.com/rails/jsbundling-rails/blob/main/docs/switch_from_webpacker.md), if you choose this option.

Secondly, you may want to try making the jump all the way to [import maps](https://github.com/rails/importmap-rails/). That's the default setup for new Rails 7 applications, but depending on your JavaScript use, it may be a substantial jump.

Finally, you can continue to stick with webpacker or its successor mentioned below. You can use v5 and prior versions Webpacker as-is. For these releases, we will continue to address security issues on the Ruby side of the gem according to [the normal maintenance schedule of Rails](https://guides.rubyonrails.org/maintenance_policy.html#security-issues). However, we will not be updating the gem to include newer versions of the JavaScript libraries.

Although the development of v6 did not result in an official gem released by the Rails team, Justin Gordon and other contributors did release a v6 that addresses many of the complaints of prior versions, such as simpler, more direct webpack configuration. Not only does it include the unreleased v6 work from this repository, but it also includes many pending PRs that were closed when this gem was retired. If you want advanced webpack support, such as hot-module reloading and code splitting, consider the new successor gem called [Shakapacker](https://github.com/shakacode/shakapacker).

Thank you to everyone who has contributed to Webpacker over the last five-plus years!

_Please refer to the [5-x-stable](https://github.com/rails/webpacker/tree/5-x-stable) branch for 5.x documentation._
