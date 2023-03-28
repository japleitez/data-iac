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
                "name": "_JAVA_OPTIONS",
                "value": "-Xmx512m -Xms256m"
            },
            {
                "name": "SPRING_PROFILES_ACTIVE",
                "value": "prod,api-docs"
            },
            {
                "name": "SERVER_SERVLET_CONTEXT_PATH",
                "value": "/playground"
            },
            {
                "name": "MANAGEMENT_METRICS_EXPORT_PROMETHEUS_ENABLED",
                "value": "true"
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
            },
            {
                "name": "APPLICATION_SELENIUM_ADDRESS",
                "value": "${selenium_address}:4444"
            }
        ]
    }
]
