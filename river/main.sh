while IFS== read key value; do
    printf -v "$key" "$value"
done < <(jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' config.json)

PORT=$(python3 -c "import socket; s=socket.socket(); s.bind(('', 0)); print(s.getsockname()[1]); s.close()")
echo $PORT > $RIVER_HOME/.river/jobs/$uuid_job_id/job.port
echo $(hostname) > $RIVER_HOME/.river/jobs/$uuid_job_id/job.host
echo "$uuid_job_id" > $RIVER_HOME/.river/jobs/$uuid_job_id/job.url

version=1.96.4
TARGET_DIR="$RIVER_HOME/.river/tools/openvscode-server-v${version}-linux-x64"
ARCHIVE_URL=https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v${version}/openvscode-server-v${version}-linux-x64.tar.gz
mkdir -p "$RIVER_HOME/.river/tools"
# Download & extract only if not already installed
if [ ! -d "$TARGET_DIR" ]; then 
    wget -qO "/tmp/openvscode.tar.gz" "$ARCHIVE_URL"
    tar -xzvf "/tmp/openvscode.tar.gz" -C "$RIVER_HOME/.river/tools/"
    rm "/tmp/openvscode.tar.gz"
else
    echo "OpenVSCode Server already installed at $TARGET_DIR"
fi
export PATH=$TARGET_DIR/bin:$PATH
openvscode-server --host 0.0.0.0 --port $PORT --server-base-path $uuid_job_id --without-connection-token