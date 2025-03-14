FROM alpine:3.14.2

RUN apk add go linux-headers alpine-sdk cmake tcl openssl-dev zlib-dev supervisor

# Install SRT
WORKDIR /srt
RUN git clone https://github.com/Haivision/srt.git .
RUN git checkout v1.4.3
RUN ./configure && make && make install

RUN mkdir /app
WORKDIR /app

COPY go.mod /app
COPY go.sum /app

RUN go mod download

ADD . /app

RUN go build .

ENTRYPOINT [ "/app/srt-advanced-server" ]