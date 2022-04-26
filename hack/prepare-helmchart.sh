#!/bin/bash

# ${1} is the given application-name from make (cluster-api-provider-openstack)

# as we apply the crd via configmap, name must be stripped to be RFC 1123 conform
# (lower case alphanumeric characters or '-', and must start and end with an alphanumeric character)
find config/kustomize/tmp/ -name "apiextensions.k8s.io_v1_customresourcedefinition*" | while read f; do
	mv -v ${f} helm/${1}/crds/${f/config\/kustomize\/tmp\/apiextensions.k8s.io_v1_customresourcedefinition_/}
done

find helm/${1}/crds/ -name "*infrastructure.cluster.x-k8s.io.yaml" | while read f; do
	mv -v ${f} ${f/infrastructure.cluster.x-k8s.io./}
done

# move everything from current tmp workdir over to helm
mv -v config/kustomize/tmp/* helm/${1}/templates