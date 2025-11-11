#!/bin/bash

# Verificare argument
if [ $# -ne 1 ]; then
  echo "Utilizare: $0 nume_utilizator"
  exit 1
fi

USERNAME="$1"
USER_HOME="home/$USERNAME"
RAPORT="$USER_HOME/raport.txt"

# Verifică dacă există directorul utilizatorului
if [ ! -d "$USER_HOME" ]; then
  echo "Eroare: Directorul $USER_HOME nu există."
  exit 2
fi

# Generează raportul în fundal
generate_report() {
  NUM_FISIERE=$(find "$USER_HOME" -type f | wc -l)
  NUM_DIRECTOARE=$(find "$USER_HOME" -mindepth 1 -type d | wc -l)
  DIMENSIUNE=$(du -sh "$USER_HOME" | awk '{print $1}')
  DATA_GENERARE=$(date)

  {
    echo "╔═══════════════════════════════════════════════╗"
    printf "║ %-45s ║\n" "RAPORT DE ACTIVITATE - Utilizator: $USERNAME"
    echo "╠═══════════════════════════════════════════════╣"
    printf "║ %-31s %15s ║\n" "Număr fișiere:" "$NUM_FISIERE"
    printf "║ %-30s %15s ║\n" "Număr directoare:" "$NUM_DIRECTOARE"
    printf "║ %-30s %15s ║\n" "Dimensiune totală:" "$DIMENSIUNE"
    echo "╠═══════════════════════════════════════════════╣"
    printf "║ %-45s ║\n" "Generat la: $DATA_GENERARE"
    echo "╚═══════════════════════════════════════════════╝"
  } > "$RAPORT"
}

# Rulează generarea raportului asincron
generate_report &

# Așteaptă finalizarea
wait

# Afișează raportul
echo -e "\n📄 Conținutul raportului:"
cat "$RAPORT"
