[
  {
    "cpu": ${zookeeper_cpu},
    "environment": [
      {
            "name": "LOG4J_FORMAT_MSG_NO_LOOKUPS",
            "value": "true"
      },
      {
        "name": "ZOO_STANDALONE_ENABLED",
        "value": "true"
      },
      {
        "name": "ZOO_CFG_EXTRA",
        "value": "electionPortBindRetry=999"
      },
      {
        "name": "ZOO_4LW_COMMANDS_WHITELIST",
        "value": "${zookeeper_4lw_commands_whitelist}"
      }
    ],
    "essential": true,
    "image": "${zookeeper_image}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${zookeeper_log_group}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "${zookeeper_stream_prefix}"
      }
    },
    "memory": ${zookeeper_memory},
    "mountPoints": [],
    "name": "zookeeper",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${zookeeper_port},
        "hostPort": ${zookeeper_port},
        "protocol": "tcp"
      },
        {
          "containerPort": ${zookeeper_port_communication},
          "hostPort": ${zookeeper_port_communication},
          "protocol": "tcp"
      },
        {
          "containerPort": ${zookeeper_port_election},
          "hostPort": ${zookeeper_port_election},
          "protocol": "tcp"
      }
    ],
    "volumesFrom": []
  }
]
