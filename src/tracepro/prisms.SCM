(define OW
  (lambda ( )
    (define OW_ID_1 
      (insert:cylcone 1 15 15 15))
    (property:apply-name OW_ID_1 "OW")
    (edit:move OW_ID_1 0.000000 0.000000 20.000000)
    (property:apply-material OW_ID_1 "SCHOTT" "K7" (gvector 0 0 0))
    )
  )

(define TrapezoidalPrism
  (lambda ()
    ; Create a trapezoidal thin sheet (irregular polygon)
    ; Define the four vertices of the trapezoid in the X-Y plane
    (define TRAP_ID_1 
      (insert:thin-sheet "TrapezoidSheet" 
        (list 
          (position 0 0 0)      ; Bottom-left corner
          (position 10 0 0)     ; Bottom-right corner (base = 10 units)
          (position 8 5 0)      ; Top-right corner (top = 8 units, height = 5)
          (position 2 5 0))))   ; Top-left corner
    
    ; Get the face of the thin sheet to sweep it
    (define TRAP_FACE (car (entity:faces TRAP_ID_1)))
    
    ; Sweep the face along its normal (Z-direction) by 15 units
    ; This modifies TRAP_ID_1 into a solid
    (edit:surface-sweep TRAP_FACE 15)
    
    ; Now TRAP_ID_1 is the solid prism, apply name to it
    (property:apply-name TRAP_ID_1 "TrapezoidalPrism")
    
    ; Move the prism if needed (optional)
    (edit:move TRAP_ID_1 0.0 0.0 0.0)
    
    ; Apply a material property (optional)
    (property:apply-material TRAP_ID_1 "SCHOTT" "K7" (gvector 0 0 0))
    )
  )

(define TrapezoidalPrismPar
  (lambda (angle_deg long_base height extrusion_length)
    ; Define pi constant
    (define pi 3.14159265359)
    
    ; Convert angle from degrees to radians
    (define angle_rad (* angle_deg (/ pi 180.0)))
    
    ; Calculate horizontal offset for each leg
    ; offset = height / tan(angle)
    (define offset (/ height (tan angle_rad)))
    
    ; define z translation as extrusion_length /2
    (define z_tran (- 0 ( / extrusion_length 2)))
    ; Calculate the four vertices of the isosceles trapezoid
    ; Coordinate system: Y-axis is symmetry axis, origin on long base
    ; Vertices ordered counter-clockwise starting from bottom-left
    
    (define v1 (position (/ (- 0 long_base) 2.0) 0.0 0.0))              ; Bottom left
    (define v2 (position (/ long_base 2.0) 0.0 0.0))                     ; Bottom right
    (define v3 (position (- (/ long_base 2.0) offset) height 0.0))      ; Top right
    (define v4 (position (+ (/ (- 0 long_base) 2.0) offset) height 0.0)) ; Top left
    
    ; Create the thin sheet with the trapezoid profile
    (define TRAP_SHEET 
      (insert:thin-sheet "TrapezoidSheet" 
        (list v1 v2 v3 v4)))
    
    ; Get the face to sweep
    (define TRAP_FACE (car (entity:faces TRAP_SHEET)))
    
    ; Sweep along Z axis by extrusion_length
    (edit:surface-sweep TRAP_FACE extrusion_length)
    
    (edit:move TRAP_SHEET 0.000000 0.000000 z_tran)
    
    ; Apply name to the resulting solid
    (property:apply-name TRAP_SHEET "TrapezoidalPrismPar")
    
    ; Return the entity
    TRAP_SHEET
    )
  )

; Example usage:
; Create a trapezoidal prism with:
; - 60 degree angle between long base and legs
; - 10 units long base
; - 5 units height (perpendicular distance)
; - 15 units extrusion length
(TrapezoidalPrismPar 52 9.3 4 15)
; Execute the function
;(TrapezoidalPrism)
;(OW)