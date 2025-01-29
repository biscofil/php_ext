# php_ext

https://hub.docker.com/repository/docker/biscofil/php_ext/tags

Includes:
- apache
  - rewrite
  - ssl
- php 7.4
- php extensions:
  - intl
  - gd
  - pcntl
  - mcrypt
  - pdo_mysql
  - zip
  - xdebug
  - pcov
  - soap
  - gmp
- composer

## Build

```shell
docker build -t biscofil/php_ext:7.4 .
```