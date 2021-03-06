sd = require('sharify').data
Backbone = require "backbone"
bootstrap = require "../../../components/layout/bootstrap.coffee"

module.exports.SignUpView = class SignUpView extends Backbone.View

  initialize: ->
    @$error = @$(".auth-page-error-message")

  events:
    "blur input": "check"
    'submit form': 'submit'

  check: (e) ->
    $target = $(e.target)
    message = if $target.val() is ""
      "Please enter your #{$target.attr('placeholder').toLowerCase()}"

    @$error.text(message)

  login: (data) ->
    options =
      url: sd.AP.loginPagePath
      error: @onError
      success: =>
        window.location = data.redirectTo
    new Backbone.Model().save data, options

  signup: (data) ->
    options =
      url: "#{sd.API_URL}/api/v1/user"
      error: @onError
      success: =>
        @login(data)
        analyticsHooks.trigger 'auth:signup'
    new Backbone.Model().save data, options

  onError: (m, res) =>
    @$error.text res?.responseJSON?.error or "Unknown Error"

  submit: (e) ->
    e.preventDefault()
    data =
      name: @$("input[name='name']").val()
      email: @$("input[name='email']").val()
      password: @$("input[name='password']").val()
      redirectTo: @$("input[name='redirect-to']").val()
      _csrf: @$("input[name='_csrf']").val()
    @signup data
    false


module.exports.init = ->
  bootstrap()
  new SignUpView(el: $("#auth-page")) if window.location.search?.indexOf('email') > -1
