module go.etcd.io/etcd/pkg/v3

go 1.24.0

toolchain go1.24.1

require (
	github.com/creack/pty v1.1.24
	github.com/dustin/go-humanize v1.0.1
	github.com/spf13/cobra v1.10.1
	github.com/spf13/pflag v1.0.9
	github.com/stretchr/testify v1.11.1
	go.etcd.io/etcd/client/pkg/v3 v3.6.0-alpha.0
	go.uber.org/zap v1.27.1
	google.golang.org/grpc v1.77.0
)

require (
	github.com/coreos/go-systemd/v22 v22.6.0 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/google/go-cmp v0.7.0 // indirect
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	go.opentelemetry.io/otel v1.38.0 // indirect
	go.opentelemetry.io/otel/sdk v1.38.0 // indirect
	go.uber.org/multierr v1.11.0 // indirect
	golang.org/x/net v0.46.1-0.20251013234738-63d1a5100f82 // indirect
	golang.org/x/sys v0.37.0 // indirect
	golang.org/x/text v0.30.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20251022142026-3a174f9686a8 // indirect
	google.golang.org/protobuf v1.36.10 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace go.etcd.io/etcd/client/pkg/v3 => ../client/pkg

// Bad imports are sometimes causing attempts to pull that code.
// This makes the error more explicit.
// Etcd contains lots of packages and dependency relationship.
// Shouldn't import unnecessary dependencies
replace (
	go.etcd.io/etcd => ./FORBIDDEN_DEPENDENCY
	go.etcd.io/etcd/api/v3 => ./FORBIDDEN_DEPENDENCY
	go.etcd.io/etcd/tests/v3 => ./FORBIDDEN_DEPENDENCY
	go.etcd.io/etcd/v3 => ./FORBIDDEN_DEPENDENCY
)
