#!/bin/bash
{
cat <<EOF
(define (build_cv filename outfile-fr outfile-en)
  (let* (
    (a 10)
    (image)
    (drawable)
    (layerfr)
    (layeren)
  )
    (set! image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
    (set! layerfr (car (gimp-image-get-layer-by-name image "textes Fr")))
    (set! layeren (car (gimp-image-get-layer-by-name image "textes En")))
    (gimp-item-set-visible layerfr 1)
    (gimp-item-set-visible layeren 0)

    (set! drawable (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)))
    (file-pdf-save RUN-NONINTERACTIVE image drawable outfile-fr outfile-fr 0 1 1)

    (gimp-image-delete image)

    (set! image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
    (set! layerfr (car (gimp-image-get-layer-by-name image "textes Fr")))
    (set! layeren (car (gimp-image-get-layer-by-name image "textes En")))
    (gimp-item-set-visible layerfr 0)
    (gimp-item-set-visible layeren 1)

    (set! drawable (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)))
    (file-pdf-save RUN-NONINTERACTIVE image drawable outfile-en outfile-en 0 1 1)

    (gimp-image-delete image)
  )
)

(gimp-message-set-handler 1)
EOF

for i in *.xcf; do
  echo "(gimp-message \"$i\")"
  echo "(build_cv \"$i\" \"${i%%.xcf}-fr.pdf\" \"${i%%.xcf}-en.pdf\")"
done

echo "(gimp-quit 0)"
} | gimp -i --no-data --no-splash -b -
