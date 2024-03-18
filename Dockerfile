FROM ruby:3.3.0
WORKDIR /myapp
# nodejsをインストール

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
	&& apt-get install -y nodejs

#yarnをインストール
RUN npm install --global yarn

# ソースコードの変更があっても、依存関係の再インストールを回避するため、
# Gemfileなどを先にコピー。（先にコピーすれば、キャッシュとして後から使える。
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundlerの不具合対策
RUN gem update --system
RUN gem update bundler

# gemのバージョン管理のため、bundleをインストール
RUN bundle install

# 依存関連のインストールが終わったので、他のファイルをコンテナに移す
COPY . /myapp

# 環境変数
ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

CMD ['ruby', './main.rb']
