[
    {
        "cpu": ${fargate_cpu},
        "environment": [{
            "name": "LOG4J_FORMAT_MSG_NO_LOOKUPS",
            "value": "true"
        }],
        "essential": true,
        "healthCheck": {
            "command": [ "CMD-SHELL", "curl -f http://localhost:4444/status || exit 1" ],
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
                "containerPort": 4442,
                "hostPort": 4442,
                "protocol": "tcp"
            },{
                "containerPort": 4443,
                "hostPort": 4443,
                "protocol": "tcp"
            },{
                "containerPort": 4444,
                "hostPort": 4444,
                "protocol": "tcp"
            }
        ],
        "volumesFrom": []
    }
]
