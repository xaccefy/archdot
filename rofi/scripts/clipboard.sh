#!/usr/bin/env bash
# Rofi script mode: clipboard history.
#
# Initial call (ROFI_RETV=0) lists the history. On selection (ROFI_RETV=1) the
# chosen row's cliphist id comes back in ROFI_INFO, and that entry is decoded
# back onto the clipboard. cliphist decode keys off the id prefix, so the id
# alone is enough to restore the original bytes.

if [[ "${ROFI_RETV:-0}" == "0" ]]; then
    printf '\0prompt\x1fClipboard\n\0no-custom\x1ftrue\n'
    cliphist list | while IFS=$'\t' read -r id content; do
        printf '%s\0icon\x1ftext-plain\x1finfo\x1f%s\n' "$content" "$id"
    done
    exit 0
fi

id="${ROFI_INFO:-}"
[[ -z "$id" ]] && exit 0

printf '%s\t\n' "$id" | cliphist decode | wl-copy
