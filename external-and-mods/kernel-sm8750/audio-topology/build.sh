#!/usr/bin/env bash
# Rebuild ../firmware/qcom/sm8750/SM8750-AYN-tplg.bin from SM8750-AYN.m4.
# Needs m4 and alsatplg (alsa-utils).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AR_REF="${AR_REF:-b4c1510}"
WORK="${WORK:-${HERE}/work}"
AR_DIR="${AR_DIR:-${WORK}/audioreach-topology}"
OUT="${HERE}/../firmware/qcom/sm8750/SM8750-AYN-tplg.bin"

if [[ ! -d "$AR_DIR/.git" ]]; then
  mkdir -p "$WORK"
  git clone -q https://github.com/linux-msm/audioreach-topology.git "$AR_DIR"
fi
git -C "$AR_DIR" checkout -q "$AR_REF"

m4 -I "$AR_DIR" "${HERE}/SM8750-AYN.m4" >"${WORK}/SM8750-AYN.conf"
# alsatplg warns about the backend stream names (they come from the kernel).
alsatplg -c "${WORK}/SM8750-AYN.conf" -o "$OUT"
ls -l "$OUT"
