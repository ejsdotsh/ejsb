{
  local default = import "./default.jsonnet",
  local constant = import "../default-env.jsonnet",
  environment: "integration",
  kubeconfig+: default.kubeconfig + {
    replicas: 5,
  },
  labels+: default.labels + {
  },
  env+: default.env + {
    LOGLEVEL: constant.env.LOGLEVELINTEGRATION,
  }
}
