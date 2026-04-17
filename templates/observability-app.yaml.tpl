---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: observability-stack
  namespace: argocd
spec:
  project: default
  source:
    repoURL: ${repo_url}
    targetRevision: main
    path: clusters/observability
    directory:
      recurse: true
  destination:
    server: ${obs_cluster_endpoint}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
