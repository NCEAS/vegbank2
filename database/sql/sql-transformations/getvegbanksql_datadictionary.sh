#/bin/bash

# Define the input and output file names
INPUT_XML="db_model_vegbank.xml"
STYLESHEET_XSL="dbmodel-to-ddtables.xsl"
OUTPUT_SQL="populate-datadictionary.sql"

# Confirm input XML file exists
if [ ! -f "$INPUT_XML" ]; then
  echo "Input XML file '$INPUT_XML' not found!"
  exit 1
fi

# Confirm XSL stylesheet file exists
if [ ! -f "$STYLESHEET_XSL" ]; then
  echo "XSL stylesheet file '$STYLESHEET_XSL' not found!"
  exit 1
fi

# Run the XSLT transformation to get 'populate-datadictionary.sql'
xsltproc -o "$OUTPUT_SQL" "$STYLESHEET_XSL" "$INPUT_XML"

# Check if the process was successful
if [ $? -eq 0 ]; then
  echo "Transformation successful. Output saved to '$OUTPUT_SQL'."
else
  echo "Transformation failed."
  exit 1
fi