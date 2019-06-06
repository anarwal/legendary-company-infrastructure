#!/bin/bash

chmod 400 $PATH_TO_PEM
ssh-add $PATH_TO_PEM

# ssh using the bastion's EIP and the NFS IP
