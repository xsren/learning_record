gRPC + Python 入门
# 一、先了解几个概念

### RPC
RPC（Remote Procedure Call）—远程过程调用，它是一种通过网络从远程计算机程序上请求服务，而不需要了解底层网络技术的协议。

### gRPC
gRPC是一个高性能、通用的开源RPC框架，其由Google主要由开发并基于HTTP/2协议标准而设计，基于ProtoBuf(Protocol Buffers)序列化协议开发，且支持众多开发语言。

* 基于HTTP/2协议提供了更好的强的应用性能（节省带宽，减少TCP请求连接数）
* 基于ProtoBuf定义服务，面向接口对服务进行顶层设计
* 支持主流的编程语言，C++,Java,Python,Go,Ruby,Node.js，PHP等, 基于ProtoBuf生成相应的服务端和客户端代码。
* 相比在使用Restful方式完成服务之间的相互访问，GRPC能提供更好的性能，更低的延迟，并且生来适合与分布式系统。
* 同时基于标准化的IDL（ProtoBuf）来生成服务器端和客户端代码, ProtoBuf服务定义可以作为服务契约，因此可以更好的支持团队与团队之间的接口设计，开发，测试，协作等等。


### protobuf

protocol buffers(简称protobuf)是google 的一种数据交换的格式，它独立于语言，独立于平台。

* protobuf是google开发的一个数据传输格式，类似json
* protobuf是二进制的、结构化的，所以比json的数据量更小，也更对象化
* protobuf不是像json直接明文的，这个是定义对象结构，然后由protbuf库去把对象自动转换成二进制，用的时候再自动反解过来的。传输对我们是透明的！我们只管传输的对象就可以了



# 二、再学习protobuf

## 1、安装protobuf

### 1）安装 Protocol Compiler
参考：
[Protocol Compiler Installation https://github.com/google/protobuf](https://github.com/google/protobuf)

有两种方式，一种是自己编译，一种是下载然后把*protoc*放在*/usr/bin*即可。我选的后者，本地命令如下：

```
# 下载
在 https://github.com/google/protobuf/releases 下载 protoc-3.5.1-osx-x86_64.zip
# 解压
unzip protoc-3.5.1-osx-x86_64.zip -d protoc
# 拷贝
sudo cp protoc/bin/protoc /usr/bin/
# 增加可执行的权限
sudo chmod +x /usr/bin/protoc
# 拷贝 include文件p
cp -rf include/google /usr/local/include 
```

### 2）安装 python package

```
sudo pip3 install protobuf
```

## 2、运行protobuf demo
参考：

* [Protocol Buffer Basics: Python https://developers.google.com/protocol-buffers/docs/pythontutorial](https://developers.google.com/protocol-buffers/docs/pythontutorial)
* [proto3和proto2的区别 https://superlc320.gitbooks.io/protocol-buffers-3-study-notes/content/proto3he_proto2_de_qu_bie.html](https://superlc320.gitbooks.io/protocol-buffers-3-study-notes/content/proto3he_proto2_de_qu_bie.html)

官方的demo实现了一个简易通讯录，可以将联系人写入文件，并可以从文件中读取联系人。

```
python版本3.6.0
protoc版本3.5.1
cd protobuf_demo
# 编译生成addressbook_pb2.py
protoc --python_out=. addressbook.proto
# 添加联系人
python3 add_person.py address.txt
# 读取联系人
python3 list_people.py address.txt
```

![运行结果](https://upload-images.jianshu.io/upload_images/3781366-17dd38c3a14ab38a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# 三、gRPC学习

## 1、安装
参考：
[https://grpc.io/docs/quickstart/python.html](https://grpc.io/docs/quickstart/python.html)

```
# Install gRPC
sudo pip3 install grpcio
# Install gRPC tools 
sudo pip3 install grpcio-tools
```
## 2、运行

### 1) hello world

```
cd grpc_helloworld
# 生成 helloworld_pb2.py 和 helloworld_pb2_grpc.py
python3 -m grpc_tools.protoc --proto_path=.  --python_out=. --grpc_python_out=. helloworld.proto
# 运行server
python3 greeter_server.py
# 运行client
python3 greeter_client.py
```

### 2) route guide

一个和streaming相关的demo，支持：
* A server-to-client streaming RPC.
* A client-to-server streaming RPC.
* A Bidirectional streaming RPC.

streaming 的应用场景主要是传输数据量比较多的情况。

```
cd grpc_helloworld
# 生成 route_guide_pb2.py 和 route_guide_pb2_grpc.py
python3 -m grpc_tools.protoc --proto_path=.  --python_out=. --grpc_python_out=. route_guide.proto
# 运行server
python3 route_guide_server.py
# 运行client
python3 route_guide_client.py
```


# 四、生产环境

参考：

* [python API doc https://grpc.io/grpc/python/index.html](https://grpc.io/grpc/python/index.html)
* [Exploring Security, Metrics, and Error-handling with gRPC in Python https://blog.codeship.com/exploring-security-metrics-and-error-handling-with-grpc-in-python/](https://blog.codeship.com/exploring-security-metrics-and-error-handling-with-grpc-in-python/)
* [gRPC Authentication https://grpc.io/docs/guides/auth.html#credential-types](https://grpc.io/docs/guides/auth.html#credential-types)

生产环境的要求：

* 性能
    * 使用多线程提高并发。
    * 使用负载均衡的方式进行扩展。
* 安全
	*  SSL/TLS
	*  Token-based authentication with Google
	*  扩展使用其他认证方式
* 错误处理
	* 超时
	* 错误
* 拦截器（python版本的拦截器还不稳定） 


```
cd grpc_product
# 生产私钥
openssl genrsa -out server.key 2048
# 生产公钥
openssl req -new -x509 -sha256 -key server.key -out server.crt -days 3650
# 生成 helloworld_pb2.py 和 helloworld_pb2_grpc.py
python3 -m grpc_tools.protoc --proto_path=.  --python_out=. --grpc_python_out=. helloworld.proto
# 运行server
python3 greeter_server.py
# 运行client
python3 greeter_client.py

```
# 五、让gRPC支持Restful

参考：
* [gRPC with REST and Open APIs https://grpc.io/blog/coreos](https://grpc.io/blog/coreos)

* [grpc-gateway https://github.com/grpc-ecosystem/grpc-gateway](https://github.com/grpc-ecosystem/grpc-gateway)

可以使用使用grpc-gateway生成一个反向代理，将接收的RESTful JSON API 转化为 gRPC。

![grpc_gateway.png](https://upload-images.jianshu.io/upload_images/3781366-fb1f6b28eb5b8f44.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


```
# 生成的python文件用到了google.api，搞了半天，我发现居然是包含在google-cloud-translate里面的
sudo pip3 install google-cloud-translate

# 安装go依赖的包
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
go get -u github.com/golang/protobuf/protoc-gen-go

# 修改proto文件

# 生成 gRPC golang stub 类
sh gen_grpc_stub_go.sh
# 需要注释掉helloworld.pb.go第19行： import _ "github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis/google/api"
# 生成 gRPC python stub 类
sh gen_grpc_stub_python.sh
# 生成网关代码
sh gen_grpc_gw.sh
# 生成swagger代码
sh gen_grpc_gw_swagger.sh

# 运行 server
python3 server.py
# 运行 client
python3 client.py
# 运行网关服务
go run proxy.go

# 命令行测试
curl -X POST -k http://localhost:8080/v1/hello -d '{"name": "world"}'
# 打开swagger测试
http://localhost:8080/swagger-ui/
```


# 六、TODO：

* 1、能否使用多进程或者异步的方式提高server的并发？
* 2、深入研究grpc-gateway的高级选项。