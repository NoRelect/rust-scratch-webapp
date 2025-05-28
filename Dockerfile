FROM rust@sha256:25038aa450210c53cf05dbf7b256e1df1ee650a58bb46cbc7d6fa79c1d98d083 AS builder
WORKDIR /app/
RUN rustup target add x86_64-unknown-linux-musl

COPY app /app
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/app /app
USER 1000
CMD ["/app" ]
