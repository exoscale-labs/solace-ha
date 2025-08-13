# solace-ha
Solace HA deployment on Exoscale using Terraform

## solace-event-mesh
Based on the Solace HA deployment, an Event Mesh between a local and remote Solace HA Broker is established.

The local broker is initiating the Dynmic Message Routing (DMR) Bridge towards the remote broker, setting up a bidirectional bridge.

The DMR bridge allows for dynamic and transparent distribution of data between different environments.

The following TF variables need to be set for the local and remote broker.

One use case for this unique functionality is a seamless cloud migration to a European cloud provider for example.

### TF Variables for local broker

### TF Variables for remote broker
