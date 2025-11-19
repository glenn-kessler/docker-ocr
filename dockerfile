# minimales Basis-Image (Alpine)
FROM alpine:latest

# Installation von Tesseract und Ghostscript

RUN apk update && \
    apk add --no-cache tesseract-ocr tesseract-ocr-data-deu ghostscript bash && \
    rm -rf /var/cache/apk/*

# Arbeitsverzeichnis definieren
WORKDIR /shared_data

# Das Skript (ocr_script.sh) mit deutscher Sprachdefinition

RUN echo '#!/bin/bash' > /ocr_script.sh && \
    echo 'INPUT_PDF="$1"' >> /ocr_script.sh && \
    echo 'OUTPUT_FILE="$2"' >> /ocr_script.sh && \
    echo '' >> /ocr_script.sh && \
    echo 'echo "Starte Konvertierung mit Ghostscript..."' >> /ocr_script.sh && \
    echo 'gs -o page-%03d.png -sDEVICE=png16m -r300 "$INPUT_PDF"' >> /ocr_script.sh && \
    echo 'echo "Starte Tesseract OCR (Deutsch)..."' >> /ocr_script.sh && \
    echo '> "$OUTPUT_FILE"' >> /ocr_script.sh && \
    echo 'for img in page-*.png; do' >> /ocr_script.sh && \
    echo '    tesseract "$img" stdout -l deu --psm 3 >> "$OUTPUT_FILE"' >> /ocr_script.sh && \
    echo '    echo "" >> "$OUTPUT_FILE"' >> /ocr_script.sh && \
    echo 'done' >> /ocr_script.sh && \
    echo 'echo "OCR abgeschlossen. Entferne temporäre Bilder..."' >> /ocr_script.sh && \
    echo 'rm page-*.png' >> /ocr_script.sh && \
    chmod +x /ocr_script.sh

# Standardbefehl
CMD ["/ocr_script.sh"]
