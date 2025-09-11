# Optical Transmission Losses: Fresnel, Surface Scattering, and AR Coatings

## Overview

Optical transmission through components is limited by several fundamental loss mechanisms. Understanding these mechanisms is crucial for designing high-performance optical systems and establishing manufacturing tolerances. This document covers the three primary loss mechanisms affecting transmission in the 700-1000nm range for common optical materials.

## 1. Fresnel Reflection Losses

### Theory

Fresnel losses occur at every interface between materials with different refractive indices, even for perfectly smooth surfaces. These losses are fundamental and unavoidable without coatings.

For normal incidence, the reflectance at a single interface is given by:

```
R = ((n₁ - n₂)/(n₁ + n₂))²
```

Where:
- n₁ = refractive index of incident medium (air ≈ 1.0)
- n₂ = refractive index of substrate material

### Practical Calculations

**UV Fused Silica Example** (n ≈ 1.46 at 800nm):

```
R = ((1.0 - 1.46)/(1.0 + 1.46))² = (-0.46/2.46)² = 0.035 = 3.5%
```

For a typical optical component with two surfaces:
- Single surface reflection: 3.5%
- Total reflection loss: 2 × 3.5% = 7.0%
- **Theoretical maximum transmission: 93.0%**

**Sapphire Example** (n ≈ 1.77 at 800nm):

```
R = ((1.0 - 1.77)/(1.0 + 1.77))² = (-0.77/2.77)² = 0.077 = 7.7%
```

- Total reflection loss: 2 × 7.7% = 15.4%
- **Theoretical maximum transmission: 84.6%**

### Key Points

- Fresnel losses scale with (n-1)²/(n+1)²
- Higher index materials have higher reflection losses
- These are coherent reflection losses - they represent actual optical power reflected backward
- Independent of surface finish quality (for optically smooth surfaces)

## 2. Surface Scattering: Rayleigh-Rice Theory

### Physical Mechanism

Surface roughness creates microscopic height variations that scatter incident light in all directions. Unlike Fresnel reflection, this scattered light is generally lost to the optical system.

### Rayleigh-Rice Scattering Theory

For surfaces with RMS roughness much smaller than the wavelength (σ << λ), the Total Integrated Scatter (TIS) is given by:

```
TIS = (4πσ cos θ / λ)²
```

Where:
- σ = RMS surface roughness
- θ = angle of incidence (0° for normal incidence)
- λ = wavelength

### Validity Conditions

The Rayleigh-Rice approximation is valid when:
- σ << λ (typically σ < λ/10)
- Surface correlation length >> λ
- Gaussian height distribution

For rougher surfaces, more complex theories (Bennett-Porteus, etc.) are required.

### Industry Typical RMS Values

| Manufacturing Grade | RMS Roughness | Typical Process |
|---------------------|---------------|----------------|
| Ultra-precision | 0.3-0.8 Å | Ion beam figuring, magnetorheological finishing |
| High-end precision | 0.5-1.5 Å | Advanced polishing, float glass |
| Standard/Cost-effective | 2-5 Å | Conventional polishing |
| Basic/Economical | 5-15 Å | Reduced polishing time |
| Poor finish | 15-50 Å | Minimal polishing, grinding marks |

### Worked Examples at 800nm

**High-end precision (1 Å RMS):**
```
TIS = (4π × 1×10⁻¹⁰ / 800×10⁻⁹)² = 2.47×10⁻⁴
```
- Per surface scattering loss: 0.025%
- Two surfaces: 0.05% total

**Cost-effective (3 Å RMS):**
```
TIS = (4π × 3×10⁻¹⁰ / 800×10⁻⁹)² = 2.22×10⁻³
```
- Per surface scattering loss: 0.22%
- Two surfaces: 0.44% total

**Basic grade (8 Å RMS):**
```
TIS = (4π × 8×10⁻¹⁰ / 800×10⁻⁹)² = 1.58×10⁻²
```
- Per surface scattering loss: 1.6%
- Two surfaces: 3.2% total

**Poor finish (20 Å RMS):**
```
TIS = (4π × 20×10⁻¹⁰ / 800×10⁻⁹)² = 9.87×10⁻²
```
- Per surface scattering loss: 9.9%
- Two surfaces: 19.7% total

### Wavelength Dependence

Scattering scales as λ⁻², so shorter wavelengths see more scattering:

| Wavelength | Scattering Factor |
|------------|------------------|
| 700nm | 1.31× (relative to 800nm) |
| 800nm | 1.00× (reference) |
| 1000nm | 0.64× |

## 3. Anti-Reflective Coatings

### Principle of Operation

AR coatings work by creating destructive interference between reflections from the air-coating and coating-substrate interfaces. The simplest case is a quarter-wave single layer coating.

### Single Layer AR Coating

For a λ/4 coating with refractive index n₂ on substrate with index n₃:

Optimal coating index: `n₂ = √(n₁ × n₃)`

For air-to-glass interface: `n₂ = √(1.0 × 1.46) = 1.21`

Common AR coating materials:
- MgF₂ (n ≈ 1.38): Not optimal but robust, single-layer possible
- Sol-gel silica (n ≈ 1.22): Nearly optimal for glass substrates
- Cryolite (Na₃AlF₆, n ≈ 1.33): Good compromise

### Multi-layer AR Coatings

Modern AR coatings use multiple layers (2-7 layers typical) to achieve:
- Broader spectral coverage
- Lower residual reflection (<0.25% per surface)
- Better durability

Typical performance:
- Broadband AR: <0.5% reflection per surface over 200nm bandwidth
- Narrowband AR: <0.25% reflection per surface over 50nm bandwidth

### AR Coating Loss Mechanisms

**1. Coating Material Absorption**

Each coating layer introduces some absorption loss:

| Material | Absorption @ 800nm | Typical Thickness |
|----------|------------------|------------------|
| MgF₂ | ~10⁻⁴ cm⁻¹ | λ/4 ≈ 145nm |
| SiO₂ | ~10⁻⁵ cm⁻¹ | Variable |
| Ta₂O₅ | ~10⁻³ cm⁻¹ | <50nm |
| TiO₂ | ~10⁻² cm⁻¹ | <30nm |

Typical total absorption: 0.1-0.5% per coated surface

**2. Coating Scattering**

AR coatings can introduce additional scattering from:
- Coating surface roughness (typically follows substrate)
- Internal coating structure (grain boundaries, density variations)
- Interface roughness between coating layers

Generally: Coating scattering ≈ 0.5× substrate scattering (for well-optimized coatings)

**3. Residual Reflection**

Even optimized AR coatings have some residual reflection:
- Single layer: 0.5-2% typical
- Multi-layer broadband: 0.25-0.5%
- Multi-layer narrowband: <0.25%

### Complete Loss Budget Analysis

Let's compare uncoated vs. AR-coated UV fused silica at different surface qualities:

#### High-end precision (1 Å RMS)

**Uncoated:**
- Fresnel losses: 7.0%
- Surface scattering: 0.05%
- **Total transmission: 93.0%**

**AR-coated:**
- Residual reflection: 0.5% (broadband AR)
- Coating absorption: 0.3%
- Surface scattering: 0.025% (reduced by coating)
- **Total transmission: 99.2%**
- **Gain: +6.2%**

#### Cost-effective (3 Å RMS)

**Uncoated:**
- Fresnel losses: 7.0%
- Surface scattering: 0.44%
- **Total transmission: 92.6%**

**AR-coated:**
- Residual reflection: 0.5%
- Coating absorption: 0.3%
- Surface scattering: 0.22%
- **Total transmission: 99.0%**
- **Gain: +6.4%**

#### Basic grade (8 Å RMS)

**Uncoated:**
- Fresnel losses: 7.0%
- Surface scattering: 3.2%
- **Total transmission: 89.8%**

**AR-coated:**
- Residual reflection: 0.5%
- Coating absorption: 0.3%
- Surface scattering: 1.6%
- **Total transmission: 97.6%**
- **Gain: +7.8%**

## 4. Manufacturing Trade-offs

### Cost vs. Performance

The relationship between surface finish and transmission follows diminishing returns:

| RMS Finish | Relative Polishing Cost | Transmission (AR-coated) |
|------------|------------------------|-------------------------|
| 0.5 Å | 10× | 99.3% |
| 1.0 Å | 5× | 99.2% |
| 3.0 Å | 2× | 99.0% |
| 8.0 Å | 1× | 97.6% |
| 20.0 Å | 0.5× | 90.0% |

### When Surface Finish Matters Most

Surface finish becomes critical when:
- Working with uncoated high-index materials (sapphire, silicon)
- Requiring maximum transmission (laser applications)
- Working at shorter wavelengths (UV applications)
- High-power applications (scattered light creates hot spots)

### Design Guidelines

**For cost-sensitive applications:**
- 3-5 Å RMS adequate for most visible/NIR systems
- Focus budget on good AR coatings rather than ultra-smooth surfaces

**For high-performance systems:**
- <1 Å RMS for critical surfaces
- Combined with high-quality AR coatings
- Consider environmental durability requirements

**For uncoated elements:**
- Surface finish has minimal impact compared to Fresnel losses
- Focus on geometric accuracy (flatness, wedge) over surface finish

## 5. Summary

Understanding the hierarchy of optical losses enables intelligent design decisions:

1. **Fresnel losses dominate** for uncoated elements (3.5-7.7% per surface)
2. **AR coatings provide the largest gain** (6-8% improvement typical)
3. **Surface scattering becomes significant** only for rough surfaces (>5 Å RMS) or when other losses are minimized
4. **Manufacturing costs scale exponentially** with surface finish quality

The key insight: spend coating budget before ultra-smooth surfaces for maximum transmission gain per dollar invested.