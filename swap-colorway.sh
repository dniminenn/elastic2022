#!/usr/bin/env bash
set -euo pipefail

# Remap Elastic2022 CSS to custom colorway and push.
# Usage: ./swap-colorway.sh [path/to/full-css-e2k.css]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="${1:-${SCRIPT_DIR}/styles/styles.orig.css}"
OUT="${SCRIPT_DIR}/styles/styles.min.css"

if [ ! -f "$SRC" ]; then
  echo "Source CSS not found: $SRC" >&2
  exit 1
fi

cp "$SRC" "$OUT"

# CSS variable blocks (lines 1-26) are handled by the global replacements below.
# Order: longer hex codes first, then shorter, then 3-char codes last.

declare -a PAIRS=(
  # Primary accent family
  '#37beff:#0C7C8C'
  '#1eb6ff:#0A7284'
  '#13b2ff:#096C7E'
  '#00acff:#086678'
  '#00a8f9:#086474'
  '#04adff:#086576'
  '#008cd0:#075A6A'
  '#008acc:#075868'
  '#007bb7:#064E5E'
  '#006a9d:#054352'
  '#005984:#043846'
  '#84d7ff:#52BDCF'
  '#68CFFF:#3FB2C6'
  '#D7F2FF:#E2F3F6'
  '#d0f0ff:#DAF0F3'
  '#CDE6F7:#CFECF0'
  '#E6F2FA:#E0F2F5'
  '#A1D3F4:#96CCD6'

  # Font
  '#2c363a:#1F2937'
  '#2c373a:#1F2937'
  '#2c373b:#1F2937'

  # Dark surfaces
  '#161b1d:#0D1117'
  '#1A1C1E:#0D1117'
  '#1a1c1e:#0D1117'
  '#212324:#12181F'
  '#21292c:#151D28'
  '#212a2c:#151D28'
  '#222f3e:#151D28'
  '#272E32:#151D28'
  '#2f3a3f:#1C2433'
  '#374449:#1C2433'
  '#374549:#1C2433'
  '#425358:#2A3545'
  '#4d5f66:#30404F'
  '#4d6066:#30404F'
  '#52676D:#374A59'
  '#586e75:#3E5464'

  # Mid-tones
  '#737677:#656D76'
  '#6b7275:#5D656E'
  '#7b8688:#6E7882'
  '#778e98:#687A86'
  '#7c939c:#6E8290'
  '#7c949c:#6E8290'
  '#7d989c:#6F8591'
  '#8b9fa7:#7D929E'
  '#8ba3a7:#7D929E'
  '#6e8791:#607A86'
  '#6a828b:#5C7480'
  '#637e82:#567078'

  # Light surfaces
  '#c5d1d3:#CDD5DE'
  '#e2e8e9:#E5E8EB'
  '#e2e7e9:#E5E8EB'
  '#e2e4e7:#E2E5E8'
  '#e0e6ec:#CDD5DE'
  '#e0e0e0:#DFE2E5'
  '#e1e1e1:#E0E3E6'
  '#dee0e2:#DCDFE2'
  '#d4dbde:#D0D7DE'
  '#d4ddde:#D0D7DE'
  '#dadada:#D5D8DC'
  '#ececec:#EAECEE'
  '#f1f3f4:#F0F2F5'
  '#F1F3F4:#F0F2F5'
  '#f4f4f4:#F3F5F7'
  '#F5F5F5:#F6F8FA'
  '#f5f5f5:#F6F8FA'
  '#f6f6f6:#F6F8FA'
  '#F8F8F8:#FAFBFC'
  '#fcfcfc:#FDFEFE'

  # Dark borders
  '#59686C:#30404F'
  '#59686c:#30404F'
  '#6E7C80:#374A59'
  '#64747C:#33475A'
  '#ACB4B7:#D0D7DE'

  # Status
  '#217299:#0C7C8C'
  '#993331:#CF3D3B'
  '#997f31:#B8891C'
  '#276e2c:#238636'
  '#205a24:#1D742E'

  # Action colors
  '#41b849:#238636'
  '#eb0400:#DA3633'
  '#ea3532:#DA3633'
  '#ff5552:#E55B59'
  '#ff3c38:#E04542'
  '#ff322e:#DD3E3B'
  '#ff231f:#DA3633'
  '#ff1915:#D7322F'
  '#F16462:#E55B59'
  '#ac3937:#A83836'
  '#ffd452:#D4A72A'

  # Neutrals
  '#b9b9b9:#ABB2BA'
  '#e2e2e2:#E2E5E8'
  '#4a4a4a:#2A3545'
  '#2a2a2a:#151D28'
  '#424242:#1C2433'
)

for pair in "${PAIRS[@]}"; do
  old="${pair%%:*}"
  new="${pair##*:}"
  sed -i "s/${old}/${new}/g" "$OUT"
done

# 3-char hex codes: use word boundaries to avoid matching inside longer hex values.
declare -a SHORT_PAIRS=(
  '#333:#1F2937'
  '#888:#6E7882'
  '#aaa:#9CA3AB'
  '#bbb:#ADB4BC'
  '#ffc:#FFF8E0'
)

for pair in "${SHORT_PAIRS[@]}"; do
  old="${pair%%:*}"
  new="${pair##*:}"
  sed -i "s/${old}\b/${new}/g" "$OUT"
done

# Replace CSS variable blocks with exact values.
sed -i '2s/.*/    --font: #1F2937;/' "$OUT"
sed -i '3s/.*/    --font2: #656D76;/' "$OUT"
sed -i '4s/.*/    --background: #FFFFFF;/' "$OUT"
sed -i '5s/.*/    --backgroundhover: #CFECF0;/' "$OUT"
sed -i '6s/.*/    --backgroundhoverlight: #E0F2F5;/' "$OUT"
sed -i '7s/.*/    --backgroundtree: #F0F2F5;/' "$OUT"
sed -i '8s/.*/    --backgroundbutton: #F0F2F5;/' "$OUT"
sed -i '9s/.*/    --backgroundcompose: #D0D7DE;/' "$OUT"
sed -i '10s/.*/    --backgroundcomposehover: #656D76;/' "$OUT"
sed -i '11s/.*/    --bordercolor: #D0D7DE;/' "$OUT"

sed -i '16s/.*/    --font: #CDD5DE;/' "$OUT"
sed -i '17s/.*/    --font2: #CDD5DE;/' "$OUT"
sed -i '18s/.*/    --background: #0D1117;/' "$OUT"
sed -i '19s/.*/    --backgroundhover: #253345;/' "$OUT"
sed -i '20s/.*/    --backgroundhoverlight: #1E2A3A;/' "$OUT"
sed -i '21s/.*/    --backgroundtree: #1C2433;/' "$OUT"
sed -i '22s/.*/    --backgroundbutton: #1C2433;/' "$OUT"
sed -i '23s/.*/    --backgroundcompose: #1C2433;/' "$OUT"
sed -i '24s/.*/    --backgroundcomposehover: #2A3545;/' "$OUT"
sed -i '25s/.*/    --bordercolor: #21262D;/' "$OUT"

# Fix rgba references to the original blue accent
sed -i 's/55, 190, 255/12, 124, 140/g' "$OUT"

echo "Wrote $OUT"

cd "$SCRIPT_DIR"
git add styles/styles.min.css
if git diff --cached --quiet; then
  echo "No changes to push."
else
  git commit -m "update colorway"
  git push
  echo "Pushed."
fi
