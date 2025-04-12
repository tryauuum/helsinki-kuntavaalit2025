#!/bin/bash

JSON_DIR="."
OUTPUT_FILE="README.md"

declare -A PARTY_NAMES
PARTY_NAMES[2]="Liberaalipuolue - Vapaus valita"
PARTY_NAMES[3]="Perussuomalaiset"
PARTY_NAMES[9]="Suomen Kristillisdemokraatit (KD)"
PARTY_NAMES[15]="Vapauden liitto"
PARTY_NAMES[19]="Kansallinen Kokoomus"
# Add more party mappings as needed

# Start the Markdown file with a header
echo "# Helsinki Municipal Election Candidates 2025 which don't suck" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Read the git commit history to understand how the list was constructed" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Create table header
echo "| Name | Party | Yle Candidate Page |" >> "$OUTPUT_FILE"
echo "|------|-------|-------------------|" >> "$OUTPUT_FILE"

# this weirdness to sort by party id
for x in *.json; do echo $x | grep -q candidates.json || { echo "$x $(cat $x | jq .party_id)"; }; done | sort -k2 -V  | awk '{print $1}' | while read -r json_file; do
    # Extract candidate information using jq
    id=$(jq -r '.id' "$json_file")
    first_name=$(jq -r '.first_name' "$json_file")
    last_name=$(jq -r '.last_name' "$json_file")
    party_id=$(jq -r '.party_id' "$json_file")
    
    # Get party name from the mapping
    party_name="${PARTY_NAMES[$party_id]:-Unknown Party}"
    
    # Build the Yle URL
    yle_url="https://vaalit.yle.fi/vaalikone/kuntavaalit2025/25/ehdokkaat/$id"
    
    # Add a row to the table
    echo "| $first_name $last_name | $party_name | [Profile]($yle_url) |" >> "$OUTPUT_FILE"
done

echo "Generated markdown table in $OUTPUT_FILE"
