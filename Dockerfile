FROM ruby:2.3.0

# Create app directory
ENV APP_HOME /usr/src/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Copy Gemfile
ADD Gemfile* $APP_HOME/

# Set Bundler cache directory outside of app scope
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle

# Install gems
RUN bundle install --quiet

# Copy working directory
ADD . $APP_HOME

# Create tmp directory
RUN mkdir $APP_HOME/tmp && \
    mkdir $APP_HOME/tmp/pids \
    mkdir $APP_HOME/log

EXPOSE 80

CMD bundle exec ruby server.rb
