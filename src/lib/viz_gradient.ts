type HSL = [number, number, number];


// Linear interpolation between two values
export function lerp(lo: number, hi: number, t: number): number {
  return lo + (hi - lo) * t;
}

function normalise(value: number, min: number, max: number): number {
    return (value - min) / (max - min);
}

// Interpolate HSL values
export function interpolateHSL(hsl1: HSL, hsl2: HSL, t: number): HSL {
  const [h1, s1, l1] = hsl1;
  const [h2, s2, l2] = hsl2;

  const h = lerp(h1, h2, t);
  const s = lerp(s1, s2, t);
  const l = lerp(l1, l2, t);

  return [h, s, l];
}

// Helper function to convert linear RGB to HSL
export function rgbToHsl(r: number, g: number, b: number): HSL {
  r /= 255, g /= 255, b /= 255;
  const max = Math.max(r, g, b), min = Math.min(r, g, b);
  let h = 0, s = 0, l = (max + min) / 2;

  if (max === min) {
    h = s = 0; // achromatic
  } else {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    switch (max) {
      case r: h = (g - b) / d + (g < b ? 6 : 0); break;
      case g: h = (b - r) / d + 2; break;
      case b: h = (r - g) / d + 4; break;
    }
    h /= 6;
  }

  return [h * 360, s * 100, l * 100];
}

type UnitToHSL = (unit: number) => HSL
type Range = { min: number, max: number }

export class VizGradient {
    static viridis(ratingRange: Range) {
        return new VizGradient(viridisUnitToHSL, ratingRange);
    }

    unitRange: Range;
    constructor(readonly unitToHSL: UnitToHSL, ratingRange: Range) {
        console.log("ratingRange", ratingRange);
        this.unitRange = {
            min: ratingRange.min / 10,
            max: ratingRange.max / 10,
        };
        console.log("unitRange", this.unitRange);
    }

    ratingToCss(rating: number): string {
        const unit = rating/10;
        const scaled = normalise(unit, this.unitRange.min, this.unitRange.max);

        const [hue, saturation, lightness] = this.unitToHSL(scaled);
        return `hsl(${hue}, ${saturation}%, ${lightness}%)`;
    }
}



const viridisRGB = [
[68, 1, 84],
[71, 18, 101],
[72, 35, 116],
[70, 52, 126],
[64, 67, 135],
[58, 82, 141],
[51, 96, 144],
[43, 110, 146],
[36, 123, 145],
[30, 136, 141],
[33, 148, 134],
[51, 160, 123],
[68, 171, 111],
[89, 181, 100],
[112, 191, 91],
[139, 201, 86],
[166, 210, 83],
[194, 219, 86],
[223, 228, 91],
[249, 237, 97],
];

const viridisHSL = viridisRGB.map(([r, g, b]) => rgbToHsl(r, g, b));

// Function to convert data values to HSL color codes using the Viridis colormap
function viridisUnitToHSL(unit: number): HSL {
  const t = unit * (viridisHSL.length - 1);
  const index1 = Math.floor(t);
  const index2 = Math.min(index1 + 1, viridisHSL.length - 1);

  const hsl1 = viridisHSL[index1];
  const hsl2 = viridisHSL[index2];

  return interpolateHSL(hsl1, hsl2, t - index1);
}
