[![CircleCI](https://circleci.com/gh/giantswarm/cluster-api-provider-openstack-app.svg?style=shield)](https://circleci.com/gh/giantswarm/cluster-api-provider-openstack-app)

# cluster-api-provider-openstack-app

Cluster API Provider OpenStack - packaged as a Giant Swarm app.

This repository is primary used to import the upstream Cluster API Provider OpenStack manifests into Giant Swarms own app catalog.

Content of the `/helm` directory will be bundled, released and pushed to the `app-catalog` via [`architect`](https://github.com/giantswarm/architect). This happens automatically and is done by [this](.circleci/config.yml) `circleCI` configuration.

> To keep it quite easy to update the manifest from upstream, we don't change the fetched manifests directly. All Giant Swarm specific adjustments got applied via `kustomize`.

## Usage

How to work within this repository?

### apply new `kustomize` changes to the charts

1. if not already done, run `make fetch-upstream-manifest` (only has to be done once)
   > upstream manifest will be stored in [`config/kustomize/origin`](config/kustomize/origin)
1. write your desired changes as kustomize patches in [config/kustomize]
1. run `make apply-kustomize-patches` to apply the changes\n
   > this will generate a patched version unter [`config/kustomize/tmp`](config/kustomize/tmp)
1. once you're done, run `make release-manifests` to move all relevant files into the [`helm/cluster-api-provider-openstack`](helm/cluster-api-provider-openstack) folder

### update to a newer CAPO release

1. edit the value of `CAPO_VERSION` in [the Makefile](Makefile.custom.mk) to the desired CAPO version
1. run `make all`

# Useful links

* [CAPO book](https://cluster-api-openstack.sigs.k8s.io/)
* internal CAPO fork - [`giantswarm/cluster-api-provider-openstack`](https://github.com/giantswarm/cluster-api-provider-openstack)
