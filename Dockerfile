FROM	debian:9

RUN	set -x \
	&& DEBIAN_FRONTEND=noninteractive \
	&& apt update \
	&& apt install -y \
		cmake \
		build-essential \
		git \
		bundler \
		ruby-dev \
		locales \
		ruby-execjs \
		zlib1g-dev \
	&& echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
	&& locale-gen \
	&& echo "source 'https://rubygems.org'" > /tmp/Gemfile \
	&& echo "gem 'github-pages', group: :jekyll_plugins" >> /tmp/Gemfile \
	&& bundle install --gemfile=/tmp/Gemfile \
	&& rm /tmp/Gemfile*

ENV LC_ALL=en_US.UTF-8

VOLUME	["/var/lib/github-pages"]
WORKDIR	/var/lib/github-pages

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE	4000

CMD	["bundle", "exec", \
	"jekyll", "serve", "--host=0.0.0.0", "--port=4000", "--trace"]
