#!/bin/bash

SESSION="/tmp/.session_${USER}"

if [[ ! -f $SESSION ]]; then
    echo "[Info] Niciun utilizator autentificat."
    exit 0
fi

username=$(cat "$SESSION")
rm "$SESSION"

echo "[Succes] Utilizatorul '$username' a fost delogat."
