# Copyright (C) 2021 Jingyi Xie (hsfzxjy) <hsfzxjy@gmail.com>
# All rights reserved.

# Usage: unused_port [NUM_OF_PORTS=1]
function unused_port() {
    N=${1:-1}
    comm -23 \
        <(seq "1025" "65535" | sort) \
        <(ss -Htan |
            awk '{print $4}' |
            cut -d':' -f2 |
            sort -u) |
        shuf |
        head -n "$N"
}
