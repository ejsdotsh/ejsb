local config = import "../default-env.jsonnet";
local kube = import "../vendor/kube-libsonnet/kube.libsonnet";
local environmentVars = std.extVar('env');
local commitId = std.extVar('commit');
local namespace = std.extVar('namespace');
local localApp = config + environmentVars + {
  app: "helloworld",
  commitId: commitId,
  namespace: if namespace != "" then namespace else null,
  
  // Namespace is not used in templates for now
  project: "helloworld",
  group: "servers",
  
  // computed vars
  deployment_name: "%s" % [self.app],
  repoPath: "%s/%s"% [self.group,self.project],
  image_path: if environmentVars.environment != "minikube" then "%s/%s/%s/%s" % [self.repoUrl, self.repoPath, self.appGroup, self.app] else "%s/%s" % [self.appGroup, self.app],
  
  // merge env and labels !!! don't remove
  env: environmentVars.env,
  labels+: config.labels + environmentVars.labels + {
    "app": $.app,
    "group": $.group,
    "project": $.project,
    "commit": $.commitId,
    "version": $.commitId,
    "track": $.namespace,
    "environment": $.environment
  },
  ports: {
    http: {
      containerPort: std.parseInt($.env.HTTPPORT),
      protocol: "TCP"
    }
  },
};

// List of templates to generate
local serviceHttp = (import "../service-base.jsonnet") + {
  config: localApp,
  portName: "http"
};

local deployment = (import "../deployment-base.jsonnet") + {
  config: localApp,
};

// final list of all manifests
local all = [deployment.deployment, serviceHttp.service];

// generate a K8s list
{
  apiVersion: "v1",
  kind: "List",
  items: all,
}
