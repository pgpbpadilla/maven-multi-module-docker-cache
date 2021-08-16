# Docker cache for multi-module Maven project

This project demonstrates how to write a multi-stage Dockerfile for a 
multi-module Maven project, so that Maven dependencies are 
cached in the early Docker layers of a __builder__ stage and also
how to use a layered JAR to create cache layers in the final Docker image.

In this project the `user-app` module depends on a `common` module.

## Using BuildKit

```shell
DOCKER_BUILDKIT='1' docker build \
    -t pgpb/user-app:local \
    -f docker/user-app.dockerfile . \
    && docker run -it pgpb/user-app:local
```

## Withut BuildKit

```shell
docker build \
    -t pgpb/user-app:local \
    -f docker/user-app.dockerfile . \
    && docker run -it pgpb/user-app:local
```


## References

- [Creating Docker images with Spring Boot](https://spring.io/blog/2020/01/27/creating-docker-images-with-spring-boot-2-3-0-m1). Shows how to
use a layered JAR to cache layers in the final stage of the multi-stage Dockerfile. 
However, it does not cover how to cache layers for the first stage.
