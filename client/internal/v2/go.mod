module go.etcd.io/etcd/client/v2

go 1.23

toolchain go1.23.3

require (
	github.com/stretchr/testify v1.9.0
	go.etcd.io/etcd/api/v3 v3.6.0-alpha.0
	go.etcd.io/etcd/client/pkg/v3 v3.6.0-alpha.0
	sigs.k8s.io/json v0.0.0-20241014173422-cfa47c3a1cc8
)

require (
	github.com/coreos/go-semver v0.3.1 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace (
	go.etcd.io/etcd/api/v3 => ./../../../api
	go.etcd.io/etcd/client/pkg/v3 => ./../../pkg
)

// Bad imports are sometimes causing attempts to pull that code.
// This makes the error more explicit.
replace (
	go.etcd.io/etcd => ./FORBIDDEN_DEPENDENCY
	go.etcd.io/etcd/pkg/v3 => ./FORBIDDED_DEPENDENCY
	go.etcd.io/etcd/tests/v3 => ./FORBIDDEN_DEPENDENCY
	go.etcd.io/etcd/v3 => ./FORBIDDEN_DEPENDENCY
)
