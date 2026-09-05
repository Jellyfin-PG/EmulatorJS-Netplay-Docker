FROM rust:1-bookworm AS builder

WORKDIR /build

COPY EmulatorJS-Netplay/Cargo.toml EmulatorJS-Netplay/Cargo.lock ./
COPY EmulatorJS-Netplay/src ./src

RUN cargo build --release


FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /build/target/release/rust-socket-server /app/netplay-server

EXPOSE 4000

CMD ["/app/netplay-server"]