{
  local default = import "./default.jsonnet",
  local constant = import "../default-env.jsonnet",
  environment: "dev",
  kubeconfig+: default.kubeconfig + {
  },
  labels+: default.labels + {
  },
  env+: default.env + {
    LOGLEVEL: constant.env.LOGLEVELDEV,
  }
}
