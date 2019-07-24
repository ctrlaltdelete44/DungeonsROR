# frozen_string_literal: true

module AccountsHelper
  # returns gravatar for given email
  def gravatar_for(email, options = { size: 4 })
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=300"
    image_tag(gravatar_url, alt: 'Profile picture', class: "br-100 w#{size} h#{size}")
  end
end
