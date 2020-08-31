#!/bin/sh

set -eu

echo "Shutdown docker services";
docker-compose down;

echo "Clear all downloaded images"
docker rmi $(docker images -a -q) -f;
docker volume rm $(docker volume ls -q) -f;

echo "Remove OpenVPN server lists";
rm -rf /volume2/docker/media-server/.config/vpn/*
