# 第一阶段：构建 Go 应用
FROM crpi-y9m5jncpi0z3p6nq.cn-hangzhou.personal.cr.aliyuncs.com/fujg-k8s-test/go_120:1.20 AS builder

WORKDIR /app

# 复制 go.mod 和 go.sum 并下载依赖
COPY go.mod go.sum ./
RUN go mod download

# 复制项目代码
COPY . .

# 编译 Go 应用（静态编译）
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# 第二阶段：创建最小化的运行环境
FROM crpi-y9m5jncpi0z3p6nq.cn-hangzhou.personal.cr.aliyuncs.com/fujg-k8s-test/alpine_new:latest

WORKDIR /root/

# 复制编译好的二进制文件
COPY --from=builder /app/main .

# 运行服务
CMD ["./main"]
