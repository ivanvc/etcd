# Bump etcd Version in Kubernetes

This guide will walk through the update of etcd in Kubernetes to a new version (`kubernetes/kubernetes` repository).

We promote all of our stable branch images. And we bump the version used in the last three stable minor Kubernetes releases to comply with their [version support policy](https://kubernetes.io/releases/).

Bumping the etcd version in Kubernetes consists of two steps.

1. Promote the etcd images.
2. Update images used in Kubernetes.
3. Bump etcd client SDK.

## 1. Promote the etcd images

Reference: [etcd: Promote etcd images v3.4.42, v3.5.28, and v3.6.9](https://github.com/kubernetes/k8s.io/pull/9263).

In the [`kubernetes/k8s.io`](https://github.com/kubernetes/k8s.io) repository, append the digest for our published images in the file `registry.k8s.io/images/k8s-staging-etcd/images.yaml`.

The following commands help achieving what's required. Read through for the explanation of what we're doing.

First, run the following, setting the released versions:

```bash
export RELEASE_3_4_VERSION=3.4.42
export RELEASE_3_5_VERSION=3.5.27
export RELEASE_3_6_VERSION=3.6.9
```

Then, run the following:

```bash
for sfx in "" "-arm64" "-ppc64le"; do D=$(crane digest gcr.io/etcd-development/etcd:v${RELEASE_3_4_VERSION}${sfx}); [ -z "${sfx}" ] && T="v${RELEASE_3_4_VERSION},${RELEASE_3_4_VERSION}-0" || T="v${RELEASE_3_4_VERSION}${sfx}"; DIGEST=${D} TAGS=${T} yq -i '(.[] | select(.name=="etcd").dmap) |= (.[env(DIGEST)] = (env(TAGS) | split(",") | . style="flow" | .[] style="double") | with_entries(select(.key == env(DIGEST)).key style="double"))' registry.k8s.io/images/k8s-staging-etcd/images.yaml; done
for sfx in "" "-amd64" "-arm64" "-ppc64le" "-s390x"; do D=$(crane digest gcr.io/etcd-development/etcd:v${RELEASE_3_5_VERSION}${sfx}); [ -z "${sfx}" ] && T="v${RELEASE_3_5_VERSION},${RELEASE_3_5_VERSION}-0" || T="v${RELEASE_3_5_VERSION}${sfx}"; DIGEST=${D} TAGS=${T} yq -i '(.[] | select(.name=="etcd").dmap) |= (.[env(DIGEST)] = (env(TAGS) | split(",") | . style="flow" | .[] style="double") | with_entries(select(.key == env(DIGEST)).key style="double"))' registry.k8s.io/images/k8s-staging-etcd/images.yaml; done
for sfx in "" "-amd64" "-arm64" "-ppc64le" "-s390x"; do D=$(crane digest gcr.io/etcd-development/etcd:v${RELEASE_3_6_VERSION}${sfx}); [ -z "${sfx}" ] && T="v${RELEASE_3_6_VERSION},${RELEASE_3_6_VERSION}-0" || T="v${RELEASE_3_6_VERSION}${sfx}"; DIGEST=${D} TAGS=${T} yq -i '(.[] | select(.name=="etcd").dmap) |= (.[env(DIGEST)] = (env(TAGS) | split(",") | . style="flow" | .[] style="double") | with_entries(select(.key == env(DIGEST)).key style="double"))' registry.k8s.io/images/k8s-staging-etcd/images.yaml; done
```


In the [`kubernetes/k8s.io`](https://github.com/kubernetes/k8s.io) repository, append the digest for our published images in the file `registry.k8s.io/images/k8s-staging-etcd/images.yaml`. For example:

```diff
diff --git a/registry.k8s.io/images/k8s-staging-etcd/images.yaml b/registry.k8s.io/images/k8s-staging-etcd/images.yaml
index ee1aa5dc98b..3c9f400a305 100644
--- a/registry.k8s.io/images/k8s-staging-etcd/images.yaml
+++ b/registry.k8s.io/images/k8s-staging-etcd/images.yaml
@@ -625,6 +625,19 @@
     "sha256:82bf8bc50b9a953f8b477adb63f12637229d8044e85b21501a3c6a4be59afbb8": ["v3.6.8-arm64"]
     "sha256:84414327dd1c0c5a89fc21e6ed4be473dd96a60fdfbac8839a0f9ff872212868": ["v3.6.8-ppc64le"]
     "sha256:3ea799f4e1bb8b10b932d8f7de369d881eeaa89f4fadd5db500257538c38c1b7": ["v3.6.8-s390x"]
+    "sha256:0657100db443caff9283bba314bc25ac1b304c92f24380babf28a866e4539f8e": ["v3.4.42", "3.4.42-0"]
+    "sha256:29acc69c9ef1f5027ceef27e1cbd00c3130bc40c2d5ac8ab7247a996f65272cd": ["v3.4.42-arm64"]
+    "sha256:10487db2bdae4ac2f320959c491e021e915956a17c758c1faae150bceba1fdd3": ["v3.4.42-ppc64le"]
+    "sha256:b67c0b87ded6f1c7cb7860120fa23f03d34ab77911e5e1ee4a118c74adfd0842": ["v3.5.28", "3.5.28-0"]
+    "sha256:c48d23f0ee9a5a2dabeda5fc73699c89c10dad0dceb61d9d78d36bc72ee99d07": ["v3.5.28-amd64"]
+    "sha256:1d996069eccfad125961c953838f0e4b0e9b012ed5cf7eff099f24750521986f": ["v3.5.28-arm64"]
+    "sha256:c05ffb68bf0e684057edf82aa9a1e3f8d8120a7c3c1a08ee82cc91dfdd2b1641": ["v3.5.28-ppc64le"]
+    "sha256:5bb16564b5f797ef3b977ff401202e1c2e3a445b66f3bab4e7adfe9ecdbefbde": ["v3.5.28-s390x"]
+    "sha256:38e46ab26aa2a82251d3f24cbbdaefe2e68a66346404ee4b7afe7e90db26805d": ["v3.6.9", "3.6.9-0"]
+    "sha256:9c6399cc5c589d1fc828acc94fe9d1c7662dc5e93486a8791678aa08b3023afc": ["v3.6.9-amd64"]
+    "sha256:247e78b668299067e527426d57e6d4670d0893ad7ae706d042293754b2b362e0": ["v3.6.9-arm64"]
+    "sha256:621025003a32b6adf8e03e7e622c11232c49070256014cbc44c3a0aba2000ab2": ["v3.6.9-ppc64le"]
+    "sha256:c2943f8ed145cedf547de8f50b4d586e6c625cf4a1c5080033119fa45feb328e": ["v3.6.9-s390x"]
 - name: etcd-empty-dir-cleanup
   dmap:
     "sha256:f805272b4422efa92e20789295c343ed26ff36ddc4f70eeb5d7890d6b758b0fc": ["3.4.7.0"]
```

This is can be done with [`crane`](https://github.com/google/go-containerregistry/tree/main/cmd/crane) and [`yq`](https://github.com/mikefarah/yq), by running in the `k8s.io` repository the following snippet for v3.4 (replace `ETCD_VERSION` with the actual released version without the "v" prefix), in this case::

```bash
export RELEASE_3_4_VERSION=3.4.42
export RELEASE_3_5_VERSION=3.5.27
export RELEASE_3_6_VERSION=3.6.9

for sfx in "" "-arm64" "-ppc64le"; do D=$(crane digest gcr.io/etcd-development/etcd:v${RELEASE_3_4_VERSION}${sfx}); [ -z "${sfx}" ] && T="v${RELEASE_3_4_VERSION},${RELEASE_3_4_VERSION}-0" || T="v${RELEASE_3_4_VERSION}${sfx}"; DIGEST=${D} TAGS=${T} yq -i '(.[] | select(.name=="etcd").dmap) |= (.[env(DIGEST)] = (env(TAGS) | split(",") | . style="flow" | .[] style="double") | with_entries(select(.key == env(DIGEST)).key style="double"))' registry.k8s.io/images/k8s-staging-etcd/images.yaml; done
for sfx in "" "-amd64" "-arm64" "-ppc64le" "-s390x"; do D=$(crane digest gcr.io/etcd-development/etcd:v${RELEASE_3_5_VERSION}${sfx}); [ -z "${sfx}" ] && T="v${RELEASE_3_5_VERSION},${RELEASE_3_5_VERSION}-0" || T="v${RELEASE_3_5_VERSION}${sfx}"; DIGEST=${D} TAGS=${T} yq -i '(.[] | select(.name=="etcd").dmap) |= (.[env(DIGEST)] = (env(TAGS) | split(",") | . style="flow" | .[] style="double") | with_entries(select(.key == env(DIGEST)).key style="double"))' registry.k8s.io/images/k8s-staging-etcd/images.yaml; done
for sfx in "" "-amd64" "-arm64" "-ppc64le" "-s390x"; do D=$(crane digest gcr.io/etcd-development/etcd:v${RELEASE_3_6_VERSION}${sfx}); [ -z "${sfx}" ] && T="v${RELEASE_3_6_VERSION},${RELEASE_3_6_VERSION}-0" || T="v${RELEASE_3_6_VERSION}${sfx}"; DIGEST=${D} TAGS=${T} yq -i '(.[] | select(.name=="etcd").dmap) |= (.[env(DIGEST)] = (env(TAGS) | split(",") | . style="flow" | .[] style="double") | with_entries(select(.key == env(DIGEST)).key style="double"))' registry.k8s.io/images/k8s-staging-etcd/images.yaml; done
```

Then commit with the message:

> etcd: Promote etcd images v3.4.24, v3.5.27, v3.6.9

Open a pull request, and in the body link to our release issues, and add all of the crane digests.

## 2. Update images used in Kubernetes

Reference: [etcd: update etcd image to v3.6.9](https://github.com/kubernetes/kubernetes/pull/137956)

1. In the [`kubernetes/kubernetes`](https://github.com/kubernetes/kubernetes) repository, update `build/dependencies.yaml` set `etcd-image`'s `version` to the latest version.

    ```diff
    diff --git a/build/dependencies.yaml b/build/dependencies.yaml
    index aff02536..9d81ba6f 100644
    --- a/build/dependencies.yaml
    +++ b/build/dependencies.yaml
    @@ -64,7 +64,7 @@ dependencies:

       # etcd
       - name: "etcd"
    -    version: 3.6.8
    +    version: 3.6.9
         refPaths:
         - path: cluster/gce/manifests/etcd.manifest
           match: etcd_docker_tag|etcd_version
    ```

2. In `cluster/gce/manifests/etcd.manifest`, change the image tag to the new image tag and `TARGET_VERSION` to the new version.

    ```diff
diff --git a/cluster/gce/manifests/etcd.manifest b/cluster/gce/manifests/etcd.manifest
index aae56ec2..e2002c32 100644
--- a/cluster/gce/manifests/etcd.manifest
+++ b/cluster/gce/manifests/etcd.manifest
@@ -18,7 +18,7 @@
     {
     "name": "etcd-container",
     {{security_context}}
-    "image": "{{ pillar.get('etcd_docker_repository', 'registry.k8s.io/etcd') }}:{{ pillar.get('etcd_docker_tag', '3.6.8-0') }}",
+    "image": "{{ pillar.get('etcd_docker_repository', 'registry.k8s.io/etcd') }}:{{ pillar.get('etcd_docker_tag', '3.6.9-0') }}",
     "resources": {
       "requests": {
         "cpu": {{ cpulimit }}
@@ -43,7 +43,7 @@
         "value": "{{ pillar.get('storage_backend', 'etcd3') }}"
       },
       { "name": "TARGET_VERSION",
-        "value": "{{ pillar.get('etcd_version', '3.6.8') }}"
+        "value": "{{ pillar.get('etcd_version', '3.6.9') }}"
       },
       {
         "name": "DO_NOT_MOVE_BINARIES",
    ```

3. In `cluster/gce/upgrade-aliases.sh`, update the exports for `ETCD_IMAGE` to the new image tag and `ETCD_VERSION` to the new version.

    ```diff
    diff --git a/cluster/gce/upgrade-aliases.sh b/cluster/gce/upgrade-aliases.sh
    index a6ffe1bc..b25a2dd9 100755
    --- a/cluster/gce/upgrade-aliases.sh
    +++ b/cluster/gce/upgrade-aliases.sh
    @@ -170,8 +170,8 @@ export KUBE_GCE_ENABLE_IP_ALIASES=true
     export SECONDARY_RANGE_NAME="pods-default"
     export STORAGE_BACKEND="etcd3"
     export STORAGE_MEDIA_TYPE="application/vnd.kubernetes.protobuf"
    -export ETCD_IMAGE=3.6.8-0
    -export ETCD_VERSION=3.6.8
    +export ETCD_IMAGE=3.6.9-0
    +export ETCD_VERSION=3.6.9

     # Upgrade master with updated kube envs
     "${KUBE_ROOT}/cluster/gce/upgrade.sh" -M -l
    ```

4. In `cmd/kubeadm/app/constants/constants.go`, change the `DefaultEtcdVersion` to the new version. In the same file, update `SupportedEtcdVersion` accordingly.

    ```diff
    diff --git a/cmd/kubeadm/app/constants/constants.go b/cmd/kubeadm/app/constants/constants.go
    index 7c383dfd..77787a36 100644
    --- a/cmd/kubeadm/app/constants/constants.go
    +++ b/cmd/kubeadm/app/constants/constants.go
    @@ -326,7 +326,7 @@ const (
            MinExternalEtcdVersion = "3.5.24-0"

            // DefaultEtcdVersion indicates the default etcd version that kubeadm uses
    -       DefaultEtcdVersion = "3.6.8-0"
    +       DefaultEtcdVersion = "3.6.9-0"

            // Etcd defines variable used internally when referring to etcd component
            Etcd = "etcd"
    @@ -508,9 +508,9 @@ var (
            // an etcd version even if the map is not yet updated before a release. The user will
            // get a warning in that case, so ideally the map should be updated for each release.
            SupportedEtcdVersion = map[uint8]string{
    -               34: "3.6.8-0",
    -               35: "3.6.8-0",
    -               36: "3.6.8-0",
    +               34: "3.6.9-0",
    +               35: "3.6.9-0",
    +               36: "3.6.9-0",
            }

            // KubeadmCertsClusterRoleName sets the name for the ClusterRole that allows
    ```

5. In `hack/lib/etcd.sh`, update the `ETCD_VERSION`.

    ```diff
    diff --git a/hack/lib/etcd.sh b/hack/lib/etcd.sh
    index 15c4e59b..7ae96789 100755
    --- a/hack/lib/etcd.sh
    +++ b/hack/lib/etcd.sh
    @@ -16,7 +16,7 @@

     # A set of helpers for starting/running etcd for tests

    -ETCD_VERSION=${ETCD_VERSION:-3.6.8}
    +ETCD_VERSION=${ETCD_VERSION:-3.6.9}
     ETCD_HOST=${ETCD_HOST:-127.0.0.1}
     ETCD_PORT=${ETCD_PORT:-2379}
     # This is intentionally not called ETCD_LOG_LEVEL:
    ```

6. In `staging/src/k8s.io/sample-apiserver/artifacts/example/deployment.yaml`, update the etcd image used.

    ```diff
    diff --git a/staging/src/k8s.io/sample-apiserver/artifacts/example/deployment.yaml b/staging/src/k8s.io/sample-apiserver/artifacts/example/deployment.yaml
    index f66e9638..476e6391 100644
    --- a/staging/src/k8s.io/sample-apiserver/artifacts/example/deployment.yaml
    +++ b/staging/src/k8s.io/sample-apiserver/artifacts/example/deployment.yaml
    @@ -26,4 +26,4 @@ spec:
             imagePullPolicy: Never
             args: [ "--etcd-servers=http://localhost:2379" ]
           - name: etcd
    -        image: registry.k8s.io/etcd:v3.6.8
    +        image: registry.k8s.io/etcd:v3.6.9
    ```

8. In `test/e2e/testing-manifests/statefulset/etcd/statefulset.yaml`, update the image tag:

    ```diff
    diff --git a/test/e2e/testing-manifests/statefulset/etcd/statefulset.yaml b/test/e2e/testing-manifests/statefulset/etcd/statefulset.yaml
    index 7aa24c70..c2dbea5a 100644
    --- a/test/e2e/testing-manifests/statefulset/etcd/statefulset.yaml
    +++ b/test/e2e/testing-manifests/statefulset/etcd/statefulset.yaml
    @@ -18,7 +18,7 @@ spec:
         spec:
           containers:
           - name: etcd
    -        image: registry.k8s.io/etcd:3.6.8-0
    +        image: registry.k8s.io/etcd:3.6.9-0
             imagePullPolicy: Always
             ports:
             - containerPort: 2380
    ```

7. Finally, in `test/utils/image/manifest.go`, update the etcd image tag.

    ```diff
    diff --git a/test/utils/image/manifest.go b/test/utils/image/manifest.go
    index d17bbc91..0f581e4e 100644
    --- a/test/utils/image/manifest.go
    +++ b/test/utils/image/manifest.go
    @@ -215,7 +215,7 @@ func initImageConfigs(list RegistryList) (map[ImageID]Config, map[ImageID]Config
            configs[AppArmorLoader] = Config{list.PromoterE2eRegistry, "apparmor-loader", "1.4"}
            configs[BusyBox] = Config{list.PromoterE2eRegistry, "busybox", "1.37.0-1"}
            configs[DistrolessIptables] = Config{list.BuildImageRegistry, "distroless-iptables", "v0.9.0"}
    -       configs[Etcd] = Config{list.GcEtcdRegistry, "etcd", "3.6.8-0"}
    +       configs[Etcd] = Config{list.GcEtcdRegistry, "etcd", "3.6.9-0"}
            configs[InvalidRegistryImage] = Config{list.InvalidRegistry, "alpine", "3.1"}
            configs[IpcUtils] = Config{list.PromoterE2eRegistry, "ipc-utils", "1.4"}
            configs[GlibcDnsTesting] = Config{list.PromoterE2eRegistry, "glibc-dns-testing", "2.0.0"}
    ```

8. Commit with a message as:
    > etcd: update etcd image to v3.6.9

9. Then, open a pull request. Follow the next guidance:
    * The kind should be `cleanup`
    * In why do we need this pull request, it should be: "Updates the etcd image to v3.6.9"
    * Link the PR to our planning issue, for example: https://github.com/etcd-io/etcd/issues/21439
    * In release note, fill: "Update etcd images to v3.6.9"

## 3. Bump etcd SDK

You can refer to the guide [here](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/vendor.md) under the **Adding or updating a dependency** section.

1. Get all the etcd modules used in Kubernetes.

    ```bash
    $ grep 'go.etcd.io/etcd/' go.mod | awk '{print $1}'
    go.etcd.io/etcd/api/v3
    go.etcd.io/etcd/client/pkg/v3
    go.etcd.io/etcd/client/v3
    go.etcd.io/etcd/client/v2
    go.etcd.io/etcd/pkg/v3
    go.etcd.io/etcd/raft/v3
    go.etcd.io/etcd/server/v3
    ```

2. For each module, in the root directory of the `kubernetes/kubernetes` repository, fetch the new version in `go.mod` using the following command (using `client/v3` as an example):

    ```bash
    hack/pin-dependency.sh go.etcd.io/etcd/client/v3 NEW_VERSION
    ```

3. Rebuild the `vendor` directory and update the `go.mod` files for all staging repositories using the command below. This automatically updates the licenses.

    ```bash
    hack/update-vendor.sh
    ```

4. Check if the new dependency requires newer versions of existing dependencies we have pinned. You can check this by:

    * Running `hack/lint-dependencies.sh` against your branch and against `master` and comparing the results.
    * Checking if any new `replace` directives were added to `go.mod` files of components inside the staging directory.

## Bump etcd image

### Build etcd image

> Reference: [link 1](https://github.com/kubernetes/kubernetes/pull/131105) [link 2](https://github.com/kubernetes/kubernetes/pull/131126)

1. In `build/dependencies.yaml`, update the `version` of `etcd-image` to the new version. Update `golang: etcd release version` if necessary.

    ```yaml
    - name: "etcd-image"
      # version: 3.5.17
      version: 3.5.21
      refPaths:
      - path: cluster/images/etcd/Makefile
        match: BUNDLED_ETCD_VERSIONS\?|
    ---
    - name: "golang: etcd release version"
      # version: 1.22.9
      version: 1.23.7 # https://github.com/etcd-io/etcd/blob/main/CHANGELOG/CHANGELOG-3.6.md
    ```

2. In `cluster/images/etcd/Makefile`, include the new version in `BUNDLED_ETCD_VERSIONS` and update the `LATEST_ETCD_VERSION` as well (the image tag will be generated from the `LATEST_ETCD_VERSION`). Update `GOLANG_VERSION` according to the version used to compile that release version (`"golang: etcd release version"` in step 1).

    ```Makefile
    # BUNDLED_ETCD_VERSIONS?=3.4.18 3.5.17
    BUNDLED_ETCD_VERSIONS?=3.4.18 3.5.21

    # LATEST_ETCD_VERSION?=3.5.17
    LATEST_ETCD_VERSION?=3.5.21

    # GOLANG_VERSION := 1.22.9
    GOLANG_VERSION := 1.23.7
    ```

3. In `cluster/images/etcd/migrate/options.go`, include the new version in the `supportedEtcdVersions` slice.

    ```go
    var (
    // supportedEtcdVersions = []string{"3.4.18", "3.5.17"}
    supportedEtcdVersions = []string{"3.4.18", "3.5.21"}
    )
    ```

### Publish etcd image

> Reference: [link](https://github.com/kubernetes/k8s.io/pull/7957)

1. When the previous step is merged, a post-commit job will run to build the image. You can find the newly built image in the [registry](https://gcr.io/k8s-staging-etcd/etcd).

2. Locate the newly built image and copy its SHA256 digest.

3. Inside the `kubernetes/k8s.io` repository, in `registry.k8s.io/images/k8s-staging-etcd/images.yaml`, create a new entry for the desired version and copy the SHA256 digest.

    ```yaml
    "sha256:b4a9e4a7e1cf08844c7c4db6a19cab380fbf0aad702b8c01e578e9543671b9f9": ["3.5.17-0"]
    # ADD:
    "sha256:d58c035df557080a27387d687092e3fc2b64c6d0e3162dc51453a115f847d121": ["3.5.21-0"]
    ```

### Update to use the new etcd image

> Reference: [link](https://github.com/kubernetes/kubernetes/pull/131144)

1. In `build/dependencies.yaml`, change the `version` of `etcd` to the new version.

    ```yaml
    # etcd
    - name: "etcd"
    # version: 3.5.17
    version: 3.5.21
    refPaths:
    - path: cluster/gce/manifests/etcd.manifest
    match: etcd_docker_tag|etcd_version
    ```

2. In `cluster/gce/manifests/etcd.manifest`, change the image tag to the new image tag and `TARGET_VERSION` to the new version.

    ```manifest
    // "image": "{{ pillar.get('etcd_docker_repository', 'registry.k8s.io/etcd') }}:{{ pillar.get('etcd_docker_tag', '3.5.17-0') }}",

    "image": "{{ pillar.get('etcd_docker_repository', 'registry.k8s.io/etcd') }}:{{ pillar.get('etcd_docker_tag', '3.5.21-0') }}",

    ---

    { "name": "TARGET_VERSION",
    // "value": "{{ pillar.get('etcd_version', '3.5.17') }}"
    "value": "{{ pillar.get('etcd_version', '3.5.21') }}"
    },
    ```

3. In `cluster/gce/upgrade-aliases.sh`, update the exports for `ETCD_IMAGE` to the new image tag and `ETCD_VERSION` to the new version.

    ```sh
    # export ETCD_IMAGE=3.5.17-0
    export ETCD_IMAGE=3.5.21-0
    # export ETCD_VERSION=3.5.17
    export ETCD_VERSION=3.5.21
    ```

4. In `cmd/kubeadm/app/constants/constants.go`, change the `DefaultEtcdVersion` to the new version. In the same file, update `SupportedEtcdVersion` accordingly.

    ```go
    // DefaultEtcdVersion = "3.5.17-0"
    DefaultEtcdVersion = "3.5.21-0"

    ---

    SupportedEtcdVersion = map[uint8]string{
    // 30: "3.5.17-0",
    // 31: "3.5.17-0",
    // 32: "3.5.17-0",
    // 33: "3.5.17-0",
    30: "3.5.21-0",
    31: "3.5.21-0",
    32: "3.5.21-0",
    33: "3.5.21-0",
    }
    ```

5. In `hack/lib/etcd.sh`, update the `ETCD_VERSION`.

    ```sh
    # ETCD_VERSION=${ETCD_VERSION:-3.5.17}
    ETCD_VERSION=${ETCD_VERSION:-3.5.21}
    ```

6. In `staging/src/k8s.io/sample-apiserver/artifacts/example/deployment.yaml`, update the etcd image used.

    ```yaml
    - name: etcd
    # image: gcr.io/etcd-development/etcd:v3.5.17
    image: gcr.io/etcd-development/etcd:v3.5.21
    ```

7. In `test/utils/image/manifest.go`, update the etcd image tag.

    ```go
    // configs[Etcd] = Config{list.GcEtcdRegistry, "etcd", "3.5.17-0"}
    configs[Etcd] = Config{list.GcEtcdRegistry, "etcd", "3.5.21-0"}
    ```
