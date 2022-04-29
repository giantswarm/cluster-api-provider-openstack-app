#!/bin/bash

# ${1} is the given application-name from make (cluster-api-provider-openstack)

# let's rename everything to giantswarm namespace - it's much more easier to rename all occurences with sed than with kustomize - i've tried it :-)
find config/kustomize/tmp/ -type f | while read f; do
	sed -i 's/capo-system/giantswarm/g' ${f}
done

find config/kustomize/tmp -name ".*namespace.*" -delete

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
