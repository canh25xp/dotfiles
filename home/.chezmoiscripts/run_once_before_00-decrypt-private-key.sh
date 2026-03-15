#!/usr/bin/env bash

KEY_FILE="${HOME}/.config/chezmoi/key.txt"
ENC_FILE="${HOME}/.local/share/chezmoi/.key.txt.age"

if [ ! -f "$KEY_FILE" ]; then
    mkdir -p "${HOME}/.config/chezmoi"

    attempts=0
    while [ "$attempts" -lt 3 ]; do
        if chezmoi age decrypt --output "$KEY_FILE" --passphrase "$ENC_FILE"; then
            chmod 600 "$KEY_FILE"
            break
        fi

        attempts=$((attempts + 1))
        echo "Decrypt failed ($attempts/3), try again..."
    done
fi

# Skip decrypt
exit 0
