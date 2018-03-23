#!/bin/bash

mkdir -p pb

python -m grpc.tools.protoc -I. -I/usr/local/include -I/Users/xsren/gopath/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis --python_out=. --grpc_python_out=. pb/helloworld.proto
