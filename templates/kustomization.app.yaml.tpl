apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: ecommerce

resources:
  - ../../base/apps
  - ../../base/datastores
  - namespace.yaml

images:
%{ for service in services ~}
  - name: ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/shopflow/${service}
    newName: ${ecr_registry_url}/shopflow/${service}
%{ endfor ~}
