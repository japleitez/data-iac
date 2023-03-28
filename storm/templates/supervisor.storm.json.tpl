[
  {
    "command": ["storm", "supervisor", "-c", "worker.childopts=\"-Xmx%HEAP-MEM%m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=artifacts/heapdump\"", "-c", "${hostname}", "-c", "storm.zookeeper.servers=[\"${zookeeper}\"]", "-c", "nimbus.seeds=[\"${nimbus1}\", \"${nimbus2}\"]"],
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
          "containerPort": ${supervisor_port},
          "hostPort": ${supervisor_port}
        }, {
            "containerPort": ${worker_port_1},
            "hostPort": ${worker_port_1}
        }, {
            "containerPort": ${worker_port_2},
            "hostPort": ${worker_port_2}
        }, {
            "containerPort": ${worker_port_3},
            "hostPort": ${worker_port_3}
        }, {
            "containerPort": ${worker_port_4},
            "hostPort": ${worker_port_4}
        }
    ],
    "volumesFrom": []
  }
]
