# aws-batch-ruby-runner

## Getting Started

```sh
bundle install
rake -T
# or...
rake -D

rake forecast:today
```

## Running docker

```sh
# set a version
export VERSION=1.0.0
export TAG=aws-batch-ruby-runner:$VERSION

# build the image
docker build . -t $TAG

# run interactive shell
docker run --rm -it $TAG sh

# run rake tasks

docker run --rm -it $TAG -T
docker run --rm -it $TAG forecast:today


```

## Troubleshooting

- [Complete Guide to setup VS Code for Ruby on Rails (Debugger, Linter, Completion, Formatting)](https://dev.to/abstractart/easy-way-to-setup-debugger-and-autocomplete-for-ruby-in-visual-studio-code-2gcc)
- <https://gorails.com/setup/ubuntu/21.04>

## Reference

- <https://github.com/httprb/http/wiki>
- <https://www.weather.gov/documentation/services-web-api?prevfmt=application%2Fcap%2Bxml&prevopt=zone%3DCAC033>
- <https://github.com/thisismydesign/easy_logging>
