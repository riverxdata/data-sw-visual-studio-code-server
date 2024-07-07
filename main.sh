PASSWORD=$(openssl rand -base64 20)
PASSWORD=$PASSWORD code-server --bind-addr 0.0.0.0:$PORT --auth password --disable-telemetry
