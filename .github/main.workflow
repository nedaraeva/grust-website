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

action "EmailMessage" {
  uses = "./.github/actions/generate-email-message"
}

action "Topic" {
  uses = "actions/aws@master"
  args = "sns create-topic --name my-topic"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}

action "Publish" {
  needs = ["Topic", "EmailMessage"]
  uses = "actions/aws@master"
  args = "sns publish --topic-arn `jq .TopicArn /github/home/Topic.json --raw-output` --subject \"[$GITHUB_REPOSITORY] Code was pushed to $GITHUB_REF\" --message file:///github/home/EmailMessage.Body.txt"
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}


