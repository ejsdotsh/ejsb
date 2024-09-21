{
  "app": "",
  "commitId": "",
  "namespace": "",
  "repoUrl": "your.docker.repo:4567",
   labels: {
    "appgroup": "unicorns-wtf",
    "metrics": "true",
  },"command": [],
  "args": [],
  "env": {
    LOGLEVEL: "WARN",
    LOGLEVELDEV: "DEBUG",
    LOGLEVELINTEGRATION: "INFO",
    HTTPPORT: "1080",
  },
  kubeconfig: {
    "replicas": 1,
    "mem_limit": "250Mi",
    "mem_request": "100Mi",
    "cpu_limit": "0.01",
    "cpu_request": "0.1",
    "istio": false,
    "readOnlyRootFilesystem": true,
    "liveness": true,
    "readiness": true,
  },
  "volumeMounts": {},
  "volumes": {},  "ports": {
    "http": {
      "containerPort": 1080,
      "protocol": "TCP",
    },
    "grpc": {
      "containerPort": 1081,
      "protocol": "TCP",
    }
  },
}
