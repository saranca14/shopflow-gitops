---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-apps
  namespace: argocd
spec:
  project: default
  source:
    repoURL: ${repo_url}
    targetRevision: main
    path: clusters/app
  destination:
    server: ${app_cluster_endpoint}
    namespace: ecommerce
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
