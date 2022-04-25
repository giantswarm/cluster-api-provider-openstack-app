##@ App

SHELL := /bin/bash

APPLICATION_NAME="cluster-api-provider-openstack"

CAPO_VERSION="v0.5.3"

.PHONY: all
all: fetch-upstream-manifest apply-kustomize-patches helm-chart ## all

.PHONY: fetch-upstream-manifest
fetch-upstream-manifest: ## fetch upstream manifest from
	# fetch upstream released manifest yaml
	./hack/sync-version.sh ${CAPO_VERSION} tag

.PHONY: apply-kustomize-patches
apply-kustomize-patches: ## apply giantswarm specific patches
	kubectl kustomize config/kustomize -o config/kustomize/tmp

.PHONY: helm-chart
helm-chart: ## finalize the helm-chart
	# move files from workdir over to helm directury structure
	./hack/prepare-helmchart.sh ${APPLICATION_NAME}
