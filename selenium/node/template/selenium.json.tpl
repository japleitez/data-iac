[
    {
        "command": ["PRIVATE=$(curl -s $${ECS_CONTAINER_METADATA_URI_V4} | jq -r '.Networks[0].IPv4Addresses[0]') ; export REMOTE_HOST=\"http://$PRIVATE:5555\"; export SE_OPTS=\"--host $PRIVATE --port 5555\" ; /opt/bin/entry_point.sh"],
        "cpu": ${fargate_cpu},
        "entryPoint": ["sh", "-c"],
        "environment": [
            {
                "name": "LOG4J_FORMAT_MSG_NO_LOOKUPS",
                "value": "true"
            },{
                "name": "SE_EVENT_BUS_HOST",
                "value": "${se_event_bus_host}"
            },{
                "name": "SE_EVENT_BUS_PUBLISH_PORT",
                "value": "4442"
            },{
                "name": "SE_EVENT_BUS_SUBSCRIBE_PORT",
                "value": "4443"
            },{
                "name": "SE_NODE_SESSION_TIMEOUT",
                "value": "300"
            }
        ],
        "essential": true,
        "healthCheck": {
            "command": [ "CMD-SHELL", "curl -f http://localhost:5555/status || exit 1" ],
            "interval": 30,
            "retries": 3,
            "timeout": 5
        },
        "image": "${app_image}",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "${stream_prefix}"
            }
        },
        "memory": ${fargate_memory},
        "mountPoints": [],
        "name": "${name}",
        "networkMode": "awsvpc",
        "portMappings": [
            {
                "containerPort": ${app_port},
                "hostPort": ${app_port},
                "protocol": "tcp"
            }
        ],
        "volumesFrom": []
    }
]
