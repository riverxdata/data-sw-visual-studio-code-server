echo $URL/<<uuid_job_id>> > job.url
openvscode-server --host 0.0.0.0 --port $PORT --server-base-path <<uuid_job_id>> --without-connection-token
