# nginx-s3proxy
## Versions
- debian 9
- nginx 1.14.0
- ngx_aws_auth 2.1.1

## Start a container

```
$ docker run --rm -p 80:80 jiraffeinc/nginx-s3proxy
```

## Sample config

```
server {
    aws_access_key ACCESS_KEY;
    aws_key_scope KEY_SCOPE;
    aws_signing_key SIGNING_KEY;
    resolver               1.1.1.1 valid=300s;
    resolver_timeout       10s;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods "POST, GET, OPTIONS";
        add_header Access-Control-Allow-Headers "Origin, Authorization, Accept";
        aws_sign;
        aws_s3_bucket BUCKET_NAME;
        proxy_pass http://BUCKET_URL/;
    }
}
```
