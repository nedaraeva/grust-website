workflow "Deploy to Heroku" {
  on = "push"
  resolves = "release"
}

action "login" {
  uses = "actions/heroku@master"
  args = "container:login"
  secrets = ["HEROKU_API_KEY"]
}

action "push" {
  uses = "actions/heroku@master"
  needs = "login"
  args = "container:push -a georgiarust web"
  secrets = ["HEROKU_API_KEY"]
}

action "release" {
  uses = "actions/heroku@master"
  needs = "push"
  args = "container:release -a georgiarust web"
  secrets = ["HEROKU_API_KEY"]
}

workflow "New workflow" {
  resolves = ["Send Push Notification"]
  on = "pull_request"
}

action "Send Push Notification" {
  uses = "techulus/push-github-action@0.0.1"
  secrets = ["API_KEY", "MESSAGE"]
}
