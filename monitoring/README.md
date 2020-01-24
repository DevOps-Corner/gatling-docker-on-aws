# Realtime monitoring loadtest
To be able to realtime monitor the loadtest, we create a seperate InfluxDB and Grafana stack that can be deployed on a AWS cluster.
The Gatling tests will then use graphite to report their status/results to this cluster and we can view this in the included Grafana dashboard.

## Setting up
The cluster runs in a seperate AWS cluster. To start the monitoring cluster run `startMonitoringCluster.sh [-p aws-profile]`.
This will start and configure InfluxDb and Grafana. Both services are fully configured and don't need further configuring.
Retrieve the public ip of the task. Grafana will be available on port 3000 on that ip. Login with `admin/admin`.

### Gatling runners
The Gatling runners need to write their data to the InfluxDB. Since both run in the same VPC we can use the internal ip address.
Edit the `graphite` section in the `gatling.conf`. Edit the ip address where the InfluxDB lives, make sure to use the internal ip, since it is not forwarded to the public ip.
```
    graphite {
      light = false                            # only send the all* stats
      host = "<<insert private ip here>>"      # The host where the Carbon server is located
      port = 2003                              # The port to which the Carbon server listens to (2003 is default for plaintext, 2004 is default for pickle)
      protocol = "tcp"                         # The protocol used to send data to Carbon (currently supported : "tcp", "udp")
      rootPathPrefix = "gatling"               # The common prefix of all metrics sent to Graphite
      bufferSize = 8192                        # GraphiteDataWriter's internal data buffer size, in bytes
      writePeriod = 1                          # GraphiteDataWriter's write interval, in seconds
    }              
``` 

Then recreate the Gatling docker image on AWS to make sure the next run uses this image.  
Do this using `buildDockerImage.sh` script.

## Tearing down
When done with loadtesting we can take the monitor cluster down using the `stopMonitoringCluster.sh [-p aws-profile]` script.

## Making changes
Both InfluxDB and Grafana are fully configured using Docker files. When making changes update these files and not live, since these will not be saved when tearing down the cluster.
After making changes to one of the docker images, make sure to build the image and push it to ECR on AWS.
Use the `buildDockerImageForAWS.sh` script for this.
