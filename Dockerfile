FROM rust@sha256:25038aa450210c53cf05dbf7b256e1df1ee650a58bb46cbc7d6fa79c1d98d083 AS builder
RUN rustup target add x86_64-unknown-linux-musl
WORKDIR /app
COPY app /app
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/app/target \
    cargo build --release --target x86_64-unknown-linux-musl && \
    cp /app/target/x86_64-unknown-linux-musl/release/app /app/app

FROM scratch
COPY --from=builder /app/app /app
USER 1000
ENTRYPOINT [ "/app" ]
