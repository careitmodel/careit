#!/usr/bin/env bash
set -euo pipefail

# Always builds BOTH:
#   - English PDF
#   - German PDF

SITE_ROOT="${SITE_ROOT:-../website}"
ORDER_FILE="${ORDER_FILE:-pdf-order.txt}"
OUT_DIR="${OUT_DIR:-out}"

HEADER_TEX="header.tex"
PANDOC_YAML="pandoc.yaml"

# Optional:
DOI="${DOI:-}"  # e.g. export DOI="10.5281/zenodo.xxxxxxx"
CONCEPT_DOI="${CONCEPT_DOI:-10.5281/zenodo.18679683}"  # <- fix / concept DOI
echo "$CONCEPT_DOI"

mkdir -p "${OUT_DIR}"

# IMPORTANT: declare globally so it always exists (set -u safe)
doi_args=()
if [[ -n "${DOI}" ]]; then
  doi_args=(
    --metadata "doi=${DOI}"
    --metadata "careit_doi=${DOI}"
  )
fi

extract_version() {
  local f="${SITE_ROOT}/docs/versions/current.md"
  if [[ ! -f "${f}" ]]; then
    echo "ERROR: Cannot extract version. Missing: ${f}"
    exit 1
  fi

  local v=""

  # 1) Prefer YAML title: "Version 1.2.0"
  v="$(grep -E '^title:[[:space:]]*' "${f}" \
    | head -n 1 \
    | sed -E 's/^title:[[:space:]]*//; s/"//g' \
    | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' \
    | head -n 1 || true)"

  # 2) Fallback: any "Version 1.2.0" in file
  if [[ -z "${v}" ]]; then
    v="$(grep -Eo 'Version[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+' "${f}" \
      | head -n 1 \
      | sed -E 's/^Version[[:space:]]+//' || true)"
  fi

  if [[ -z "${v}" ]]; then
    echo "ERROR: Could not parse version from: ${f}"
    exit 1
  fi

  echo "${v}"
}

structural_diff_check() {
  local en_root="${SITE_ROOT}/docs"
  local de_root="${SITE_ROOT}/i18n/de/docusaurus-plugin-content-docs/current"

  if [[ ! -d "${en_root}" || ! -d "${de_root}" ]]; then
    echo "ERROR: Cannot run structural diff check. Missing docs dirs."
    echo "EN: ${en_root}"
    echo "DE: ${de_root}"
    exit 1
  fi

  if ! diff \
    <(cd "${en_root}" && find . -name "*.md" | sed 's|^\./||' | sort) \
  <(cd "${de_root}" && find . -name "*.md" | sed 's|^\./||' | sort); then
    echo ""
    echo "ERROR: EN/DE diverge structurally (different .md file sets)."
    echo "Fix by copying/mirroring files so both locales have identical paths."
    exit 1
  fi
}

build_combined_markdown() {
  local locale="$1"
  local docs_dir="$2"
  local tmpfile="$3"

  : > "${tmpfile}"

  while IFS= read -r line; do
    [[ -z "${line// }" ]] && continue
    [[ "${line}" =~ ^# ]] && continue

    local level rel f shift
    if [[ "${line}" == *"|"* ]]; then
      level="${line%%|*}"
      rel="${line#*|}"
    else
      level="1"
      rel="${line}"
    fi

    level="$(echo "${level}" | tr -d ' ')"
    if [[ -z "${level}" || "${level}" =~ [^0-9] ]]; then
      echo "ERROR: Invalid level in ORDER_FILE line: ${line}"
      exit 1
    fi
    if [[ "${level}" -lt 1 || "${level}" -gt 6 ]]; then
      echo "ERROR: Level must be 1..6. Got: ${level} (${line})"
      exit 1
    fi

    f="${docs_dir}/${rel}"
    if [[ ! -f "${f}" ]]; then
      echo "ERROR: Missing file for locale '${locale}': ${f}"
      exit 1
    fi

    shift=$((level - 1))

    awk -v LEVEL="${level}" -v SHIFT="${shift}" '
    function rep(ch, n,   s,i) { s=""; for(i=0;i<n;i++) s=s ch; return s }
    function ltrim(s){ sub(/^[[:space:]]+/, "", s); return s }
    function rtrim(s){ sub(/[[:space:]]+$/, "", s); return s }
    function trim(s){ return rtrim(ltrim(s)) }
    function heading_text(line,   t){
      t=line
      sub(/^#{1,6}[[:space:]]+/, "", t)
      return trim(t)
    }

    BEGIN {
      in_yaml=0
      yaml_title=""; have_yaml_title=0
      h1_title="";   have_h1_title=0

      injected=0
      seen_body=0    # becomes 1 when we see first non-empty, non-heading content
    }

    # YAML start
    NR==1 && $0 ~ /^---[[:space:]]*$/ { in_yaml=1; next }

    # YAML parsing
    in_yaml==1 {
      if ($0 ~ /^---[[:space:]]*$/) { in_yaml=0; next }
      if (!have_yaml_title && $0 ~ /^title:[[:space:]]*/) {
        t=$0
        sub(/^title:[[:space:]]*/, "", t)
        t=trim(t)
        gsub(/^"|"$/, "", t)
        yaml_title=t
        have_yaml_title=1
      }
      next
    }

    # Capture first H1 as canonical title (do not print it)
    (!have_h1_title && $0 ~ /^#[^#][[:space:]]+/) {
      h1_title = heading_text($0)
      have_h1_title=1
      next
    }

    # Skip leading blank lines before injection
    injected==0 && $0 ~ /^[[:space:]]*$/ { next }

    # Inject once, after YAML + after leading blanks
    injected==0 {
      title = have_h1_title ? h1_title : (have_yaml_title ? yaml_title : "(Untitled)")
      print ""
      print rep("#", LEVEL) " " title
      print ""
      injected=1
    }

    # Mark that we have reached body text
    # (first non-empty line that is not a heading)
    !seen_body && $0 !~ /^[[:space:]]*$/ && $0 !~ /^#{1,6}[[:space:]]+/ { seen_body=1 }

    # Drop duplicate “title-like” headings only BEFORE body text begins
    !seen_body && $0 ~ /^#{1,6}[[:space:]]+/ {
      t = heading_text($0)
      if ((have_h1_title && t==h1_title) || (have_yaml_title && t==yaml_title)) {
        next
      }
    }

    # Shift remaining headings
    $0 ~ /^#{1,6}[[:space:]]+/ {
      m = match($0, /^#{1,6}/)
      h = RLENGTH
      rest = substr($0, h+1)
      newh = h + SHIFT
      if (newh > 6) newh = 6
      print rep("#", newh) rest
      next
    }

    { print }
    END { print "\n" }
    ' "${f}" >> "${tmpfile}"

  done < "${ORDER_FILE}"
}

# Derive Docusaurus-style route from a docs relative path.
# Example: 02-principles/p1.md -> /principles/p1
# Derive Docusaurus-style route from a docs relative path.
# Example: 02-principles/p1.md -> /principles/p1
route_from_rel() {
  local rel="$1"
  rel="${rel%.md}"

  local out=""
  local -a parts=()

  # bash: split by /
  IFS='/' read -r -a parts <<< "$rel"

  for seg in "${parts[@]}"; do
    seg="$(echo "$seg" | sed -E 's/^[0-9]{2}-//')"
    out="${out}/${seg}"
  done

  # collapse any accidental double slashes
  out="$(echo "$out" | sed -E 's|//+|/|g')"
  echo "$out"
}

# Extract canonical "file title" exactly like your AWK logic:
# - prefer first H1 (after YAML), else YAML title
extract_file_title() {
  local f="$1"
  perl -0777 -ne '
  my $s = $_;

  # Strip YAML for H1 search, but keep YAML title as fallback
  my $yaml_title = "";
  if ($s =~ /\A---\R(.*?)\R---\R/s) {
    my $yaml = $1;
    if ($yaml =~ /^title:\s*(.+?)\s*$/m) {
      $yaml_title = $1;
      $yaml_title =~ s/^"(.*)"$/$1/;
      $yaml_title =~ s/^\x{feff}//; # BOM safety
    }
    $s =~ s/\A---\R.*?\R---\R//s;
  }

  # First H1 wins
  if ($s =~ /^\#\s+(.+?)\s*$/m) {
    print $1;
    exit;
  }

  # Fallback YAML title
  if ($yaml_title ne "") {
    print $yaml_title;
    exit;
  }

  print "(Untitled)";
  ' "$f"
}

# Pandoc-like auto identifier (good approximation; keeps unicode letters)
pandoc_anchor_from_title() {
  local title="$1"
  perl -CSDA -ne '
  my $t = $_;
  chomp $t;
  $t = lc($t);

  # Replace any run of non-letter/number with a hyphen
  $t =~ s/[^\p{L}\p{N}]+/-/g;

  # Trim hyphens
  $t =~ s/^-+//;
  $t =~ s/-+$//;

  # Collapse
  $t =~ s/-+/-/g;

  # Pandoc uses this as the id (no leading #)
  print $t;
  ' <<< "$title"
}

# Build a TSV map: ROUTE<TAB>ANCHOR
# Uses ORDER_FILE to keep the same selection/order as the PDF.
build_route_anchor_map() {
  local docs_dir="$1"
  local mapfile="$2"

  : > "$mapfile"

  while IFS= read -r line; do
    [[ -z "${line// }" ]] && continue
    [[ "${line}" =~ ^# ]] && continue

    local rel
    if [[ "$line" == *"|"* ]]; then
      rel="${line#*|}"
    else
      rel="$line"
    fi

    local f="${docs_dir}/${rel}"
    [[ -f "$f" ]] || continue

    local route title anchor
    route="$(route_from_rel "$rel")"
    title="$(extract_file_title "$f")"
    anchor="$(pandoc_anchor_from_title "$title")"

    # Only map if anchor is non-empty
    if [[ -n "$anchor" ]]; then
      printf "%s\t%s\n" "$route" "$anchor" >> "$mapfile"
    fi
  done < "$ORDER_FILE"
}

# Rewrite Docusaurus-style internal links in the combined tmpmd:
# ](/principles/p1) -> ](#p1--clinical-effectiveness)
rewrite_internal_links_for_pdf() {
  local tmpmd="$1"
  local mapfile="$2"

  CAREIT_MAPFILE="$mapfile" perl -i -pe '
  BEGIN {
    our %m;
    my $mf = $ENV{CAREIT_MAPFILE} // "";
    die "Cannot open mapfile: (empty)\n" if $mf eq "";

    open my $fh, "<", $mf or die "Cannot open mapfile: $mf\n";
    while (<$fh>) {
      chomp;
      next if $_ eq "";
      my ($route, $anchor) = split(/\t/, $_, 2);
      next unless defined $route && defined $anchor;
      $m{$route} = $anchor;
    }
    close $fh;
  }

  # Rewrite markdown link targets for known routes:
  # ](/x/y) or ](/x/y/)  -> ](#anchor)
  s/\]\((\/[^)#\s]+)\/?\)/ exists($m{$1}) ? "](#$m{$1})" : "]($1)" /ge;
  ' "$tmpmd"
}

build_one() {
  local locale="$1"
  local docs_dir pdf_lang locale_label

  case "${locale}" in
    en)
docs_dir="${SITE_ROOT}/docs"
pdf_lang="en-US"
locale_label="EN"
;;
de)
docs_dir="${SITE_ROOT}/i18n/de/docusaurus-plugin-content-docs/current"
pdf_lang="de-CH"
locale_label="DE"
;;
*)
echo "ERROR: Unsupported locale ${locale}"
exit 1
;;
esac

if [[ ! -d "${docs_dir}" ]]; then
  echo "ERROR: Docs dir not found: ${docs_dir}"
  exit 1
fi
if [[ ! -f "${ORDER_FILE}" ]]; then
  echo "ERROR: ORDER_FILE not found: ${ORDER_FILE}"
  exit 1
fi

local version out resource_path tmpmd
version="$(extract_version)"
out="${OUT_DIR}/CARE-IT-v${version}-${locale}.pdf"
resource_path="${docs_dir}:${SITE_ROOT}/static:${SITE_ROOT}/static/img"
tmpmd="$(mktemp -t careit-${locale}-pdf)"
local titlepage_tmp
titlepage_tmp="$(mktemp -t careit-titlepage-XXXXXX.tex)"

# DOI blocks for titlepage (calm/grey)
local doi_block=""

# Always show concept DOI (if set)
if [[ -n "${CONCEPT_DOI}" ]]; then
  doi_block+=$(cat <<EOF
\\vspace{0.8cm}
{\\small\\color{black!60}Concept DOI: \\href{https://doi.org/${CONCEPT_DOI}}{${CONCEPT_DOI}}\\par}
EOF
)
fi

# --- Concept DOI (fix/konstant) + Version DOI (optional) ---
CONCEPT_DOI="${CONCEPT_DOI:-10.5281/zenodo.18679683}"


# --- Titlepage placeholder blocks ---

# Version DOI block (optional)
local version_doi_block=""
if [[ -n "${DOI}" ]]; then
  version_doi_block=$(cat <<EOF
\\vspace{0.35cm}
{\\small\\color{black!70}
Version DOI:\\quad
\\href{https://doi.org/${DOI}}{${DOI}}\\par}
EOF
)
fi

# Concept DOI must be present for the titlepage template
if [[ -z "${CONCEPT_DOI}" ]]; then
  echo "ERROR: CONCEPT_DOI is empty. Set it via export CONCEPT_DOI=... or hardcode it in makepdf.sh."
  exit 1
fi

CAREIT_VERSION="${version}" \
CAREIT_CONCEPT_DOI="${CONCEPT_DOI}" \
CAREIT_VERSION_DOI_BLOCK="${version_doi_block}" \
perl -0777 -pe '
  my $v  = $ENV{CAREIT_VERSION} // "";
  my $cd = $ENV{CAREIT_CONCEPT_DOI} // "";
  my $vd = $ENV{CAREIT_VERSION_DOI_BLOCK} // "";

  s/__CAREIT_VERSION__/$v/g;
  s/__CAREIT_CONCEPT_DOI__/$cd/g;
  s/__CAREIT_VERSION_DOI_BLOCK__/$vd/g;
' titlepage.tex > "${titlepage_tmp}"

echo ""
echo "----------------------------------------"
echo "Building ${locale_label} PDF"
echo "Docs: ${docs_dir}"
echo "Output: ${out}"
echo "----------------------------------------"

build_combined_markdown "${locale}" "${docs_dir}" "${tmpmd}"

# Auto-map Docusaurus routes -> Pandoc anchors and rewrite links in tmpmd
local mapfile
mapfile="$(mktemp -t careit-map-${locale}-XXXXXX.tsv)"
build_route_anchor_map "${docs_dir}" "${mapfile}"
rewrite_internal_links_for_pdf "${tmpmd}" "${mapfile}"
rm -f "${mapfile}"

pandoc \
--from markdown+yaml_metadata_block+smart \
--toc \
--metadata "lang=${pdf_lang}" \
"${doi_args[@]+"${doi_args[@]}"}" \
--resource-path "${resource_path}" \
--include-in-header "${HEADER_TEX}" \
--include-before-body "${titlepage_tmp}" \
--defaults "${PANDOC_YAML}" \
-o "${out}" \
"${tmpmd}"

#echo "DEBUG: tmpmd = ${tmpmd}"
rm -f "${tmpmd}"

echo "OK: ${out}"
#echo "DEBUG: titlepage tmp = ${titlepage_tmp}"
rm -f "${titlepage_tmp}"
}

# 0) Enforce structural parity between EN and DE
structural_diff_check

# 1) Build both languages
build_one "en"
build_one "de"

echo ""
echo "========================================"
echo "CARE-IT PDFs built successfully."
echo "========================================"