(define screen
  (lambda ( )
    (define screen_ID_1 
      (insert:cylcone 1 16 16 16))
    (property:apply-name screen_ID_1 "screen")
    (edit:move screen_ID_1 0.000000 0.000000 12.000000)
    (property:apply-surface (tools:face-in-body 1 screen_ID_1) (list "Perfect Absorber" "Default")
      (gvector 0 0 0) (gvector 0 0 0)
      (position 0 0 0) 
      (gvector 0 0 0) #t #f)
    ;seleziona la seconda superficie di schermo obiettivo per la successiva analisi
    (edit:select (car (cdr (entity:faces screen_ID_1))))
    )
  )

(screen)