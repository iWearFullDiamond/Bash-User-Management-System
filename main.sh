#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

SESSION_PATH="/tmp/.session_${USER}"
HOME_ROOT="$SCRIPT_DIR/home"

username=""
if [[ -f "$SESSION_PATH" ]]; then
    username=$(head -n1 "$SESSION_PATH")
fi

show_logged_in_menu() {
    while true; do
        echo
        echo "===== Meniu utilizator ($username) ====="
        echo "1) Genereaza raport"
        echo "2) Logout"
        echo "3) Intra in shell in home-ul tau"
        echo "4) Iesire"
        read -p "Alege o optiune: " opt

        case "$opt" in
            1)
                bash "$SCRIPT_DIR/raport.sh" "$username"
                ;;
            2)
                bash "$SCRIPT_DIR/logout.sh"
                username=""
                return
                ;;
            3)
                if [[ -d "$HOME_ROOT/$username" ]]; then
                    cd "$HOME_ROOT/$username" || exit 1
                    echo "Ai intrat in shell in: $(pwd)"
                    exec bash
                else
                    echo "[Eroare] Directorul home pentru $username nu exista."
                fi
                ;;
            4)
                exit 0
                ;;
            *)
                echo "Optiune invalida."
                ;;
        esac
    done
}

show_not_logged_menu() {
    while true; do
        echo
        echo "===== Meniu principal ====="
        echo "1) Inregistrare"
        echo "2) Autentificare"
        echo "3) Iesire"
        read -p "Alege o optiune: " opt

        case "$opt" in
            1)
                bash "$SCRIPT_DIR/inregistrare.sh"
                ;;
            2)
                bash "$SCRIPT_DIR/autentificare.sh"
                if [[ -f "$SESSION_PATH" ]]; then
                    username=$(head -n1 "$SESSION_PATH")
                    show_logged_in_menu
                fi
                ;;
            3)
                exit 0
                ;;
            *)
                echo "Optiune invalida."
                ;;
        esac
    done
}

if [[ -n "$username" ]]; then
    show_logged_in_menu
else
    show_not_logged_menu
fi
