#!/bin/bash

DEFAULT_USER=ubuntu

usage() { echo Usage: " $0  -b <bastion_key> [-u <bastion_user>] -l <bastion_address> -r <remote_key> [-a <remote_user>] -z <remote_address>" 1>&2; exit 1; }

while getopts ":b:u:l:r:a:z:" o; do
    case "${o}" in
        b)
            BASTION_PEM_KEY=${OPTARG}
            ;;
        u)
            BASTION_USER=${OPTARG}
            ;;
        l)
            BASTION_ADDRESS=${OPTARG}
            ;;
        r)
            REMOTE_PEM_KEY=${OPTARG}
            ;;
        a)
            REMOTE_USER=${OPTARG}
            ;;
        z)
            REMOTE_ADDRESS=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${BASTION_PEM_KEY}" ] || [ -z "${BASTION_ADDRESS}" ] || [ -z "${REMOTE_PEM_KEY}" ] || [ -z "${REMOTE_ADDRESS}" ]; then
    usage
fi

if [ -z "${BASTION_USER}" ]; then
    BASTION_USER=$DEFAULT_USER
fi

if [ -z "${REMOTE_USER}" ]; then
    REMOTE_USER=$DEFAULT_USER
fi

ssh -i ${REMOTE_PEM_KEY} -o ProxyCommand="ssh -i ${BASTION_PEM_KEY} -l ${BASTION_USER} ${BASTION_ADDRESS} nc %h %p" ${REMOTE_USER}@${REMOTE_ADDRESS}
