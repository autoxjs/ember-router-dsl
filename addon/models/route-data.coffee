`import Ember from 'ember'`
`import ModelData from './model-data'`
`import _ from 'lodash/lodash'`

{A, isPresent} = Ember
{flow, dropRight, partialRight, noop, last} = _
split = (sep) -> (str) -> str.split(sep)
join = (sep) -> (arr) -> arr.join(sep)
drop2 = flow split("."), partialRight(dropRight, 2), join(".")
drop1 = flow split("."), partialRight(dropRight, 1), join(".")

class RouteData
  constructor: ->
    @routes = {}
    @models = {}
  instance = new RouteData()
  @instance = -> instance
  @reset = -> instance = new RouteData()
  @addRoute = ->
    instance.addRoute.apply instance, arguments
  @addModel = ->
    instance.addModel.apply instance, arguments
  @routeModel = ->
    instance.routeModel.apply instance, arguments
  @routeType = ->
    instance.routeType.apply instance, arguments
  @routeAction = ->
    instance.routeAction.apply instance, arguments
  @parentNodeRoute = ->
    instance.parentNodeRoute.apply instance, arguments
  @modelRoute = ->
    instance.modelRoute.apply instance, arguments
  @collectionRoute = ->
    instance.collectionRoute.apply instance, arguments
  @childRoute = ->
    instance.childRoute.apply instance, arguments
  @childrenRoute = ->
    instance.childrenRoute.apply instance, arguments
  @modelRoutes = ->
    instance.modelRoutes.apply instance, arguments
  @collectionRoutes = ->
    instance.collectionRoutes.apply instance, arguments
  @childRoutes = ->
    instance.childRoutes.apply instance, arguments
  @childrenRoutes = ->
    instance.childrenRoutes.apply instance, arguments
  addRoute: (name, routeData) ->
    @routes[name] = routeData
  addModel: (name, routeData) ->
    @models[name] ?= ModelData.create {name}
    @models[name].merge routeData
  @types = ["namespace", "child", "children", "collection", "model", "form", "view"]

  routeModel: (routeName) ->
    @routes[routeName]?.model
  routeType: (routeName) ->
    @routes[routeName]?.type
  routeAction: (routeName) ->
    prefix = @routeType drop1 routeName
    suffix = switch (type = @routeType routeName)
      when "form", "view" then last split(".") routeName
      else type
    A [prefix, suffix]
    .filter isPresent
    .join "#"
  parentNodeRoute: (routeName) ->
    f = switch @routeType(routeName)
      when "form", "view" then drop2
      when "namespace", "collection", "model", "child", "children" then drop1
      else noop
    f routeName
  modelRoute: (modelName, currentRouteName) ->
    if currentRouteName?
      @models[modelName]?.modelRouteClosestTo(currentRouteName)
    else
      @models[modelName]?.get("modelRoute")
  collectionRoute: (modelName, currentRouteName) ->
    if currentRouteName?
      @models[modelName]?.collectionRouteClosestTo(currentRouteName)
    else
      @models[modelName]?.get("collectionRoute")
  childRoute: (modelName, currentRouteName) ->
    if currentRouteName?
      @models[modelName]?.childRouteClosestTo(currentRouteName)
    else
      @models[modelName]?.get("childRoute")
  childrenRoute: (modelName, currentRouteName) ->
    if currentRouteName?
      @models[modelName]?.childrenRouteClosestTo(currentRouteName)
    else
      @models[modelName]?.get("childrenRoute")
  modelRoutes: (modelName) ->
    @models[modelName]?.get("modelRoutes")
  collectionRoutes: (modelName) ->
    @models[modelName]?.get("collectionRoutes")
  childRoutes: (modelName) ->
    @models[modelName]?.get("childRoutes")
  childrenRoutes: (modelName) ->
    @models[modelName]?.get("childrenRoutes")

`export default RouteData`
