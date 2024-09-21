local kube = import "vendor/kube-libsonnet/kube.libsonnet";

{
  config:: error "this file assumes a config variable",
  dep:: error "this file assumes a deployment variable",
  portName:: "http",
  labels+:: {} + $.config.labels,
  // set the Service name to the app name when it's the GRPC port, else, add the port name
  local serviceName = if  $.portName == "grpc" then $.config.app else $.config.app + "-" + $.portName,
  // set the service type to enable external acces in minikube
  local serviceType = if $.config.environment == "minikube" then "NodePort" else "ClusterIP",  service: kube.Service(serviceName) {
    metadata+: {
      labels+: $.labels,
      namespace:: $.config.namespace,
    },
    target_pod: $.dep.deployment.spec.template,
    spec: {
      ports: [
        {
        name: $.portName,
        port: $.config.ports[$.portName].containerPort,
        targetPort: $.config.ports[$.portName].containerPort,
        }
      ],
      selector: {
        app: $.config.app,
      },
      type: serviceType,
    },
  },
}
