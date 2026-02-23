#!/bin/bash
set -e

# ------------------------------------------------------------
# 1. Version aus website/docs/versions/current.md lesen
# ------------------------------------------------------------

VERSION=$(grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' ../website/docs/versions/current.md | head -n 1)

if [ -z "$VERSION" ]; then
  echo "❌ Keine Version gefunden in current.md"
  exit 1
fi

echo "📦 Baue CARE-IT Version $VERSION"

# ------------------------------------------------------------
# 2. Build-Verzeichnisse vorbereiten
# ------------------------------------------------------------

mkdir -p build
mkdir -p ../releases

OUTPUT="../releases/CARE-IT-v${VERSION}.pdf"
TEMP_MD="build/book.md"

# Immer frisch starten
rm -f "$TEMP_MD"

# ------------------------------------------------------------
# 2a. Pandoc-Metadatenblock (Titel/Version) an den Anfang schreiben
# ------------------------------------------------------------

TITLE="CARE-IT Framework"
SUBTITLE="Referenzmodell für Governance und Betriebsführung klinischer digitaler Versorgungsinfrastruktur"
DATESTR=$(date +"%Y-%m-%d")

cat > "$TEMP_MD" <<EOF
---
title: "$TITLE"
subtitle: "$SUBTITLE"
date: "$DATESTR"
version: "v$VERSION"
lang: de-CH
...

EOF

# ------------------------------------------------------------
# 3. Kapitel in definierter Reihenfolge zusammenziehen
#    - YAML frontmatter je Datei entfernen
#    - nur erste H1 (# ) behalten, weitere H1 zu H2 (## ) demoten
# ------------------------------------------------------------

while read FILE; do
  # Skip empty lines and comments
  [[ -z "$FILE" || "$FILE" =~ ^# ]] && continue

  # Allow accidental "docs/" prefix in pdf-order.txt
  FILE="${FILE#docs/}"

  # Defensive: no leading slash
  FILE="${FILE#/}"

  SRC="../website/docs/$FILE"

  echo "➕ $FILE"

  if [ ! -f "$SRC" ]; then
    echo "❌ Datei nicht gefunden: $SRC"
    exit 1
  fi

  # Frontmatter entfernen + H1-Demote (ab der 2. H1 innerhalb derselben Datei)
  awk '
    BEGIN { in_frontmatter=0; seen_h1=0 }

    # Frontmatter startet nur, wenn die Datei mit --- beginnt
    NR==1 && $0 ~ /^---[[:space:]]*$/ { in_frontmatter=1; next }

    # Frontmatter block überspringen
    in_frontmatter==1 {
      if ($0 ~ /^---[[:space:]]*$/) { in_frontmatter=0 }
      next
    }

    # Überschriftenlogik: nur erste # bleibt, weitere # werden ## 
    {
      if ($0 ~ /^# /) {
        if (seen_h1==0) { seen_h1=1; print; next }
        else { sub(/^# /,"## "); print; next }
      }
      print
    }
  ' "$SRC" >> "$TEMP_MD"

  echo -e "\n\n" >> "$TEMP_MD"
done < pdf-order.txt

# ------------------------------------------------------------
# 4. Emojis entfernen (für LaTeX-Stabilität)
# ------------------------------------------------------------
# Minimal-Fix für das bekannte Problemzeichen. Erweiterbar, falls mehr auftaucht.
sed -i '' 's/👉//g' "$TEMP_MD"

# ------------------------------------------------------------
# 5. PDF erzeugen
# ------------------------------------------------------------

pandoc "$TEMP_MD" \
  --defaults=pandoc.yaml \
  -H header.tex \
  -o "$OUTPUT"

echo "✅ Fertig: $OUTPUT"