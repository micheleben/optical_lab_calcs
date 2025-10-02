; TracePro Macro v4: Trapezoidal Prism with Positioned Screen
; This version uses separate functions for prism and screen creation
; Parameters are defined as global variables

; ============================================================
; FUNCTION 1: Create Trapezoidal Prism
; ============================================================
(define CreateTrapezoidalPrism
  (lambda ()
    ; Define pi constant
    (define pi 3.14159265359)
    
    ; Convert angle from degrees to radians
    (define angle_rad (* PRISM_ANGLE_DEG (/ pi 180.0)))
    
    ; Calculate horizontal offset for each leg
    (define offset (/ PRISM_HEIGHT (tan angle_rad)))
    
    ; Calculate z translation to center the prism
    (define z_tran (- 0 (/ PRISM_EXTRUSION_LENGTH 2)))
    
    ; Calculate the four vertices of the isosceles trapezoid
    (define v1 (position (/ (- 0 PRISM_LONG_BASE) 2.0) 0.0 0.0))              ; Bottom left
    (define v2 (position (/ PRISM_LONG_BASE 2.0) 0.0 0.0))                     ; Bottom right
    (define v3 (position (- (/ PRISM_LONG_BASE 2.0) offset) PRISM_HEIGHT 0.0)) ; Top right
    (define v4 (position (+ (/ (- 0 PRISM_LONG_BASE) 2.0) offset) PRISM_HEIGHT 0.0)) ; Top left
    
    ; Create the thin sheet with the trapezoid profile
    (define TRAP_SHEET 
      (insert:thin-sheet "TrapezoidSheet" 
        (list v1 v2 v3 v4)))
    
    ; Get the face to sweep
    (define TRAP_FACE (car (entity:faces TRAP_SHEET)))
    
    ; Sweep along Z axis by extrusion_length
    (edit:surface-sweep TRAP_FACE PRISM_EXTRUSION_LENGTH)
    
    ; Move to center the prism in Z
    (edit:move TRAP_SHEET 0.000000 0.000000 z_tran)
    
    ; Apply name and material to the resulting solid
    (property:apply-name TRAP_SHEET "TrapezoidalPrism")
    (property:apply-material TRAP_SHEET "SCHOTT" "K7" (gvector 0 0 0))
    
    ; Return the entity
    TRAP_SHEET
    )
  )

; ============================================================
; FUNCTION 2: Create and Position Screen
; ============================================================
(define CreateScreenForPrism
  (lambda ()
    ; Define pi constant
    (define pi 3.14159265359)
    
    ; Calculate geometric parameters from global variables
    (define angle_rad (* PRISM_ANGLE_DEG (/ pi 180.0)))
    (define offset (/ PRISM_HEIGHT (tan angle_rad)))
    
    ; Calculate center of the left face
    ; X: midpoint between bottom-left and top-left X coordinates
    ; Y: midpoint between bottom (0) and top (height)
    ; Z: center of extrusion (0, since prism is centered)
    (define face_center_x (+ (/ (- 0 PRISM_LONG_BASE) 2.0) (/ offset 2.0)))
    (define face_center_y (/ PRISM_HEIGHT 2.0))
    (define face_center_z 0.0)
    
    ; Calculate outward normal to the left face
    ; The left face normal points outward to the left and slightly back
    ; Normal direction: (-height, offset, 0) normalized
    (define normal_x (- 0 PRISM_HEIGHT))
    (define normal_y offset)
    (define normal_mag (sqrt (+ (* PRISM_HEIGHT PRISM_HEIGHT) (* offset offset))))
    (define norm_x (/ normal_x normal_mag))
    (define norm_y (/ normal_y normal_mag))
    
    ; Calculate screen position: center of face + distance along normal
    (define screen_x (+ face_center_x (* SCREEN_DISTANCE norm_x)))
    (define screen_y (+ face_center_y (* SCREEN_DISTANCE norm_y)))
    (define screen_z face_center_z)
    
    ; Create screen as a thin cylinder (disk)
    ; Parameters: length, base_major, [base_minor], [top_major]
    (define screen_thickness 0.1)
    (define screen_entity 
      (insert:cylcone screen_thickness SCREEN_SIZE SCREEN_SIZE SCREEN_SIZE))
    (property:apply-name screen_entity "screen")
    
    ; Calculate rotation to align screen with left face
    ; The screen is initially created with axis along Z
    ; Calculate the angle in XY plane from +X axis
    (define angle_xy (* (atan norm_y norm_x) (/ 180.0 pi)))
    
    ; Apply rotations using correct edit:rotate syntax
    ; Syntax: (edit:rotate body xcenter ycenter zcenter xdir ydir zdir angle)
    ; First rotate 90° about Y-axis to point screen from Z to X direction
    (edit:rotate screen_entity 0 0 0 0 1 0 90.0)
    
    ; Then rotate about Z-axis to align with the exact face direction
    (edit:rotate screen_entity 0 0 0 0 0 1 angle_xy)
    
    ; Move screen to calculated position
    (edit:move screen_entity screen_x screen_y screen_z)
    
    ; Apply Perfect Absorber property to the screen surface
    (property:apply-surface (tools:face-in-body 1 screen_entity) 
      (list "Perfect Absorber" "Default")
      (gvector 0 0 0) (gvector 0 0 0)
      (position 0 0 0) 
      (gvector 0 0 0) #t #f)
    
    ; Select the surface facing the prism (second face) for analysis
    (edit:select (car (cdr (entity:faces screen_entity))))
    
    ; Return the screen entity
    screen_entity
    )
  )

; ============================================================
; GLOBAL VARIABLES: Define parameters here
; ============================================================
; Trapezoidal prism parameters
(define PRISM_ANGLE_DEG 52)           ; Angle between long base and legs (degrees)
(define PRISM_LONG_BASE 9.3)          ; Length of the bottom base
(define PRISM_HEIGHT 4)               ; Perpendicular height of trapezoid
(define PRISM_EXTRUSION_LENGTH 15)    ; Depth of extrusion

; Screen parameters
(define SCREEN_SIZE 3.0)              ; Radius of the screen
(define SCREEN_DISTANCE 2.0)          ; Distance from left face to screen

; ============================================================
; MAIN EXECUTION: Create prism and screen
; ============================================================
(define prism (CreateTrapezoidalPrism))
(define screen (CreateScreenForPrism))