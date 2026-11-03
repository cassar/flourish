class MastodonNewDividendDistribution < SocialDistributionAnnouncement
  TEMPLATE_PATH = 'app/views/mastodon/new_dividend_distribution.txt.erb'.freeze
  POSTER_CLASS = MastodonPoster
end
