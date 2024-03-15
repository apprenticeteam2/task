FROM ruby:3.3.0
WORKDIR /myapp

# ソースコードの変更があっても、依存関係の再インストールを回避するため
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundlerの不具合対策
RUN gem update --system
gem bundle update --bundler

RUN bundle install
copy . /myapp

