---
name: kubernetes
description: Use when working with Kubernetes operations.
---

# Kubernetes Operations Skill

This skill provides guidance for working with Kubernetes using `kubectl`.

## Important: Sandbox Mode

Kubernetes operations require **unsandbox mode** to execute. Commands that interact with the Kubernetes API will fail in sandboxed mode.

## Available Commands

### Viewing Resources

| Operation | Command |
|-----------|---------|
| List pods | `kubectl get pods` |
| List all resources | `kubectl get all` |
| Describe resource | `kubectl describe <resource> <name>` |
| Get YAML output | `kubectl get <resource> <name> -o yaml` |
| Get JSON output | `kubectl get <resource> <name> -o json` |
| Watch resources | `kubectl get pods -w` |

### Namespaces

| Operation | Command |
|-----------|---------|
| List namespaces | `kubectl get namespaces` |
| Set default namespace | `kubectl config set-context --current --namespace=<ns>` |
| Get resources in namespace | `kubectl get pods -n <namespace>` |
| Get resources in all namespaces | `kubectl get pods -A` |

### Logs & Debugging

| Operation | Command |
|-----------|---------|
| View logs | `kubectl logs <pod>` |
| Follow logs | `kubectl logs -f <pod>` |
| Logs from container | `kubectl logs <pod> -c <container>` |
| Previous container logs | `kubectl logs <pod> --previous` |
| Exec into pod | `kubectl exec -it <pod> -- /bin/sh` |

### Resource Management

| Operation | Command |
|-----------|---------|
| Apply manifest | `kubectl apply -f <file.yaml>` |
| Delete resource | `kubectl delete <resource> <name>` |
| Delete from file | `kubectl delete -f <file.yaml>` |
| Scale deployment | `kubectl scale deployment <name> --replicas=<n>` |
| Rollout status | `kubectl rollout status deployment/<name>` |
| Rollout history | `kubectl rollout history deployment/<name>` |
| Rollback | `kubectl rollout undo deployment/<name>` |

### Context & Config

| Operation | Command |
|-----------|---------|
| View current context | `kubectl config current-context` |
| List contexts | `kubectl config get-contexts` |
| Switch context | `kubectl config use-context <name>` |
| View config | `kubectl config view` |

## Best Practices

1. **Always specify namespace** explicitly with `-n <namespace>` to avoid mistakes
2. **Use `--dry-run=client -o yaml`** to preview changes before applying
3. **Check rollout status** after deployments: `kubectl rollout status deployment/<name>`
4. **Use labels for filtering**: `kubectl get pods -l app=myapp`
5. **Wait for conditions**: `kubectl wait --for=condition=ready pod -l app=myapp`

## Common Workflows

### Deploy and Verify

```bash
# 1. Apply manifest
kubectl apply -f deployment.yaml

# 2. Check rollout status
kubectl rollout status deployment/<name>

# 3. Verify pods are running
kubectl get pods -l app=<name>

# 4. Check logs if needed
kubectl logs -l app=<name>
```

### Debug Failed Pod

```bash
# 1. Get pod status
kubectl get pods

# 2. Describe pod for events
kubectl describe pod <pod-name>

# 3. Check logs
kubectl logs <pod-name>

# 4. Check previous container logs if restarting
kubectl logs <pod-name> --previous
```

### Preview Changes with Kustomize

```bash
# Use kzdiff to see changes (per CLAUDE.md)
kzdiff <kustomize-directory>
```
