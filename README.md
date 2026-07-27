# Octopus Deploy Management Repository

Centralized IaC, GitOps configuration, and operational tooling for managing the Octopus Deploy instance and its Kubernetes deployment targets. Content is being migrated in from two working-progress repos (`iac-octopus`, `argocd-octopus-demo`); this repo is the long-term home.

## Layout

- **`terraform/instance-infrastructure/`** — Provisions the underlying AKS cluster: resource group, node pool, networking. The foundation layer; no cluster software installed here.
- **`terraform/kubernetes-paas/`** — Installs cluster-level platform pieces on top of the cluster: ArgoCD, the Octopus ArgoCD Gateway, and the Octopus Kubernetes Agent deployment target.
- **`kubernetes/application-manifests/`** — Application-level manifests, Helm charts, and Kustomize overlays deployed onto the cluster (raw YAML, Kustomize, and Helm approaches).
- **`kubernetes/argocd/development-loop/`** — ArgoCD Application definitions for the dev → test → production promotion workflow.
- **`kubernetes/argocd/rollback-demo-application/`** — ArgoCD Application set up to demonstrate rollback/self-healing behavior.

## Status

Scaffold stage — folders are placeholders and content migration from `iac-octopus` and `argocd-octopus-demo` is in progress. This README will expand as each area fills in.
