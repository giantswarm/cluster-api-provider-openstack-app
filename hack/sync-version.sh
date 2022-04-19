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

cd .. # ??

popd

# copy upstream generated release-manifests into origin
cp -v "${TMPDIR}/cluster-api-provider-openstack/out/infrastructure-components.yaml" "../config/kustomize/origin/"
