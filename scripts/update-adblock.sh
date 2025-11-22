#!/bin/bash

# 下载来源
URL="https://raw.githubusercontent.com/Aethersailor/adblockfilters-modified/refs/heads/main/rules/adblockdnsmasq.txt"
LOG_FILE="./adblockfilters-modified-curl.log"
OUTPUT_DIR="./rule_provider"
TEMP_FILE="$OUTPUT_DIR/adblock.yaml"

mkdir -p "$OUTPUT_DIR"

echo "清除旧的 adblock.yaml…"
rm -f "$TEMP_FILE"

echo "拉取最新的 adblockfilters-modified 规则…"
curl -fSL "$URL" -o "$TEMP_FILE" 2> "$LOG_FILE"

if [ $? -ne 0 ]; then
    echo "下载失败，请检查日志: $LOG_FILE"
    exit 1
else
    echo "文件下载成功: $TEMP_FILE"

    sed 's,/,,g; s/local=/  - DOMAIN-SUFFIX,/g' "$TEMP_FILE" > "$TEMP_FILE.tmp"
    echo "payload:" | cat - "$TEMP_FILE.tmp" > "$TEMP_FILE"
    rm "$TEMP_FILE.tmp"

    echo "生成完成: $TEMP_FILE"
    exit 0
fi
