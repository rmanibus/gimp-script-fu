#!/bin/bash
{
cat <<EOF
(define (convert-xcf-to-pdf filename outfile)
  (let* (
 (image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
 (drawable (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)))
 )
    (file-pdf-save RUN-NONINTERACTIVE image drawable outfile outfile 0 1 1)
    (gimp-image-delete image) ; ... or the memory will explode
    )
  )

(gimp-message-set-handler 1) ; Messages to standard output
EOF

for i in *.xcf; do
  echo "(gimp-message \"$i\")"
  echo "(convert-xcf-to-pdf \"$i\" \"${i%%.xcf}.pdf\")"
done

echo "(gimp-quit 0)"
} | gimp -i --no-data --no-splash -b -
