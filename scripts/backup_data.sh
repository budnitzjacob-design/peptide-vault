#!/bin/bash
# Backup peptide-vault data files with date-stamped copies
# Usage: ./scripts/backup_data.sh
# Run before any data update to preserve previous state

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"
BACKUP_DIR="$DATA_DIR/backups"
DATE=$(date +%Y-%m-%d)

mkdir -p "$BACKUP_DIR"

for file in peptides.json vendor_safety.json prices.json; do
  if [ -f "$DATA_DIR/$file" ]; then
    DEST="$BACKUP_DIR/${file%.json}_${DATE}.json"
    if [ -f "$DEST" ]; then
      # Add timestamp suffix if same-day backup already exists
      DEST="$BACKUP_DIR/${file%.json}_${DATE}_$(date +%H%M%S).json"
    fi
    cp "$DATA_DIR/$file" "$DEST"
    echo "Backed up: $file → $(basename $DEST)"
  fi
done

# Prune backups older than 90 days
find "$BACKUP_DIR" -name "*.json" -mtime +90 -delete 2>/dev/null || true

echo "Backup complete. Files in: $BACKUP_DIR"
