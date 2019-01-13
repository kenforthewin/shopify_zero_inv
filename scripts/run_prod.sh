#!/bin/bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
docker network connect nginx_network shopifyzeroinv_app_1