#!/usr/bin/env bash
set -euo pipefail

OUT="careit-web.pdf"
TMP="framework.build.md"

# 1) zusammenfügen in definierter Reihenfolge
rm -f "$TMP"
while IFS= read -r f; do
  [ -z "$f" ] && continue
  [ "${f:0:1}" = "#" ] && continue
  echo -e "\n\n" >> "$TMP"
  cat "$f" >> "$TMP"
done < pdf-order.txt

# 2) YAML-Frontmatter entfernen (--- ... --- am Dateianfang)
perl -0777 -pe 's/\n---\n.*?\n---\n/\n/gsm' "$TMP" > "$TMP.clean" && mv "$TMP.clean" "$TMP"

# 3) Emojis ersetzen (mindestens dein 👉)
perl -pi -e 's/👉/->/g' "$TMP"

# 4) MDX/HTML Blocks entfernen (div/span) – pragmatisch für PDF
perl -0777 -pe 's/<div[^>]*>.*?<\/div>//gms; s/<span[^>]*>.*?<\/span>//gms' "$TMP" > "$TMP.clean" && mv "$TMP.clean" "$TMP"

# 5) PDF erzeugen mit Template/Config
pandoc "$TMP" -o "$OUT" \
  --defaults=pandoc.yaml \
  -H header.tex

echo "✅ Built $OUT"