#!/bin/bash

# ${1} is the given application-name from make (cluster-api-provider-openstack)

# as we apply the crd via configmap, name must be stripped to be RFC 1123 conform:
# * max length 253 characters
# * lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
find config/kustomize/tmp/ -regex ".*apiextensions.k8s.io_v1_customresourcedefinition.*" | while read f; do
	filename=$(basename "${f}")
	mv -v config/kustomize/tmp/"${filename}" helm/"${1}"/files/"${filename/apiextensions.k8s.io_v1_customresourcedefinition_/}"
done

# as we apply the crd via configmap, name must be stripped to be RFC 1123 conform:
# * max length 253 characters
# * lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
find helm/"${1}"/files/ -regex ".*infrastructure.cluster.x-k8s.io.yaml" | while read f; do
	mv -v "${f}" "${f/infrastructure.cluster.x-k8s.io./}"
done

# move everything from current tmp workdir over to helm
mv -v config/kustomize/tmp/* helm/"${1}"/templates
