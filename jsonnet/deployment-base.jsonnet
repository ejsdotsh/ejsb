local kube = import "vendor/kube-libsonnet/kube.libsonnet";

{
  config:: error "this file assumes a config variable",
  labels+:: {} + $.config.labels,
  
  deployment: kube.Deployment(
    labels+:: {} + $.config.labels,
    metadata+: {
      labels+: $.labels,
      namespace:: $.config.namespace,
    },
    spec+: {
      replicas: 1,
      template+: {
      spec+: {
        volumes_+: $.config.volumes,
        containers_+: {
        default: kube.Container($.config.app) {
          image: $.config.image_path + ":" + $.config.commitId,
          resources: {
            requests: { 
              cpu: $.config.kubeconfig.cpu_request,
              memory: $.config.kubeconfig.mem_request
            },
            limits: {
              cpu: $.config.kubeconfig.cpu_limit,
              memory: $.config.kubeconfig.mem_limit
            },
          },
          livenessProbe: if $.config.kubeconfig.liveness then {
            httpGet:{
              path: "/healthz",
              port: "http",
              scheme: "HTTP"
            },
            initialDelaySeconds: 3,
            periodSeconds: 3,
          },
          readinessProbe: if $.config.kubeconfig.readiness then {
            httpGet:{
              path: "/ready",
              port: "http",
                    scheme: "HTTP"
            },
            initialDelaySeconds: 3,
            periodSeconds: 3,
          } else if $.config.kubeconfig.liveness
          then{
            httpGet:{
              path: "/healthz",
              port: "http"
            },
            initialDelaySeconds: 3,
            periodSeconds: 3,
          },
        args: $.config.args,
        command: $.config.command,
        env_: $.config.env,
        ports_+: $.config.ports,
        volumeMounts_+: $.config.volumeMounts,
      }}
    }}
  }
}}
