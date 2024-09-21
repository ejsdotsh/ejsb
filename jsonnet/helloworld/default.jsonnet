{
  local constant = import "../default-env.jsonnet",
  kubeconfig: {
    replicas: 1,
    mem_limit: "400Mi",
    mem_request: "100Mi",
    cpu_limit: 1,
    cpu_request: "10m",
    istio: "true",
    readOnlyRootFilesystem: true,
    liveness: true,
    readiness: true,
  },
  labels: {
    "main_path": "true",
  },
  affinity: {},
  env: {
    HTTPPORT: constant.env.HTTPPORT,
    LOGLEVEL: constant.env.LOGLEVEL,
 
    TOKENPRIVKEY : {
      secretKeyRef : {
        name: "helloword-keys",
        key: "private_key"
      }},
  }
}
