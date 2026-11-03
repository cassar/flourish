class MastodonDistributionSettled < SocialDistributionAnnouncement
  TEMPLATE_PATH = 'app/views/mastodon/distribution_settled.txt.erb'.freeze
  POSTER_CLASS = MastodonPoster
end
