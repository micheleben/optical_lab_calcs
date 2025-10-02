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
    
    ; Calculate rotation angles to align screen with left face
    ; The screen is initially created with axis along Z (face normal = +Z)
    ; We need to rotate it so the face is perpendicular to (norm_x, norm_y, 0)
    
    ; Step 1: Rotate 90 degrees about Y to bring axis to X direction
    ; Step 2: Rotate about Z to align with the exact direction
    ; The angle in XY plane from -X axis is: atan2(norm_y, norm_x)
    (define angle_from_neg_x (* (atan norm_y norm_x) (/ 180.0 pi)))
    ; Adjust: we need angle from +X, and account for initial 90-deg Y rotation
    (define rotation_z (- 180.0 angle_from_neg_x))
    
    ; Apply rotations: first 90° about Y, then adjust with Z rotation
    (edit:rotate screen_entity 0.0 90.0 rotation_z)
    
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