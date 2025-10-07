;; ============================================================
;; Script 2: Basic Importance Sampling for Scattering Surface
;; Demonstrates: Creating a target and applying importance sampling
;; Reference: Presentation slides 31-36
;; Version: v2 (Corrected property:apply-surface)
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
    ;; Parameters from slide 35:
    ;; - Rectangular target at detector position
    ;; - Toward direction (rays aim at target)
    ;; - 1 ray per scatter event to target
    
    (property:apply-importance-target 
      lens-scatter-face          ;; Surface to apply importance sampling
      1                          ;; Target number
      1                          ;; Rays per cell to target
      "Toward"                   ;; Direction
      "Rectangular"              ;; Shape
      (position 41 0 0)          ;; Target center (detector location)
      (gvector 1 0 0)            ;; Normal vector (pointing toward source)
      (gvector 0 1 0)            ;; Up vector
      10                         ;; X width
      10                         ;; Y width
      1                          ;; X cells (for stratification)
      1)                         ;; Y cells
    
    ;; Enable importance sampling in raytrace options
    (raytrace:set-importance-sampling-on)
    
    ;; Set low flux threshold for importance sampling
    ;; (from slide 22 - use 1e-6 for importance sampling)
    (raytrace:set-flux-threshold 1e-6)
    
    ;; Create a simple grid source
    (raytrace:set-grid-origin (position -20 0 0))
    (raytrace:set-grid-aim-point (position 0 0 0))
    (raytrace:set-grid-x-points 5)
    (raytrace:set-grid-y-points 5)
    
    (display "Importance sampling setup complete!")
    (newline)
    (display "Now trace with: (raytrace:all-sources)")
    (newline)
    ))

;; Run the setup
(setup-basic-importance-sampling)