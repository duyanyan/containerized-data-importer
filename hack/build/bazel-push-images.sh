#!/bin/bash
#
# This file is part of the KubeVirt project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright 2019 Red Hat, Inc.
#

set -e

source hack/build/common.sh
source hack/build/config.sh

docker_tag=$DOCKER_TAG
docker_prefix=$DOCKER_PREFIX
if [ -n "$DOCKER_CA_CERT_FILE" ] ; then
    /usr/bin/update-ca-trust
fi 

echo "docker_prefix: $docker_prefix"
for tag in ${docker_tag} ${docker_tag_alt}; do
    bazel run \
        --verbose_failures \
        --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 \
        --define container_prefix=${docker_prefix} \
        --define container_tag=${tag} \
        --host_force_python=PY3 \
        //:push-images | tee $push_log_file
done
