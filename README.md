# :zap: Ember Thunderstorm

Ember.js app server multiple apps deployed with the Lightning deployment
strategy by [Ember Deploy](http://ember-cli.com/ember-cli-deploy). This means
Redis is used for index lookup and static assets are stored in a S3 bucket.

## Usage

The app server is provided as a Docker container and is meant to be run behind
a HTTP server like Nginx or Apache.

Ensure you have a Redis running:

```
docker run -d --name redis redis
```

Then start Ember Thunderstorm and link the Redis instance:

```
docker run -p 8080:80 -d --link redis:redis --name ember-thunderstorm lawitschka/ember-thunderstorm
```

Then place an Nginx in front with a config along those lines:

```
server {
    listen 80;
    server_name ember-app.example.com;

    location / {
      proxy_pass            http://localhost:8080/ember-app;
      proxy_read_timeout    90;
      proxy_connect_timeout 90;
      proxy_redirect        off;

      proxy_set_header      Host $host;
      proxy_set_header      X-Real-IP $remote_addr;
      proxy_set_header      X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header      X-Forwarded-Proto $scheme;
    }
}
```
