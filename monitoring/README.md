#WIP Realtime monitoring

### Locally
Run `docker-compose up -d` to start a influxdb/grafana stack with graphite enabled

### Running on AWS
Using Cloudformation to start a grafana service on aws:  
`aws cloudformation deploy --stack-name test --template-file test.yml --profile richard --parameter-overrides "Subnets"="<something>>" "VpcId"="<something>"`  
Using for inspiration:  
https://medium.com/@andepaulj/deploying-grafana-with-aws-fargate-f6061cc5e61d
