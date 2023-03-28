[
  {
    "command": ["storm", "nimbus", "-c", "${hostname}", "-c", "storm.zookeeper.servers=[\"${zookeeper}\"]"],
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
      }
    ],
    "volumesFrom": []
  }
]
