`import Ember from 'ember'`
`import RouteData from '../models/route-data'`

{A, isPresent} = Ember

RouteDataService = Ember.Service.extend
  instance: ->
    @instanceObject ?= RouteData.instance()
  routeOptions: (routeName) ->
    @instance().routes?[routeName]
  routeModel: ->
    @instance().routeModel arguments...
  routeType: ->
    @instance().routeType arguments...
  routeAction: ->
    @instance().routeAction arguments...
  parentNodeRoute: ->
    @instance().parentNodeRoute arguments...
  modelRoute: ->
    @instance().modelRoute arguments...
  collectionRoute: ->
    @instance().collectionRoute arguments...
  childRoute: ->
    @instance().childRoute arguments...
  childrenRoute: ->
    @instance().childrenRoute arguments...
  modelRoutes: ->
    @instance().modelRoutes arguments...
  collectionRoutes: ->
    @instance().collectionRoutes arguments...
  childRoutes: ->
    @instance().childRoutes arguments...
  childrenRoutes: ->
    @instance().childrenRoutes arguments...

`export default RouteDataService`