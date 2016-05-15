# Ember-router-dsl

Exposes the following methods
```coffeescript
{namespace, children, child, collection, model, view, form} = DSL.import @
```

Use in your `router.coffee` or `router.js` file like so:
```coffeescript
import DSL from 'ember-router-dsl'
Router.map ->
  {namespace, children, child, collection, model, view, form} = DSL.import @
  namespace "dashboard", ->
    collection "projects", ->
      form "new"
      view "search"
    model "project", ->
      form "edit"
      children "cad-files", as: "file"
      children "versions"
      child "owner", as: "user"
```
Then, you can access the expected metadata using the `routeData` service like so:
```coffeescript
Route.extend
  routeData: service "route-data"
  model: ->
    @routeData.routeOptions "dashboard.projects"
    @routeData.routeModel "dashboard.project" # project
    @routeData.routeType "dashboard.project" # model
    @routeData.routeAction "dashboard.project.index" # model#index
    @routeData.parentNodeRoute "dashboard.project.cad-files.index" # dashboard.project
    @routeData.modelRoute "project" # dashboard.project
    @routeData.collectionRoute "project" # dashboard.projects
    @routeData.childRoute()
    @routeData.childrenRoute()
    @routeData.modelRoutes()
    @routeData.collectionRoutes()
    @routeData.childRoutes()
    @routeData.childrenRoutes()
```

in the `router.js` file as well as a `routerData` service that holds meta data for the routes

## Installation

* `git clone` this repository
* `npm install`
* `bower install`

## Running

* `ember server`
* Visit your app at http://localhost:4200.

## Running Tests

* `npm test` (Runs `ember try:testall` to test your addon against multiple Ember versions)
* `ember test`
* `ember test --server`

## Building

* `ember build`

For more information on using ember-cli, visit [http://ember-cli.com/](http://ember-cli.com/).
