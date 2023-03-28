[
    {
        "name": "${name}",
        "image": "${app_image}",
        "cpu": ${fargate_cpu},
        "memory": ${fargate_memory},
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
                "hostPort": ${app_port}
            }
        ],
        "environment": [
            {
                "name": "LOG4J_FORMAT_MSG_NO_LOOKUPS",
                "value": "true"
            },
            {
                "name": "_JAVA_OPTIONS",
                "value": "-Xmx512m -Xms256m"
            },
            {
                "name": "SPRING_PROFILES_ACTIVE",
                "value": "prod,api-docs"
            },
            {
                "name": "SERVER_SERVLET_CONTEXT_PATH",
                "value": "/das"
            },
            {
                "name": "MANAGEMENT_METRICS_EXPORT_PROMETHEUS_ENABLED",
                "value": "true"
            },
            {
                "name": "SPRING_DATASOURCE_URL",
                "value": "jdbc:postgresql://${db_address}:5432/${db_name}"
            },
            {
                "name": "SPRING_LIQUIBASE_URL",
                "value": "jdbc:postgresql://${db_address}:5432/${db_name}"
            },
            {
                "name": "SPRING_DATASOURCE_PASSWORD",
                "value": "${db_password}"
            },
            {
                "name": "SPRING_LIQUIBASE_CONTEXTS",
                "value": "${spring_liquibase_contexts}"
            },
            {
                "name": "SPRING_ELASTICSEARCH_URIS_0",
                "value": "https://${elasticsearch_endpoint}:443"
            },
            {
                "name": "APPLICATION_TOPOLOGY_PATH",
                "value": "/basic-topology.jar"
            },
            {
                "name": "APPLICATION_NIMBUS_SEEDS_0",
                "value": "${nimbus1}"
            },
            {
                "name": "APPLICATION_NIMBUS_SEEDS_1",
                "value": "${nimbus2}"
            },
            {
                "name": "APPLICATION_SELENIUM_ADDRESS",
                "value": "${selenium_address}:4444"
            },
            {
                "name": "APPLICATION_TOPOLOGY_REPORT_ADDRESS",
                "value": "http://${report_address}:8081/das/api/acquisitions/:id/report"
            },
            {
                "name": "APPLICATION_PLAYGROUND_SERVICE_ADDRESS",
                "value": "http://${playground_host}:${playground_port}/playground/"
            },
            {
                "name": "SPRING_SECURITY_OAUTH2_CLIENT_PROVIDER_OIDC_ISSUER_URI",
                "value": "https://cognito-idp.${aws_region}.amazonaws.com/${pool_id}"
            },
            {
                "name": "SPRING_SECURITY_OAUTH2_CLIENT_REGISTRATION_OIDC_CLIENT_ID",
                "value": "${client_id}"
            },
            {
                "name": "SPRING_SECURITY_OAUTH2_CLIENT_REGISTRATION_OIDC_CLIENT_SECRET",
                "value": "${client_secret}"
            },
            {
                "name": "APPLICATION_OAUTH2_GROUPS_0",
                "value": "WIHP"
            },
            {
                "name": "APPLICATION_OAUTH2_SCOPES_0",
                "value": "${scope}"
            }
        ]
    }
]
