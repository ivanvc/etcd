module go.etcd.io/etcd/pkg/v3

go 1.26.0

toolchain go1.26.4

require (
	github.com/creack/pty v1.1.18
	github.com/dustin/go-humanize v1.1.0
	github.com/spf13/cobra v1.10.2
	github.com/spf13/pflag v1.0.10
	github.com/stretchr/testify v1.12.1
	go.etcd.io/etcd/client/pkg/v3 v3.7.0-beta.0
	go.opentelemetry.io/otel/trace v1.43.0
	go.uber.org/zap v1.28.0
	golang.org/x/sys v0.47.0
	google.golang.org/grpc v1.81.0
	google.golang.org/protobuf v1.36.11
)

require (
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/coreos/go-systemd/v22 v22.7.0 // indirect
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	go.opentelemetry.io/otel v1.43.0 // indirect
	go.uber.org/multierr v1.11.0 // indirect
	go.yaml.in/yaml/v3 v3.0.5 // indirect
	golang.org/x/net v0.54.0 // indirect
	golang.org/x/text v0.37.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20260414002931-afd174a4e478 // indirect
)

replace go.etcd.io/etcd/client/pkg/v3 => ../client/pkg
