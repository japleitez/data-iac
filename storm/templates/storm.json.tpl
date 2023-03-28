[
  {
    "command": ${command},
    "cpu": ${storm_cpu},
    "environment": [{
          "name": "LOG4J_FORMAT_MSG_NO_LOOKUPS",
          "value": "true"
    }],
    "essential": true,
    "image": "${storm_image}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${storm_log_group}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "${storm_stream_prefix}"
      }
    },
    "memory": ${storm_memory},
    "mountPoints": [],
    "name": "storm",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${nimbus_port},
        "hostPort": ${nimbus_port}
      },
        {
          "containerPort": ${supervisor_port},
          "hostPort": ${supervisor_port}
      },
        {
          "containerPort": ${ui_port},
          "hostPort": ${ui_port}
      },
        {
          "containerPort": ${worker_port_1},
        "hostPort": ${worker_port_1}
      },
        {
          "containerPort": ${worker_port_2},
          "hostPort": ${worker_port_2}
      },
        {
          "containerPort": ${worker_port_3},
          "hostPort": ${worker_port_3}
      },
        {
          "containerPort": ${worker_port_4},
          "hostPort": ${worker_port_4}
      }
    ],
    "volumesFrom": []
  }
]
