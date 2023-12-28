# Docker vs. Kubernetes

It is just an example for e-book to show how we can achieve a simple contenerized application easily.

## Requirements

1. Docker
2. Node >20.10.0 + NPM

## Startup

Copy and paste `.env.dist` file. Save it as `.env`.

```shell
    docker compose up --build -d
```

## To check how backend works

```shell
    docker compose logs backend -f
```