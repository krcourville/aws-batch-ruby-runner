# aws-batch-ruby-runner

Sample AWS Batch process using plain Ruby tasks managed via Rake.

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
export VERSION=$(cat VERSION)
export TAG=krcourville/ruby-runner:$VERSION

# build the image
docker build . -t $TAG

# run interactive shell
docker run --rm -it --entrypoint sh $TAG

# run rake tasks

docker run --rm -it $TAG rake -T
docker run --rm -it $TAG forecast:today
```

## Deploy a new version

```sh
# 1. Review version in ./VERSION
# 2. increment using semantic versioning
# 3. Set version and tag
export VERSION=$(cat VERSION)
export TAG=krcourville/ruby-runner:$VERSION
# 4. build and tag
docker build . -t $TAG
# 5. push
docker push $TAG
# 6.update Batch Job Definition:
# 6a. Set other required Terraform params
export TF_VAR_app_image=$TAG

pushd infrastructure
terraform apply
popd
# 7.commit changes
git add... git commit...etc..
# 8. tag the repo:
git tag $VERSION && git push --tags
```

## Troubleshooting

Error: Creating CloudWatch Log Group failed: ResourceAlreadyExistsException: The specified log group already exists: The CloudWatch Log Group '/aws/batch/job' already exists.

Be sure to import and properly manage retention of /aws/batch/job log group

```sh
terraform import aws_cloudwatch_log_group.aws_batch_job_log_group /aws/batch/job
```

- [Complete Guide to setup VS Code for Ruby on Rails (Debugger, Linter, Completion, Formatting)](https://dev.to/abstractart/easy-way-to-setup-debugger-and-autocomplete-for-ruby-in-visual-studio-code-2gcc)
- <https://gorails.com/setup/ubuntu/21.04>

## Reference

- <https://lipanski.com/posts/dockerfile-ruby-best-practices>
- <https://github.com/httprb/http/wiki>
- <https://www.weather.gov/documentation/services-web-api?prevfmt=application%2Fcap%2Bxml&prevopt=zone%3DCAC033>
- <https://github.com/thisismydesign/easy_logging>
