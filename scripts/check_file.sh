#!/usr/bin/env bash
# Проверяет, что путь из первого аргумента существует и это обычный файл.
# Код возврата: 0 — файл есть, 1 — файла нет, 2 — неверный вызов.

set -euo pipefail

if [[ $# -ne 1 || -z $1 ]]; then
    echo "Usage: ${0##*/} <path>" >&2
    exit 2
fi

file=$1

if [[ -f $file ]]; then
    echo "File exists: $file"
else
    echo "File does not exist (or is not a regular file): $file" >&2
    exit 1
fi
