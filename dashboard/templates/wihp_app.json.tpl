[
    {
        "cpu": ${fargate_cpu},
        "environment": [
           {
               "name": "LOG4J_FORMAT_MSG_NO_LOOKUPS",
               "value": "true"
           },
           {
               "name": "ENV",
               "value": "${environment}"
           }, {
               "name": "DOMAIN",
               "value": "${auth_domain}"
           }, {
               "name": "CLIENT_ID",
               "value": "${client_id}"
           }, {
               "name": "REGION",
               "value": "${aws_region}"
           }, {
               "name": "POOL_ID",
               "value": "${pool_id}"
           }
        ],
        "essential": true,
        "image": "${app_image}",
        "memory": ${fargate_memory},
        "mountPoints": [],
        "name": "${name}",
        "networkMode": "awsvpc",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "${stream_prefix}"
            }
        },
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
