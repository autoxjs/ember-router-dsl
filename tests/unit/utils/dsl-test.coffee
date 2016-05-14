`import DSL from 'ember-router-dsl/utils/dsl'`
`import RouteData from 'ember-router-dsl/models/route-data'`
`import { module, test } from 'qunit'`

class FauxRouter
  @map = (f) ->
    router = new FauxRouter
    f.call router
  route: (name, opts, f) -> f?.call @
module 'Unit | Utility | DSL',
  afterEach: ->
    RouteData.reset()
  beforeEach: ->
    FauxRouter.map ->
      {namespace, model,  collection, form, view, child, children} = DSL.import(@)
      namespace "relational", ->
        model "thread", ->
          children "shit-posts", as: "post", -> form "new"
          children "posts", -> form "new"
        model "post", ->
          child "thread"
      namespace "orchard", ->
        collection "histories"
        collection "apples", ->
          form "new"
          model "apple", ->
            form "edit"
            view "admin"
            collection "histories"

        collection "oranges", ->
          form "new"
          model "orange", ->
            form "edit"
            view "other"
            collection "juicers"

        collection "juicers"
        model "cherimoya"

      namespace "supermarket", ->
        collection "apples", ->
          model "apple", ->
            form "buy"
        collection "oranges", ->
          model "orange", ->
            form "buy"

test "children", (assert) ->
  assert.equal RouteData.routeModel("relational.thread.shit-posts"), "post",
    "Children route should have the proper model"

  assert.equal RouteData.routeModel("relational.thread.shit-posts.index"), "post",
    "children index should be correct"

  assert.equal RouteData.routeModel("relational.thread.shit-posts.new"), "post",
    "children new should also be right"

  assert.equal RouteData.routeModel("relational.thread.posts"), "post",
    "Children route should have the proper model"

  assert.equal RouteData.routeModel("relational.thread.posts.index"), "post",
    "children index should be correct"

  assert.equal RouteData.routeModel("relational.thread.posts.new"), "post",
    "children new should also be right"

  assert.equal RouteData.routeModel("relational.post.thread"), "thread",
    "Children route should have the proper model"


test 'modelRoute', (assert) ->
  assert.equal RouteData.modelRoute("apple"),
    "orchard.apples.apple"

  assert.equal RouteData.modelRoute("apple", "supermarket.oranges.orange.buy"),
    "supermarket.apples.apple",
    "passing in a second argument should properly handle distance"

  assert.notOk RouteData.modelRoute("banana")

  assert.equal RouteData.modelRoute("orange"),
    "orchard.oranges.orange"

  assert.equal RouteData.modelRoute("orange", "supermarket.apples.apple.index"),
    "supermarket.oranges.orange",
    "distances should be properly handled"

  assert.equal RouteData.modelRoute("cherimoya"),
    "orchard.cherimoya"

test "collectionRoute", (assert) ->
  assert.equal RouteData.collectionRoute("apple"),
    "orchard.apples"

  assert.equal RouteData.collectionRoute("apple", "supermarket.oranges"),
    "supermarket.apples"

  assert.notOk RouteData.collectionRoute("banana")

  assert.equal RouteData.collectionRoute("orange"),
    "orchard.oranges"

  assert.equal RouteData.collectionRoute("juicer"),
    "orchard.juicers"

  assert.equal RouteData.collectionRoute("history"),
    "orchard.histories"

  assert.notOk RouteData.collectionRoute("cherimoya")

test "routeType", (assert) ->
  assert.equal RouteData.routeType("orchard.apples.new"), "form"
  assert.equal RouteData.routeType("orchard.apples.index"), "view"
  assert.equal RouteData.routeType("orchard.apples"), "collection"
  assert.equal RouteData.routeType("orchard.apples.apple"), "model"
  assert.equal RouteData.routeType("orchard.apples.apple.index"), "view"
  assert.equal RouteData.routeType("orchard.apples.apple.admin"), "view"
  assert.equal RouteData.routeType("orchard.apples.apple.edit"), "form"

test "routeModel", (assert) ->
  assert.equal RouteData.routeModel("orchard.apples.new"), "apple"
  assert.equal RouteData.routeModel("orchard.apples.index"), "apple"
  assert.equal RouteData.routeModel("orchard.apples"), "apple"
  assert.equal RouteData.routeModel("orchard.apples.apple"), "apple"
  assert.equal RouteData.routeModel("orchard.apples.apple.index"), "apple"
  assert.equal RouteData.routeModel("orchard.apples.apple.admin"), "apple"
  assert.equal RouteData.routeModel("orchard.apples.apple.edit"), "apple"

  assert.equal RouteData.routeModel("orchard.oranges.new"), "orange"
  assert.equal RouteData.routeModel("orchard.oranges.index"), "orange"
  assert.equal RouteData.routeModel("orchard.oranges"), "orange"
  assert.equal RouteData.routeModel("orchard.oranges.orange"), "orange"
  assert.equal RouteData.routeModel("orchard.oranges.orange.index"), "orange"
  assert.equal RouteData.routeModel("orchard.oranges.orange.other"), "orange"
  assert.equal RouteData.routeModel("orchard.oranges.orange.edit"), "orange"

test "parentNodeRoute", (assert) ->
  assert.equal RouteData.parentNodeRoute("orchard.apples.new"), "orchard"
  assert.equal RouteData.parentNodeRoute("orchard.apples.index"), "orchard"
  assert.equal RouteData.parentNodeRoute("orchard.apples"), "orchard"
  assert.equal RouteData.parentNodeRoute("orchard.apples.apple"), "orchard.apples"
  assert.equal RouteData.parentNodeRoute("orchard.apples.apple.index"), "orchard.apples"
  assert.equal RouteData.parentNodeRoute("orchard.apples.apple.admin"), "orchard.apples"
  assert.equal RouteData.parentNodeRoute("orchard.apples.apple.edit"), "orchard.apples"
  assert.equal RouteData.parentNodeRoute("orchard.apples.apple.histories"), "orchard.apples.apple"
  assert.equal RouteData.parentNodeRoute("orchard.apples.apple.histories.index"), "orchard.apples.apple"

test "routeAction", (assert) ->
  assert.equal RouteData.routeAction("orchard.apples.new"), "collection#new"
  assert.equal RouteData.routeAction("orchard.apples.index"), "collection#index"
  assert.equal RouteData.routeAction("orchard.apples"), "namespace#collection"
  assert.equal RouteData.routeAction("orchard.apples.apple"), "collection#model"
  assert.equal RouteData.routeAction("orchard.apples.apple.index"), "model#index"
  assert.equal RouteData.routeAction("orchard.apples.apple.admin"), "model#admin"
  assert.equal RouteData.routeAction("orchard.apples.apple.edit"), "model#edit"
  assert.equal RouteData.routeAction("orchard.apples.apple.histories"), "model#collection"
  assert.equal RouteData.routeAction("orchard.apples.apple.histories.index"), "collection#index"
