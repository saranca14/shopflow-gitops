# ShopFlow GitOps

Single source of truth for what runs on all 3 EKS clusters. ArgoCD watches this repo and auto-syncs changes.

## Cluster Layout

```
clusters/
├── app/          # E-commerce app + OTel Agent
│   ├── apps/          # 6 microservices (Deployments + Services)
│   ├── datastores/    # PostgreSQL, Redis, RabbitMQ
│   ├── ingress/       # ALB Ingress
│   └── otel/          # OTel Collector DaemonSet (agent)
│
├── platform/          # CI/CD tools
│   ├── tekton/        # Pipelines, Tasks, Triggers
│   └── argocd/        # ArgoCD apps + cluster registrations
│
└── observability/     # Telemetry backends
    ├── otel-collector/ # OTel Collector Deployment (gateway)
    ├── jaeger/         # Distributed tracing UI
    ├── prometheus/     # Metrics storage
    └── grafana/        # Dashboards (admin/shopflow-admin)
```

## CI/CD Flow

```
Push to app repo → Tekton webhook → Build image → Push to ECR
                                   → Update image tag here
                                   → ArgoCD auto-syncs to cluster
```

## Setup

### 1. Install ArgoCD on Platform Cluster
```bash
kubectl config use-context shopflow-platform
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 2. Register Clusters in ArgoCD
```bash
argocd cluster add shopflow-app --name app
argocd cluster add shopflow-observability --name observability
```

### 3. Deploy ArgoCD Applications
```bash
kubectl apply -f clusters/platform/argocd/apps/
```

### 4. Install Tekton
```bash
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply -f clusters/platform/tekton/tasks/
kubectl apply -f clusters/platform/tekton/pipelines/
kubectl apply -f clusters/platform/tekton/triggers/
```

## Access UIs
```bash
# ArgoCD (platform cluster)
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Grafana (observability cluster)
kubectl port-forward svc/grafana -n monitoring 3000:3000

# Jaeger (observability cluster)
kubectl port-forward svc/jaeger-ui -n monitoring 16686:16686
```
