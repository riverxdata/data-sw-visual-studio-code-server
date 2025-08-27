PORT=$(python3 -c "import socket; s=socket.socket(); s.bind(('', 0)); print(s.getsockname()[1]); s.close()")
echo $PORT > $RIVER_HOME/jobs/$job_id/job.port
echo $(hostname) > $RIVER_HOME/jobs/$job_id/job.host
echo "$job_id" > $RIVER_HOME/jobs/$job_id/job.url
TARGET_DIR="$RIVER_HOME/tools/openvscode-server-linux-x64"
mkdir -p "$TARGET_DIR"
ARCHIVE_URL=$(curl -s https://api.github.com/repos/gitpod-io/openvscode-server/releases/latest \
  | grep "browser_download_url.*linux-x64.tar.gz" \
  | cut -d '"' -f 4)

mkdir -p "$RIVER_HOME/tools"
# Download & extract only if not already installed
if [ ! -f "$TARGET_DIR/bin/openvscode-server" ]; then 
    wget -qO "/tmp/openvscode.tar.gz" "$ARCHIVE_URL"
    tar -xzvf "/tmp/openvscode.tar.gz" -C "$TARGET_DIR" --strip-components=1
    rm "/tmp/openvscode.tar.gz"
else
    echo "OpenVSCode Server already installed at $TARGET_DIR"
fi
export PATH=$TARGET_DIR/bin:$PATH
openvscode-server --host 0.0.0.0 --port $PORT --server-base-path $job_id --without-connection-token