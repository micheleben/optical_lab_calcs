;; ============================================================
;; Script 4: Basic Importance Sampling for Scattering Surface
;; Demonstrates: Creating a target and applying importance sampling
;; Reference: Presentation slides 31-36
;; Version: v4 (Corrected grid source setup)
;; ============================================================

(define setup-basic-importance-sampling
  (lambda ()
    
    ;; Create a simple optical system
    ;; Lens that scatters light toward a detector
    ;; FIXED v1: solid:sphere requires both center position and radius
    (define lens (solid:sphere (position 0 0 0) 10))
    (property:apply-name lens "ScatteringLens")
    
    ;; Create detector surface at distance
    (define detector (solid:block (position 40 -5 -5) (position 42 5 5)))
    (property:apply-name detector "Detector")
    
    ;; Apply scattering property to lens
    ;; This creates the scenario where we need importance sampling
    ;; FIXED v2: Changed property:apply-surface-name to property:apply-surface
    (property:apply-surface (car (entity:faces lens)) 
      (list "Lambertian_50%_Reflect" "Default"))
    
    ;; Get the front face of the detector for targeting
    (define detector-face (car (entity:faces detector)))
    (define lens-scatter-face (car (entity:faces lens)))
    
    ;; ============================================================
    ;; IMPORTANCE SAMPLING SETUP
    ;; This is the key part - directing scattered rays to detector
    ;; ============================================================
    
    ;; Create importance sampling target at detector location
    ;; FIXED v3: Corrected argument order and types
    ;; Syntax: (property:apply-importance-target ent type direction samples 
                 ;;          center normal up size1 size2 ndim1 ndim2)
    ;; - type: "rect" for rectangular or "circ" for circular
    ;; - direction: positive number for Toward, negative for Away
    
    (property:apply-importance-target 
      lens-scatter-face          ;; Surface to apply importance sampling
      "rect"                     ;; Target type (rectangular)
      1                          ;; Direction (positive = Toward)
      1                          ;; Samples (rays per cell to target)
      (position 41 0 0)          ;; Target center (detector location)
      (gvector 1 0 0)            ;; Normal vector (pointing toward source)
      (gvector 0 1 0)            ;; Up vector
      10                         ;; size1 (X width in mm)
      10                         ;; size2 (Y width in mm)
      1                          ;; ndim1 (X cells for stratification)
      1)                         ;; ndim2 (Y cells for stratification)
    
    ;; Enable importance sampling in raytrace options
    (raytrace:set-importance-sampling-on)
    
    ;; Set low flux threshold for importance sampling
    ;; (from slide 22 - use 1e-6 for importance sampling)
    (raytrace:set-flux-threshold 1e-6)
    
    ;; ============================================================
    ;; GRID SOURCE SETUP
    ;; FIXED v4: Corrected grid source functions
    ;; ============================================================
    
    ;; Set grid origin (position of the grid)
    (raytrace:set-grid-origin (position -20 0 0))
    
    ;; Set beam to converge to the lens center (aim point)
    ;; This replaces the non-existent raytrace:set-grid-aim-point
    (raytrace:set-beam-orientation-converge-to-point (position 0 0 0))
    
    ;; Set grid pattern to rectangular with 5x5 points and flux per ray of 1.0
    ;; This replaces raytrace:set-grid-x-points and raytrace:set-grid-y-points
    ;; Syntax: (raytrace:set-grid-pattern-rectangular y-points x-points flux)
    (raytrace:set-grid-pattern-rectangular 5 5 1.0)
    
    (display "Importance sampling setup complete!")
    (newline)
    (display "Now trace with: (raytrace:all-sources)")
    (newline)
    ))

;; Run the setup
(setup-basic-importance-sampling)