#!/bin/bash

echo "Inregistrare utilizator nou"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CSV="$SCRIPT_DIR/registru.csv"
HOME_ROOT="$SCRIPT_DIR/home"

read -p "Nume utilizator: " username

if [[ -f "$CSV" ]] && grep -q -F ",$username," "$CSV"; then
    echo "Utilizatorul '$username' exista deja"
    exit 1
fi

read -p "Adresa de email: " email

if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]; then
    echo "Email incorect"
    exit 1
fi

read -s -p "Parola: " parola
echo

if ! [[ "$parola" =~ [A-Z] ]] || ! [[ "$parola" =~ [0-9] ]]; then
    echo "[Eroare] Parola este prea slabă. Trebuie să conţină cel puţin o literă mare şi un număr."
    exit 1
fi

parola_hash=$(echo -n "$parola" | sha256sum | cut -d ' ' -f1)
user_id=$(date +%s%N)

home_dir="$HOME_ROOT/$username"
mkdir -p "$home_dir"

if [[ ! -f "$CSV" ]]; then
    echo "id,username,email,parola,homedirectory,lastlogin" > "$CSV"
fi

echo "$user_id,$username,$email,$parola_hash,$home_dir," >> "$CSV"

echo "Utilizatorul '$username' a fost inregistrat"
echo "Email-ul nu poate fi trimis"

