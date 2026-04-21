// Zakar Theme — Black + Gold luxury
// Two directions share core tokens; variant-specific tweaks per component.

const Theme = {
  // Blacks
  obsidian: '#07070A',
  onyx: '#0E0E12',
  graphite: '#18181F',
  ash: '#252530',
  smoke: '#3A3A48',

  // Golds
  gold: '#D4B671',          // refined champagne gold
  goldLight: '#EAD8A0',
  goldDeep: '#A78848',
  goldGlow: 'rgba(212,182,113,0.22)',

  // Text
  white: '#F6F2EA',          // warm off-white
  whiteMuted: 'rgba(246,242,234,0.72)',
  whiteFaint: 'rgba(246,242,234,0.48)',
  whiteGhost: 'rgba(246,242,234,0.28)',

  // Accents
  ember: '#C96442',
  sage: '#7A8F6F',

  // Fonts
  serif: '"Cormorant Garamond", "Playfair Display", "Times New Roman", serif',
  display: '"Fraunces", "Cormorant Garamond", serif',
  sans: '"Inter", -apple-system, "SF Pro Text", system-ui, sans-serif',
  mono: '"JetBrains Mono", "SF Mono", ui-monospace, monospace',
};

// Gold hairline border
const hairlineGold = `1px solid rgba(212,182,113,0.25)`;
const hairlineWhite = `1px solid rgba(246,242,234,0.08)`;

// Signature gold gradient — subtle, editorial
const goldGradient = 'linear-gradient(135deg, #EAD8A0 0%, #D4B671 45%, #A78848 100%)';
const goldGradientSoft = 'linear-gradient(180deg, rgba(234,216,160,0.18) 0%, rgba(167,136,72,0.08) 100%)';

// Reusable ZAKAR wordmark — letter-spaced, restrained
function Wordmark({ size = 18, color = Theme.gold, tracking = 6, weight = 500 }) {
  return (
    <div style={{
      fontFamily: Theme.sans,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: tracking,
      color,
      textTransform: 'uppercase',
    }}>ZAKAR</div>
  );
}

// Editorial serif number (big)
function SerifNum({ children, size = 48, color = Theme.gold, weight = 400, italic = false }) {
  return (
    <span style={{
      fontFamily: Theme.display,
      fontSize: size,
      fontWeight: weight,
      fontStyle: italic ? 'italic' : 'normal',
      color,
      lineHeight: 1,
      fontFeatureSettings: '"ss01", "lnum"',
    }}>{children}</span>
  );
}

// Gold glyph — ornamental divider
function GoldDivider({ width = 40, style = {} }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 8, ...style,
    }}>
      <div style={{ width, height: 1, background: `linear-gradient(90deg, transparent, ${Theme.gold}, transparent)` }} />
      <div style={{ width: 3, height: 3, background: Theme.gold, transform: 'rotate(45deg)' }} />
      <div style={{ width, height: 1, background: `linear-gradient(90deg, transparent, ${Theme.gold}, transparent)` }} />
    </div>
  );
}

// Simulated photo tile (striped placeholder)
function PhotoPlaceholder({ hue = 220, sat = 6, light = 22, label, style = {} }) {
  const color = `hsl(${hue}, ${sat}%, ${light}%)`;
  const color2 = `hsl(${hue}, ${sat}%, ${light - 4}%)`;
  return (
    <div style={{
      position: 'relative',
      background: `linear-gradient(135deg, ${color} 0%, ${color2} 100%)`,
      overflow: 'hidden',
      ...style,
    }}>
      {/* diagonal stripes */}
      <div style={{
        position: 'absolute', inset: 0,
        backgroundImage: `repeating-linear-gradient(135deg, transparent 0, transparent 8px, rgba(255,255,255,0.015) 8px, rgba(255,255,255,0.015) 9px)`,
      }} />
      {label && (
        <div style={{
          position: 'absolute', bottom: 6, left: 6,
          fontFamily: Theme.mono, fontSize: 8, color: 'rgba(255,255,255,0.2)',
          textTransform: 'uppercase', letterSpacing: 0.8,
        }}>{label}</div>
      )}
    </div>
  );
}

Object.assign(window, {
  Theme, hairlineGold, hairlineWhite, goldGradient, goldGradientSoft,
  Wordmark, SerifNum, GoldDivider, PhotoPlaceholder,
});
