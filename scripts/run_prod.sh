#!/bin/bash
docker-compose -f docker-compose.prod.yml -f docker-compose.yml up --build -d
docker network connect nginx_network shopifyzeroinv_app_1