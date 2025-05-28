use warp::{Filter, Rejection, Reply};

type Result<T> = std::result::Result<T, Rejection>;

#[tokio::main]
async fn main() {
    let health_route = warp::path!("health").and_then(health_handler);

    let routes = health_route.with(warp::cors().allow_any_origin());

    println!("Server listening on :8000");
    let (_addr, fut) = warp::serve(routes).bind_with_graceful_shutdown(([0, 0, 0, 0], 8000), async move {
            tokio::signal::ctrl_c()
                .await
                .expect("Failed to wait for CTRL+C");
        });
    fut.await;
    println!("Server stopping...");
}

async fn health_handler() -> Result<impl Reply> {
    Ok("OK")
}