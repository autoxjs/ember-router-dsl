`import Ember from 'ember'`

{A, Object, computed: {alias, sort}} = Ember

compare = (f) -> (a,b) -> f(a) - f(b)
specificity = (str) -> str.split(".").length
distanceTo = (destination) -> 
  destinations = destination?.split(".") ? []
  (origin) ->
    origins = origin?.split(".") ? []
    i = 0
    i++ while i < destinations.length and origins[i] is destinations[i]
    destinations.length - i

ModelData = Object.extend
  childRoute: alias "childRoutes.firstObject"
  childrenRoute: alias "childrenRoutes.firstObject"
  modelRoute: alias "modelRoutes.firstObject"
  collectionRoute: alias "collectionRoutes.firstObject"

  childRoutes: sort "childRoutesRaw", compare specificity
  childrenRoutes: sort "childrenRoutesRaw", compare specificity
  modelRoutes: sort "modelRoutesRaw", compare specificity
  collectionRoutes: sort "collectionRoutesRaw", compare specificity
  init: ->
    @_super arguments...
    @set "modelRoutesRaw", A []
    @set "childRoutesRaw", A []
    @set "childrenRoutesRaw", A []
    @set "collectionRoutesRaw", A []
  childRouteClosestTo: (routeName) ->
    @get "childRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  childrenRouteClosestTo: (routeName) ->
    @get "childrenRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  modelRouteClosestTo: (routeName) ->
    @get "modelRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  collectionRouteClosestTo: (routeName) ->
    @get "collectionRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  merge: ({collectionRoute, modelRoute, childRoute, childrenRoute}) ->
    if modelRoute?
      @get("modelRoutesRaw").pushObject modelRoute
    if collectionRoute?
      @get("collectionRoutesRaw").pushObject collectionRoute
    if childRoute?
      @get("childRoutesRaw").pushObject childRoute
    if childrenRoute?
      @get("childrenRoutesRaw").pushObject childrenRoute

`export default ModelData`