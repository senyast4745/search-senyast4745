FROM golang:1.13 AS builder
WORKDIR /go/src/github.com/polisgo2020/senyast4745/

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN GOOS=linux CGO_ENABLED=0 go build -installsuffix cgo -o app main.go

FROM alpine:3.11
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /go/src/github.com/polisgo2020/senyast4745/app .
ENTRYPOINT ["/app/app"]