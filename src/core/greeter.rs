pub fn greet(name: &str) -> anyhow::Result<String> {
    Ok(format!("Hello, {}!", name))
}
