; TracePro Macro: Trapezoidal Prism with Positioned Screen
; This macro creates an isosceles trapezoidal prism and positions a screen
; parallel to the left side leg at a specified distance

(define TrapezoidalPrismPar
  (lambda (angle_deg long_base height extrusion_length)
    ; Define pi constant
    (define pi 3.14159265359)
    
    ; Convert angle from degrees to radians
    (define angle_rad (* angle_deg (/ pi 180.0)))
    
    ; Calculate horizontal offset for each leg
    (define offset (/ height (tan angle_rad)))
    
    ; Calculate z translation to center the prism
    (define z_tran (- 0 (/ extrusion_length 2)))
    
    ; Calculate the four vertices of the isosceles trapezoid
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
    
    ; Move to center the prism in Z
    (edit:move TRAP_SHEET 0.000000 0.000000 z_tran)
    
    ; Apply name and material to the resulting solid
    (property:apply-name TRAP_SHEET "TrapezoidalPrism")
    (property:apply-material TRAP_SHEET "SCHOTT" "K7" (gvector 0 0 0))
    
    ; Return the entity
    TRAP_SHEET
    )
  )

(define TrapezoidalPrismWithScreen
  (lambda (angle_deg long_base height extrusion_length screen_size distance_from_face)
    ; Define pi constant
    (define pi 3.14159265359)
    
    ; Create the trapezoidal prism
    (define prism (TrapezoidalPrismPar angle_deg long_base height extrusion_length))
    
    ; Calculate geometric parameters
    (define angle_rad (* angle_deg (/ pi 180.0)))
    (define offset (/ height (tan angle_rad)))
    
    ; Calculate center of the left face
    ; X: midpoint between bottom-left and top-left X coordinates
    ; Y: midpoint between bottom (0) and top (height)
    ; Z: center of extrusion (0, since prism is centered)
    (define face_center_x (+ (/ (- 0 long_base) 2.0) (/ offset 2.0)))
    (define face_center_y (/ height 2.0))
    (define face_center_z 0.0)
    
    ; Calculate outward normal to the left face
    ; The left face normal points outward to the left and slightly back
    ; Normal direction: (-height, offset, 0) normalized
    (define normal_x (- 0 height))
    (define normal_y offset)
    (define normal_mag (sqrt (+ (* height height) (* offset offset))))
    (define norm_x (/ normal_x normal_mag))
    (define norm_y (/ normal_y normal_mag))
    
    ; Calculate screen position: center of face + distance along normal
    (define screen_x (+ face_center_x (* distance_from_face norm_x)))
    (define screen_y (+ face_center_y (* distance_from_face norm_y)))
    (define screen_z face_center_z)
    
    ; Create screen as a cylinder (thin disk)
    ; Parameters: type, radius1, radius2, height
    ; Making it thin (height = 0.1) to act as a screen
    (define screen_thickness 0.1)
    (define screen_entity 
      (insert:cylcone 1 screen_size screen_size screen_thickness))
    (property:apply-name screen_entity "screen")
    
    ; Calculate rotation to align screen with left face
    ; The screen is initially created with axis along Z (face normal = +Z)
    ; We need to rotate it so the face normal points in direction (norm_x, norm_y, 0)
    
    ; Calculate the angle in XY plane from +X axis
    (define angle_xy (* (atan norm_y norm_x) (/ 180.0 pi)))
    
    ; Apply rotations using correct edit:rotate syntax
    ; edit:rotate takes: entity, origin-position, axis-vector, angle-degrees
    ; First rotate 90° about Y-axis to point screen from Z to X direction
    (edit:rotate screen_entity 
      (position 0 0 0) 
      (gvector 0 1 0) 
      90.0)
    
    ; Then rotate about Z-axis to align with the exact face direction
    (edit:rotate screen_entity 
      (position 0 0 0) 
      (gvector 0 0 1) 
      angle_xy)
    
    ; Move screen to calculated position
    (edit:move screen_entity screen_x screen_y screen_z)
    
    ; Apply Perfect Absorber property to the screen surface
    (property:apply-surface (tools:face-in-body 1 screen_entity) 
      (list "Perfect Absorber" "Default")
      (gvector 0 0 0) (gvector 0 0 0)
      (position 0 0 0) 
      (gvector 0 0 0) #t #f)
    
    ; Select the surface facing the prism (second face) for analysis
    ; This is the face that will receive light from the prism
    (edit:select (car (cdr (entity:faces screen_entity))))
    
    ; Return both entities as a list
    (list prism screen_entity)
    )
  )

; Example usage:
; Parameters: angle_deg, long_base, height, extrusion_length, screen_size, distance_from_face
; Creates a trapezoidal prism with:
; - 52 degree angle between long base and legs
; - 9.3 units long base
; - 4 units height
; - 15 units extrusion length
; - Screen size (radius) of 3 units
; - Screen positioned 2 units away from left face
(TrapezoidalPrismWithScreen 52 9.3 4 15 3.0 2.0)