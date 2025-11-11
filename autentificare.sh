#!/bin/bash

SESSION_PATH="/tmp/.session_${USER}"
CSV="$(dirname "$0")/registru.csv"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

read -p "Nume utilizator: " username

line=$(grep ",$username," "$CSV")
if [[ -z "$line" ]]; then
    echo "[Eroare] Utilizatorul nu există."
    exit 1
fi

stored_hash=$(echo "$line" | cut -d',' -f4)
home_dir=$(echo "$line" | cut -d',' -f5)
last_login=$(echo "$line" | cut -d',' -f6)

read -s -p "Parola: " parola
echo
entered_hash=$(echo -n "$parola" | sha256sum | cut -d' ' -f1)

if [[ "$entered_hash" == "$stored_hash" ]]; then
    echo "[Succes] Autentificare reușită."

    if [[ -z "$last_login" ]]; then
        echo "Bun venit, $username! Aceasta este prima ta autentificare."
    fi

    echo "$username" > "$SESSION_PATH"

    sed -i "s|^\([^,]*,$username,[^,]*,[^,]*,[^,]*,\).*|\1$DATE|" "$CSV"
else
    echo "[Eroare] Parolă incorectă."
    exit 1
fi
