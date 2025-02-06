while IFS== read key value; do
    printf -v "$key" "$value"
done < <(jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' config.json)

PORT=$(python3 -c "import socket; s=socket.socket(); s.bind(('', 0)); print(s.getsockname()[1]); s.close()")
echo $PORT > $RIVER_HOME/.river/jobs/$uuid_job_id/job.port
echo $(hostname) > $RIVER_HOME/.river/jobs/$uuid_job_id/job.host
echo "$uuid_job_id" > $RIVER_HOME/.river/jobs/$uuid_job_id/job.url

openvscode-server --host 0.0.0.0 --port $PORT --server-base-path $uuid_job_id --without-connection-token
