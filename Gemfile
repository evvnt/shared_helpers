# frozen_string_literal: true

source "https://rubygems.org"

ruby `[  -z "$RBENV_VERSION" ] && cat .ruby-version || echo $RBENV_VERSION`

gemspec

gem 'pry', group: :development

group :test do
  gem 'rspec'
end