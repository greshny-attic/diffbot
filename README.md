# Diffbot

This is a ruby client for the [Diffbot](http://diffbot.com) API.

## Install

Get the latest version from RubyGems:

    $ gem install diffbot

## Global Options

You can pass some settings to Diffbot like this:

``` ruby
Diffbot.configure do |config|
  config.token = ENV["DIFFBOT_TOKEN"]
  config.instrumentor = ActiveSupport::Notifications
end
```

The list of supported settings is:

* `token`: Your Diffbot API token. This will be used for all requests in which
  you don't specify it manually (see below).
* `instrumentor`: An object that matches the [ActiveSupport::Notifications][1]
  API, which will be used to trace network events. None is used by default.
* `article_defaults`: Pass a block to this method to configure the global
  request settings used for Diffbot::Article requests. See below the options
  supported.

[1]: http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html

## Articles

In order to fetch an article, do this:

``` ruby
require "diffbot/article"

article = Diffbot::Article.fetch(article_url, diffbot_token)

# Now you can inspect the result:
article.title
article.author
article.date
article.text
# etc. See below for the full list of available response attributes.
```

This is a list of all the fields returned by the `Diffbot::Article.fetch` call:

* `url`: The URL of the article.
* `title`: The title of the article.
* `author`: The author of the article.
* `date`: The date in which this article was published.
* `media`: A list of media items attached to this article.
* `text`: The body of the article. This will be plain text unless you specify
  the HTML option in the request.
* `tags`: A list of tags/keywords extracted from the article.
* `xpath`: The XPath at which this article was found in the page.

### Options

You can customize your request like this:

``` ruby
article = Diffbot::Article.fetch(article_url, diffbot_token) do |request|
  request.html = true # Return HTML instead of plain text.
  request.dont_strip_ads = true # Leave any inline ads within the article.
  request.tags = true # Generate ads for the article.
  request.comments = true # Extract the comments from the article as well.
  request.summary = true # Return a summary text instead of the full text.
  request.stats = true # Return performance, probabilistic scoring stats.
end
```

## Frontpages

In order to fetch and analyze a front page, do this:

``` ruby
require "diffbot/frontpage"

frontpage = Diffbot::Frontpage.fetch(url, diffbot_token)

# Results are available in the returned object:
frontpage.title
frontpage.icon
frontpage.items #=> An array of Diffbot::Item instances
```

The fields you can extract from a Frontpage are:

* `title`: The title of the page.
* `icon`: The favicon of the page.
* `source_type`: What kind of page this is.
* `source_url`: The URL of the page.
* `items`: The list of `Diffbot::Item` representing each item on the page.

The instances of `Diffbot::Item` have the following fields:

* `id`: Unique identifier for this item.
* `title`: Title of the item.
* `link`: Extracted permalink of the item (if applicable).
* `description`: innerHTML content of the item.
* `summary`: A plain-text summary of the item.
* `pub_date`: Date when item was detected on page.
* `type`: The type of item, according to Diffbot. One of: `IMAGE`, `LINK`,
  `STORY`, `CHUNK`.
* `img`: The main image extracted from this item.
* `xroot`: XPath of where the item was found on the page.
* `cluster`: XPath of the cluster of items where this item was found.
* `stats`: An object with the following attributes:
  * `spam_score`: A Float between 0.0 and 1.0 indicating the probability this
    item is spam/an advertisement.
  * `static_rank`: A Float between 1.0 and 5.0 indicating the quality score of
    the item.
  * `fresh`: The percentage of the item that has changed compared to the
    previous crawl.

## TODO

* Implement the Follow API.
* Add tests for Article and Frontpage requests.
* Add a Frontpage.crawl method that given the URL of a frontpage, it will fetch
  the article for each item in the page.

## License

This is published under an MIT License, see LICENSE for further details.
