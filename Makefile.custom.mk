##@ App

SHELL := /bin/bash

APPLICATION_NAME="cluster-api-provider-openstack"

.PHONY: all
all: fetch-upstream-manifest apply-kustomize-patches helm-chart ## all

.PHONY: fetch-upstream-manifest
fetch-upstream-manifest: ## fetch upstream manifest from
	# fetch upstream released manifest yaml
	./hack/sync-version.sh

.PHONY: apply-kustomize-patches
apply-kustomize-patches: ## apply giantswarm specific patches
	kubectl kustomize config/kustomize -o config/kustomize/tmp

.PHONY: helm-chart
helm-chart: ## finalize the helm-chart
	# as we apply the crd via configmap, name must be stripped to be RFC 1123 conform (lower case alphanumeric characters or '-', and must start and end with an alphanumeric character)
	find config/kustomize/tmp/ -name "apiextensions.k8s.io_v1_customresourcedefinition*" | while read f; do \
		mv -v $${f} helm/${APPLICATION_NAME}/crds/$${f/config\/kustomize\/tmp\/apiextensions.k8s.io_v1_customresourcedefinition_/}; \
	done

	find helm/${APPLICATION_NAME}/crds/ -name "*infrastructure.cluster.x-k8s.io.yaml" | while read f; do \
		mv -v $${f} $${f/infrastructure.cluster.x-k8s.io./}; \
	done
	
	mv -v config/kustomize/tmp/* helm/${APPLICATION_NAME}/templates
