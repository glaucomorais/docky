#!/usr/bin/env bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                         #
#  Docky v1.2                                                             #
#                                                                         #
#  Script to facilitate the use of Docker based on Laravel Sail script.   #
#                                                                         #
#  Author: Glauco Morais (https://git.io/JB8cM)                           #
#  License: MIT                                                           #
#                                                                         #
#  Copyright (c) 2021 Glauco Morais                                       #
#                                                                         #
#  Permission is hereby granted, free of charge, to any person obtaining  #
#  a copy of this software and associated documentation files             #
#  (the "Software"), to deal in the Software without restriction,         #
#  including without limitation the rights to use, copy, modify, merge,   #
#  publish, distribute, sublicense, and/or sell copies of the Software,   #
#  and to permit persons to whom the Software is furnished to do so,      #
#  subject to the following conditions:                                   #
#                                                                         #
#  The above copyright notice and this permission notice shall be         #
#  included in all copies or substantial portions of the Software.        #
#                                                                         #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        #
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     #
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                  #
#  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS    #
#  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN        #
#  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN   #
#  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE       #
#  SOFTWARE.                                                              #
#                                                                         #
#  Changelog:                                                             #
#                                                                         #
#    - v1.2:                                                              #
#      + Add .docky.env support                                           #
#                                                                         #
#    - v1.1:                                                              #
#      + Changed node:lts-alpine to node:lts                              #
#                                                                         #
#    - v1.0:                                                              #
#      + Initial release                                                  #
#                                                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

WHITE='\033[1;37m'
NC='\033[0m'

if ! docker info > /dev/null 2>&1; then
    echo -e "${WHITE}Docker is not running.${NC}" >&2

    exit 1
fi

if [[ -f .docky.env ]]; then
    source .docky.env
    PHP_IMAGE="${PHP_IMAGE:-php:alpine}"
    NODE_IMAGE="${NODE_IMAGE:-node:lts}"
fi

function proxyDockerCommand {
    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "$(pwd):/opt" \
        -w /opt \
        "$@"
}

function proxyPhpCommands {
    proxyDockerCommand "$PHP_IMAGE" $@
}

function proxyNodeCommands {
    proxyDockerCommand -ti "$NODE_IMAGE" $@
}

if [ $# -gt 0 ]; then
    if [ "$1" == "composer" ]; then
        proxyDockerCommand composer:latest $@

    elif [ "$1" == "eslint" ]; then
        shift 1

        proxyNodeCommands npx eslint $@

    elif [ "$1" == "npm" ] || [ "$1" == "npx" ]; then
        proxyNodeCommands $@

    elif [ "$1" == "php" ]; then
        proxyPhpCommands $@

    elif [ "$1" == "phpcs" ]; then
        shift 1

        proxyPhpCommands \
            vendor/bin/phpcs \
            --report-full \
            --standard=phpcs.ruleset.xml \
            -d memory_limit=2000M \
            $@

    elif [ "$1" == "phpmd" ]; then
        SRCPATH=$2

        shift 2

        proxyPhpCommands \
            vendor/bin/phpmd \
            "$SRCPATH" \
            text \
            phpmd.ruleset.xml \
            $@

    else
        echo -e "${WHITE}Unknown or unsupported command.${NC}" >&2
    fi
fi
