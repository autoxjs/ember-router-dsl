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
  @addRoute = (name, routeData) ->
    instance.routes[name] = routeData
  @addModel = (name, routeData) ->
    instance.models[name] ?= ModelData.create {name}
    instance.models[name].merge routeData
  @types = ["namespace", "child", "children", "collection", "model", "form", "view"]
  @routeModel = (routeName) ->
    instance.routes[routeName]?.model
  @routeType = (routeName) ->
    instance.routes[routeName]?.type
  @routeAction = (routeName) ->
    prefix = RouteData.routeType drop1 routeName
    suffix = switch (type = RouteData.routeType routeName)
      when "form", "view" then last split(".") routeName
      else type
    A [prefix, suffix]
    .filter isPresent
    .join "#"
  @parentNodeRoute = (routeName) ->
    f = switch RouteData.routeType(routeName)
      when "form", "view" then drop2
      when "namespace", "collection", "model", "child", "children" then drop1
      else noop
    f routeName

  @modelRoute = (modelName, currentRouteName) ->
    if currentRouteName?
      instance.models[modelName]?.modelRouteClosestTo(currentRouteName)
    else  
      instance.models[modelName]?.get("modelRoute")
  @collectionRoute = (modelName, currentRouteName) ->
    if currentRouteName?
      instance.models[modelName]?.collectionRouteClosestTo(currentRouteName)
    else
      instance.models[modelName]?.get("collectionRoute")
  @childRoute = (modelName, currentRouteName) ->
    if currentRouteName?
      instance.models[modelName]?.childRouteClosestTo(currentRouteName)
    else  
      instance.models[modelName]?.get("childRoute")
  @childrenRoute = (modelName, currentRouteName) ->
    if currentRouteName?
      instance.models[modelName]?.childrenRouteClosestTo(currentRouteName)
    else
      instance.models[modelName]?.get("childrenRoute")
  @modelRoutes = (modelName) ->
    instance.models[modelName]?.get("modelRoutes")
  @collectionRoutes = (modelName) ->
    instance.models[modelName]?.get("collectionRoutes")
  @childRoutes = (modelName) ->
    instance.models[modelName]?.get("childRoutes")
  @childrenRoutes = (modelName) ->
    instance.models[modelName]?.get("childrenRoutes")

`export default RouteData`