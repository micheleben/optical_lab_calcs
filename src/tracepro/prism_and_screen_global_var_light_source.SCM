; TracePro Macro v5: Trapezoidal Prism with Screen and Light Source
; This version uses separate functions for prism, screen, and light source creation
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
    (define face_center_x (+ (/ (- 0 PRISM_LONG_BASE) 2.0) (/ offset 2.0)))
    (define face_center_y (/ PRISM_HEIGHT 2.0))
    (define face_center_z 0.0)
    
    ; Calculate outward normal to the left face
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
    (define screen_thickness 0.1)
    (define screen_entity 
      (insert:cylcone screen_thickness SCREEN_SIZE SCREEN_SIZE SCREEN_SIZE))
    (property:apply-name screen_entity "screen")
    
    ; Calculate rotation to align screen with left face
    (define angle_xy (* (atan norm_y norm_x) (/ 180.0 pi)))
    
    ; Apply rotations
    (edit:rotate screen_entity 0 0 0 0 1 0 90.0)
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
; FUNCTION 3: Create and Position Light Source
; ============================================================
(define CreateLightSourceForPrism
  (lambda ()
    ; Define pi constant
    (define pi 3.14159265359)
    
    ; Calculate geometric parameters from global variables
    (define angle_rad (* PRISM_ANGLE_DEG (/ pi 180.0)))
    (define offset (/ PRISM_HEIGHT (tan angle_rad)))
    
    ; Calculate center of the RIGHT face
    ; Right face: from (long_base/2, 0) to (long_base/2 - offset, height)
    (define face_center_x (- (/ PRISM_LONG_BASE 2.0) (/ offset 2.0)))
    (define face_center_y (/ PRISM_HEIGHT 2.0))
    (define face_center_z 0.0)
    
    ; Calculate outward normal to the right face
    ; Normal direction: (height, offset, 0) normalized
    (define normal_x PRISM_HEIGHT)
    (define normal_y offset)
    (define normal_mag (sqrt (+ (* PRISM_HEIGHT PRISM_HEIGHT) (* offset offset))))
    (define norm_x (/ normal_x normal_mag))
    (define norm_y (/ normal_y normal_mag))
    
    ; Calculate light source position: center of face + distance along normal
    (define source_x (+ face_center_x (* SOURCE_DISTANCE norm_x)))
    (define source_y (+ face_center_y (* SOURCE_DISTANCE norm_y)))
    (define source_z face_center_z)
    
    ; Convert emission angle from degrees to radians
    (define angle_emission_rad (* SOURCE_ANGLE_EMISSION (/ pi 180.0)))
    
    ; Add grid source
    (raytrace:add-grid-source "mysource")
    
    ; Set grid origin position
    (raytrace:set-grid-origin (position source_x source_y source_z) "mysource")
    
    ; Set grid orientation - normal points TOWARD the prism (opposite of outward normal)
    ; Up vector is in Y direction
    (raytrace:set-grid-orientation-direction-vectors 
      (gvector (- 0 norm_x) (- 0 norm_y) 0.0) 
      (gvector 0.0 1.0 0.0) 
      "mysource")
    
    ; Set boundary as annular (circular)
    (raytrace:set-grid-boundary-annular SOURCE_RADIUS 0.0 "mysource")
    
    ; Set grid pattern to random
    (raytrace:set-grid-pattern-random SOURCE_NUM_RAYS SOURCE_FLUX "mysource")
    
    ; Set emission type to flux per ray
    (raytrace:set-grid-emission-type 0 "mysource")
    
    ; Set flux per ray
    (raytrace:set-grid-flux-per-ray 1.0 "mysource")
    
    ; Set ray color (red)
    (raytrace:set-grid-raycolor (color:rgb 1.0 0.0 0.0) "mysource")
    
    ; Set beam spatial profile to uniform
    (raytrace:set-beam-spatial-profile-uniform "mysource")
    
    ; Set beam spatial weighting
    (raytrace:set-beam-spatial-weighting-uniform-flux "mysource")
    
    ; Set beam angular profile to uniform with half-angle in radians
    (raytrace:set-beam-angular-profile-uniform angle_emission_rad "mysource")
    
    ; Set beam angular weighting
    (raytrace:set-beam-angular-weighting-uniform-flux "mysource")
    
    ; Set beam orientation perpendicular to grid
    (raytrace:set-beam-orientation-perpendicular "mysource")
    
    ; Set degree of polarization
    (raytrace:set-degree-of-polarization 1.0 "mysource")
    
    ; Set polarization state to unpolarized
    (raytrace:set-polarization-state-unpolarized "mysource")
    
    ; Set wavelengths
    (define wvList (list (list 0.5461 1.0)))
    (raytrace:set-wavelengths wvList (raytrace:source-get-by-name "mysource"))
    
    ; Trace rays from all sources
    (raytrace:all-sources)
    
    ; Set irradiance normalization to peak irradiance
    (analysis:irradiance-normalized 2)
    
    ; Display irradiance map
    (analysis:irradiance)
    
    ; Save irradiance map
    (analysis:irradiance-save 
      (string-append SOURCE_FILENAME "_" 
        (number->string source_x) "_" 
        (number->string source_z) "_map.txt"))
    
    ; Display incident ray table
    (analysis:incident)
    
    ; Save incident ray table
    (analysis:incident-save 
      (string-append SOURCE_FILENAME "_" 
        (number->string source_x) "_" 
        (number->string source_z) "_inct.txt"))
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

; Light source parameters
(define SOURCE_RADIUS 1.5)            ; Radius of the light source (Rs)
(define SOURCE_ANGLE_EMISSION 1.0)   ; Half angle of emission in degrees
(define SOURCE_DISTANCE 2.0)          ; Distance from right face to source
(define SOURCE_NUM_RAYS 1000)         ; Number of rays to trace
(define SOURCE_FLUX 1000.0)           ; Total flux
(define SOURCE_FILENAME "output")     ; Base filename for saving results

; ============================================================
; MAIN EXECUTION: Create prism, screen, and light source
; ============================================================
(define prism (CreateTrapezoidalPrism))
(define screen (CreateScreenForPrism))
(CreateLightSourceForPrism)