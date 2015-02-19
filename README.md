# Review all the things

At Shopify, we're very careful about what we push to production. Before we merge a pull request, at least two of our peers need to review and approve it. We're pretty much following a workflow that looks like this:

- We develop in a branch.
- We create a pull request and ping two of our peers in it.
- Suggestions are made, changes are discussed, more changes are committed as needed.
- When both peers approve by using a :ship:, :shipit: (or :sheep: depending on their accent), the pull request is merged.

This works reasonably well, but there is one problem.

### There is one problem

When I'm pinged in a pull request, I get an alert by email. Quite often, I open this email, take a quick look at the pull request and then decide to finish this one little thing I was working on before going through the changes. Of course, this is asking for trouble, because I often forget. I also tend to lose track of which PRs I still need to review if there are more than one.

### What is this?

This project attempts to solve this problem. It's a chrome extension that adds an icon in the top right of your browser (if you're using Chrome, but really, why would you not) that shows a badge with the number of pull requests you need to review. Clicking on it shows a list of links to those pull requests.

### How does it work?

The backend is a small Rails application that receives GitHub's webhooks. Using the information from these webhooks, the necessary data is saved to a database that contains all information about who needs to review what, and if what the status is of each review.

#### Pull request creation

When a pull request is opened, GitHub triggers a webhook. On the Rails side, the body of the pull request is parsed to look for mentions of GitHub users (starting with `@`). For each, a review entry is created with the status set to `to_review`.

#### A comment on a pull request

If a user comments on a pull request, and a review entry exists for this user, the body of the comment is parsed for emoji's. If more positive than negative emoji's are used, the status for that review is updated to `approved`. If more negative are found, it's `rejected`. Comments without emoji's, or an equal number of positive or negative ones, or comments from users that were not asked to review, are ignored.

#### A comment from the pull request owner

If the owner of the pull request comments, it is parsed - again - for mentions of GitHub users. If a GitHub user is mentioned that wasn't iniially asked to review the pull request, a review entry is created for them. If users are mentioned for whom a review entry already exists, the status of this entry is reset to `to_review`.

### The Chrome extension

The Chrome extension is a simple polling application that pings the Rails app every minute to get the list of pull requests I have to review.

### Installation

#### Setup a GitHub Oauth app.
Go [here](https://github.com/settings/applications) and setup a GitHub application. The only really important setting in here is **Authorization callback URL**, which needs to be set to `https://your-rails-app-url/auth/github/callback`. This is used when signing in to the Rails app using a GitHub account. Also take note of the *Client ID* and *Client Secret* which you'll need in the next step.

#### Host the Rails application
Host it somewhere public, becuase GitHub needs to be able to post it webhooks to it, preferably using HTTPS. The app runs well on Heroku. You'll also need to set a couple of ENV variables:

- `GITHUB_CLIENT_ID` : The GitHub Client ID from the previous step.
- `GITHUB_CLIENT_SECRET`: The GitHub Client Secret from the previous step.
- `GITHUB_WEBHOOK_SECRET` : The webhook secret (see next step). Optional, but HIGHLY RECOMMENDED.
- `VALIDATE_ORGANIZATION` : The name of your organization if (optional) if you only want to allow users from your organization.

#### Setup webhooks for the repositories you want to track
Go into your repository's settings and click *Webhooks & Services*. In the *Webhooks* section, click the *Add webhook* button and set the following:

- *Payload URL* : `https://your-rails-app-url/events/github`
- *Content type* : `application/json`
- *Secret* : Choose a strong secret, use the same as used in the `GITHUB_WEBHOOK_SECRET` env variable in your Rails application.
- *Which events...?* : Select *Let me select individual events.* and only select *Pull Request* and *Issue Comment* (GitHub treats pull requests as issues, and comments on a pull request trigger an issue comment webhook.)


#### Setup the Chrome extension
Install the Chrome extension from the `chrome_extension` folder in this repository. Richt click on the icon and click options. Fill in the details. It will ask you for a secret. This is **NOT** the secret you used for the GitHub webhooks, but your personal secret which can be obtained from the Rails application which you installed in step 2. Visit the front page and click 'login with GitHub'.
