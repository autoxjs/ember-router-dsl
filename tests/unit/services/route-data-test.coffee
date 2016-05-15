`import { moduleFor, test } from 'ember-qunit'`
`import DSL from 'ember-router-dsl/utils/dsl'`
class FauxRouter
  @map = (f) ->
    router = new FauxRouter
    f.call router
  route: (name, opts, f) -> f?.call @

moduleFor 'service:route-data', 'Unit | Service | route data',
  # Specify the other units that are required for this test.
  # needs: ['service:foo']
  beforeEach: ->
    FauxRouter.map ->
      {namespace, children, child, collection, model, view, form} = DSL.import @
      namespace "dashboard", ->
        collection "projects", custom: "options", ->
          form "new", ctrl: "apple"
          view "search"
        model "project", ->
          form "edit"
          children "cad-files", as: "file"
          children "versions"
          child "owner", as: "user"

# Replace this with your real tests.
test 'it exists', (assert) ->
  service = @subject()
  assert.ok service

test 'methods delegation', (assert) ->
  service = @subject()
  assert.equal service.modelRoute("project"),
    "dashboard.project",
    "modelRoute should proxy"

  assert.equal service.routeModel("dashboard.projects.new"),
    "project",
    "routeModel should also proxy"

test 'routeOptions', (assert) ->
  service = @subject()
  assert.deepEqual service.routeOptions("dashboard.projects"),
    {custom: "options", model: "project", type: "collection"},
    "custom options should match"
  assert.deepEqual service.routeOptions("dashboard.projects.new"),
    {ctrl: "apple", model: "project", type: "form"},
    "should work on form key also"
  assert.deepEqual service.routeOptions("dashboard.project.cad-files"),
    {as: "file", model: "file", type: "children"},
    "should work on child key also"
