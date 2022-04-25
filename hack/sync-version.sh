#!/bin/bash

set -euo pipefail

cd "$(dirname "${0}")"
CAPO_SYNC_BRANCH=${1:-"main"}

# create a temporary directory and checkout CAPO there
TMPDIR=$(mktemp -d)
pushd "${TMPDIR}"

git clone https://github.com/kubernetes-sigs/cluster-api-provider-openstack.git
pushd cluster-api-provider-openstack

if [[ ${2} == "tag" ]]; then
	git checkout tags/"${CAPO_SYNC_BRANCH}" -b "${CAPO_SYNC_BRANCH}"
else
	git checkout "${CAPO_SYNC_BRANCH}"
fi

# RELEASE_TAG and REGISTRY are only defined to have more unique strings to replace later via kustomize
RELEASE_TAG="dev" REGISTRY="giantswarm/kaas" make release-manifests

# remote cluster-api-provider-openstack from the stack
popd

# remote $TMPDIR from the stack
popd

# copy upstream generated release-manifests into origin
cp -v "${TMPDIR}/cluster-api-provider-openstack/out/infrastructure-components.yaml" "../config/kustomize/origin/"
