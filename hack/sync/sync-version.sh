#!/bin/bash

set -euo pipefail

cd "$(dirname "${0}")"
CAPO_SYNC_BRANCH=${CAPO_SYNC_BRANCH:-"main"}

# create a temporary directory and checkout CAPO there
TMPDIR=$(mktemp -d)
pushd "${TMPDIR}"

git clone https://github.com/kubernetes-sigs/cluster-api-provider-openstack.git
cd cluster-api-provider-openstack
git checkout "${CAPO_SYNC_BRANCH}"
RELEASE_TAG="dev" REGISTRY="giantswarm/kaas" make release-manifests

cd ..

popd

mkdir -p tmp
# cleanup leftover artifacts from a previous run (TODO: .gitignore)
rm -f tmp/*
# copy upstream generated release-manifests into tmp/
cp "${TMPDIR}/cluster-api-provider-openstack/out/infrastructure-components.yaml" "tmp/"

# defines the CAPI manifest folder
CAPI_MANIFEST_WORKING_DIR=../../helm/cluster-api-provider-openstack

# apply giantswarm specific configuration via kustomize
kubectl kustomize > "${CAPI_MANIFEST_WORKING_DIR}"/templates/cluster-api.yaml

# TODO mario
# sync container image to docker-hub/quay :shrug: (via skopeo)
