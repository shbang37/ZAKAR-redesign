// Onboarding V2 — SANCTUM
// Bold, cinematic, immersive. Full-bleed imagery, dramatic serif display
// at massive sizes, reverent gold overlays. Feels like a film title sequence.

function OnboardingV2({ pageOverride }) {
  const [page, setPageState] = React.useState(0);
  const pg = pageOverride !== undefined ? pageOverride : page;
  const setPage = (p) => { if (pageOverride === undefined) setPageState(p); };
  const total = 5;

  return (
    <div style={{
      width: '100%', height: '100%',
      background: '#000', color: Theme.white,
      position: 'relative', fontFamily: Theme.sans,
      overflow: 'hidden',
    }}>
      {pg === 0 && <V2Welcome />}
      {pg === 1 && <V2Meaning />}
      {pg === 2 && <V2Analysis />}
      {pg === 3 && <V2Gesture />}
      {pg === 4 && <V2Begin onEnter={() => {}} />}

      {/* overlay: skip + progress + nav */}
      <div style={{
        position: 'absolute', top: 68, left: 24, right: 24,
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        zIndex: 20,
      }}>
        {/* progress strokes */}
        <div style={{ display: 'flex', gap: 4, flex: 1 }}>
          {[...Array(total)].map((_, i) => (
            <div key={i} style={{
              flex: 1, height: 2,
              background: i <= pg ? Theme.gold : 'rgba(255,255,255,0.12)',
              transition: 'all 400ms',
            }} />
          ))}
        </div>
        {pg > 0 && pg < total - 1 && (
          <div onClick={() => setPage(total - 1)} style={{
            fontFamily: Theme.mono, fontSize: 10, letterSpacing: 2,
            color: Theme.whiteFaint, textTransform: 'uppercase',
            marginLeft: 16, cursor: 'pointer',
          }}>SKIP</div>
        )}
      </div>

      {/* bottom CTA */}
      <div style={{
        position: 'absolute', bottom: 48, left: 24, right: 24,
        zIndex: 20, display: 'flex', alignItems: 'center', gap: 12,
      }}>
        {pg > 0 && (
          <button onClick={() => setPage(pg - 1)} style={{
            width: 52, height: 52,
            border: `1px solid rgba(212,182,113,0.35)`,
            background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(12px)',
            color: Theme.gold, cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
              <path d="M9 2L3 7l6 5" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
            </svg>
          </button>
        )}
        {pg < total - 1 ? (
          <button onClick={() => setPage(pg + 1)} style={{
            flex: 1, height: 52,
            background: goldGradient, border: 'none',
            fontFamily: Theme.sans, fontSize: 12, fontWeight: 700,
            letterSpacing: 4, textTransform: 'uppercase',
            color: Theme.obsidian, cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12,
          }}>
            <span>{pg === 0 ? 'Begin' : 'Continue'}</span>
            <svg width="16" height="10" viewBox="0 0 16 10" fill="none">
              <path d="M1 5h13M10 1l4 4-4 4" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"/>
            </svg>
          </button>
        ) : null}
      </div>
    </div>
  );
}

// V2 Page 1 — Cinematic welcome
function V2Welcome() {
  const [mounted, setMounted] = React.useState(false);
  React.useEffect(() => { setMounted(true); }, []);

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', overflow: 'hidden' }}>
      {/* huge backdrop — cathedral light */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `
          radial-gradient(ellipse 70% 50% at 50% 30%, rgba(212,182,113,0.22) 0%, rgba(212,182,113,0) 60%),
          radial-gradient(ellipse 50% 80% at 50% 120%, rgba(167,136,72,0.15) 0%, transparent 70%),
          linear-gradient(180deg, #0A0A0E 0%, #000 100%)
        `,
      }} />

      {/* light rays */}
      <svg width="100%" height="100%" style={{ position: 'absolute', inset: 0, opacity: 0.35 }}>
        <defs>
          <linearGradient id="ray" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={Theme.gold} stopOpacity="0.6"/>
            <stop offset="100%" stopColor={Theme.gold} stopOpacity="0"/>
          </linearGradient>
        </defs>
        {[0.3, 0.5, 0.7].map((x, i) => (
          <polygon key={i} points={`${x*400-10},0 ${x*400+10},0 ${x*400+60},900 ${x*400-60},900`}
            fill="url(#ray)" opacity={0.4 - i*0.1} />
        ))}
      </svg>

      {/* grain */}
      <div style={{
        position: 'absolute', inset: 0,
        backgroundImage: `url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='200' height='200'><filter id='n'><feTurbulence baseFrequency='0.85' numOctaves='3' stitchTiles='stitch'/></filter><rect width='100%' height='100%' filter='url(%23n)' opacity='0.35'/></svg>")`,
        mixBlendMode: 'overlay', opacity: 0.8,
      }} />

      {/* text */}
      <div style={{
        position: 'absolute', inset: 0,
        display: 'flex', flexDirection: 'column',
        justifyContent: 'center', padding: '0 28px',
        transform: mounted ? 'translateY(0)' : 'translateY(20px)',
        opacity: mounted ? 1 : 0,
        transition: 'all 900ms ease-out',
      }}>
        <div style={{
          fontFamily: Theme.mono, fontSize: 10, letterSpacing: 4,
          color: Theme.gold, textTransform: 'uppercase', marginBottom: 20,
        }}>— EST. MMXXVI —</div>

        <div style={{
          fontFamily: Theme.display, fontSize: 130, fontWeight: 300,
          color: Theme.white, lineHeight: 0.82, letterSpacing: -4,
          marginBottom: 4,
        }}>
          ZAK<span style={{ fontStyle: 'italic', color: Theme.gold }}>A</span>R
        </div>
        <div style={{
          fontFamily: Theme.display, fontSize: 24, fontStyle: 'italic',
          fontWeight: 300, color: Theme.goldLight, letterSpacing: 0,
          marginBottom: 28,
        }}>
          to remember.
        </div>

        <div style={{
          width: 40, height: 1, background: Theme.gold, marginBottom: 28,
        }}/>

        <div style={{
          fontFamily: Theme.sans, fontSize: 15, lineHeight: 1.6,
          color: Theme.whiteMuted, fontWeight: 300, maxWidth: 300,
        }}>
          교회 공동체가 지나온 모든 시간을,<br/>
          한 권의 사진집처럼.
        </div>
      </div>

      {/* bottom tag */}
      <div style={{
        position: 'absolute', bottom: 120, left: 28,
        fontFamily: Theme.mono, fontSize: 10, letterSpacing: 2,
        color: Theme.whiteGhost, textTransform: 'uppercase',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ width: 4, height: 4, background: Theme.gold, borderRadius: '50%' }} />
          An Archive of Grace
        </div>
      </div>
    </div>
  );
}

// V2 Page 2 — Massive Hebrew word, identity
function V2Meaning() {
  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', overflow: 'hidden' }}>
      {/* backdrop with gold vignette */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(circle at 50% 40%, #1a1410 0%, #000 70%)`,
      }} />

      {/* Huge Hebrew */}
      <div style={{
        position: 'absolute', top: '10%', left: 0, right: 0,
        textAlign: 'center',
      }}>
        <div style={{
          fontFamily: Theme.display, fontSize: 200, fontStyle: 'italic',
          fontWeight: 300, color: Theme.gold, lineHeight: 0.9,
          letterSpacing: -8, opacity: 0.95,
        }}>{'\n'}</div>
      </div>

      {/* Bottom block */}
      <div style={{
        position: 'absolute', bottom: 120, left: 28, right: 28,
      }}>
        <div style={{
          fontFamily: Theme.mono, fontSize: 10, letterSpacing: 4,
          color: Theme.gold, textTransform: 'uppercase', marginBottom: 14,
          opacity: 0.7,
        }}>— זָכַר · ZAKAR · 자카르 —</div>

        <div style={{
          fontFamily: Theme.display, fontSize: 46, fontWeight: 300,
          color: Theme.white, lineHeight: 1.0, letterSpacing: -1.5,
          marginBottom: 18,
        }}>
          <span style={{ fontStyle: 'italic', color: Theme.gold }}>To</span> remember,
          <br/>
          <span style={{ fontStyle: 'italic', color: Theme.gold }}>To</span> keep in memory,
          <br/>
          <span style={{ fontStyle: 'italic', color: Theme.gold }}>To</span> call to mind.
        </div>

        <div style={{
          display: 'flex', alignItems: 'center', gap: 12,
          paddingTop: 16, borderTop: `1px solid ${Theme.gold}`,
        }}>
          <div style={{
            fontFamily: Theme.display, fontSize: 14, fontStyle: 'italic',
            color: Theme.gold,
          }}>v.</div>
          <div style={{
            fontFamily: Theme.sans, fontSize: 12, color: Theme.whiteMuted,
            lineHeight: 1.5, fontWeight: 300, flex: 1,
          }}>
            기록되지 않은 순간은, 기억되지 않는다.
          </div>
        </div>
      </div>

      {/* corner numbers */}
      <div style={{
        position: 'absolute', top: 128, right: 28,
        fontFamily: Theme.display, fontSize: 13, fontStyle: 'italic',
        color: Theme.gold, opacity: 0.6,
      }}>01 / 05</div>
    </div>
  );
}

// V2 Page 3 — AI analysis, immersive
function V2Analysis() {
  const [phase, setPhase] = React.useState(0);
  React.useEffect(() => {
    const t1 = setTimeout(() => setPhase(1), 400);
    const t2 = setTimeout(() => setPhase(2), 1800);
    const loop = setInterval(() => setPhase((p) => p === 2 ? 1 : p === 1 ? 2 : p), 3200);
    return () => { clearTimeout(t1); clearTimeout(t2); clearInterval(loop); };
  }, []);

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', overflow: 'hidden' }}>
      {/* backdrop */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `linear-gradient(180deg, #0b0a0e 0%, #050405 100%)`,
      }} />

      {/* huge display */}
      <div style={{
        position: 'absolute', top: 120, left: 28, right: 28,
      }}>
        <div style={{
          fontFamily: Theme.mono, fontSize: 10, letterSpacing: 3,
          color: Theme.gold, textTransform: 'uppercase', marginBottom: 14,
        }}>FEATURE — 01</div>

        <div style={{
          fontFamily: Theme.display, fontSize: 56, fontWeight: 300,
          color: Theme.white, lineHeight: 0.95, letterSpacing: -2,
          marginBottom: 12,
        }}>
          닮은<br/>
          <span style={{ fontStyle: 'italic', color: Theme.gold }}>순간들을</span>,<br/>
          헤아립니다.
        </div>

        <div style={{
          fontFamily: Theme.sans, fontSize: 12, lineHeight: 1.6,
          color: Theme.whiteMuted, fontWeight: 300, maxWidth: 280,
        }}>
          인공지능이 연속된 셔터, 비슷한 구도, 같은 장면을<br/>
          구분하여 한 묶음으로 정렬합니다.
        </div>
      </div>

      {/* visualization — dense photo wall → groups */}
      <div style={{
        position: 'absolute', bottom: 120, left: 0, right: 0, height: 180,
        overflow: 'hidden',
      }}>
        <div style={{
          position: 'absolute', inset: '0 -20px',
          display: 'grid', gridTemplateColumns: 'repeat(12, 1fr)', gap: 3,
          padding: '0 20px',
        }}>
          {[...Array(36)].map((_, i) => {
            const groupHue = [215, 215, 215, 35, 35, 280, 280, 120, 215, 215, 35, 350][i % 12];
            const inGroup = phase >= 2 && [215, 35, 280].includes(groupHue);
            return (
              <div key={i} style={{
                aspectRatio: '1',
                background: `linear-gradient(135deg, hsl(${groupHue}, 20%, ${22 + (i%4)*3}%), hsl(${groupHue}, 20%, ${12 + (i%4)*2}%))`,
                border: inGroup ? `1px solid ${Theme.gold}` : 'none',
                boxShadow: inGroup ? `0 0 8px ${Theme.goldGlow}` : 'none',
                transition: 'all 600ms',
                transform: phase === 0 ? 'scale(0.8)' : 'scale(1)',
                opacity: phase === 0 ? 0.4 : 1,
              }} />
            );
          })}
        </div>

        {/* scanning beam */}
        {phase === 1 && (
          <div style={{
            position: 'absolute', top: 0, bottom: 0, left: 0, width: 40,
            background: `linear-gradient(90deg, transparent, ${Theme.gold}, transparent)`,
            opacity: 0.5,
            animation: 'v2scan 1.4s cubic-bezier(.4,0,.2,1) forwards',
          }}/>
        )}

        {/* overlay count */}
        {phase >= 2 && (
          <div style={{
            position: 'absolute', top: -16, left: 28, right: 28,
            display: 'flex', justifyContent: 'space-between', alignItems: 'center',
          }}>
            <div style={{
              fontFamily: Theme.mono, fontSize: 10, letterSpacing: 2,
              color: Theme.gold,
            }}>▸ 3 GROUPS — 14 MATCHES</div>
            <div style={{
              fontFamily: Theme.mono, fontSize: 10, letterSpacing: 2,
              color: Theme.whiteFaint,
            }}>36 TOTAL</div>
          </div>
        )}
      </div>

      <style>{`
        @keyframes v2scan { from { left: 0; } to { left: calc(100% - 40px); } }
      `}</style>
    </div>
  );
}

// V2 Page 4 — Gesture, cinematic
function V2Gesture() {
  const [offset, setOffset] = React.useState({ x: 0, y: 0 });
  const [dragging, setDragging] = React.useState(false);
  const [action, setAction] = React.useState(null);
  const [idx, setIdx] = React.useState(0);
  const startRef = React.useRef({ x: 0, y: 0 });

  const onStart = (e) => {
    const p = e.touches ? e.touches[0] : e;
    startRef.current = { x: p.clientX, y: p.clientY };
    setDragging(true);
  };
  const onMove = (e) => {
    if (!dragging) return;
    const p = e.touches ? e.touches[0] : e;
    const dx = p.clientX - startRef.current.x;
    const dy = p.clientY - startRef.current.y;
    setOffset({ x: dx, y: dy });
    if (Math.abs(dy) > Math.abs(dx)) {
      setAction(dy < -30 ? 'trash' : dy > 30 ? 'fav' : null);
    } else {
      setAction(dx < -30 ? 'next' : dx > 30 ? 'prev' : null);
    }
  };
  const onEnd = () => {
    setDragging(false);
    const { x, y } = offset;
    if (Math.abs(y) > 80 || Math.abs(x) > 80) setIdx((idx + 1) % 4);
    setOffset({ x: 0, y: 0 });
    setTimeout(() => setAction(null), 200);
  };

  const hues = [215, 35, 280, 120];
  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', overflow: 'hidden', background: '#000' }}>
      {/* spotlight */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(circle at 50% 55%, rgba(212,182,113,0.14) 0%, transparent 60%)`,
      }}/>

      {/* title */}
      <div style={{ position: 'absolute', top: 120, left: 28, right: 28 }}>
        <div style={{
          fontFamily: Theme.mono, fontSize: 10, letterSpacing: 3,
          color: Theme.gold, marginBottom: 12,
        }}>FEATURE — 02</div>
        <div style={{
          fontFamily: Theme.display, fontSize: 48, fontWeight: 300,
          color: Theme.white, lineHeight: 0.95, letterSpacing: -1.5,
        }}>
          <span style={{ fontStyle: 'italic', color: Theme.gold }}>손끝</span> 하나로<br/>
          정리.
        </div>
      </div>

      {/* gesture diagram — circular compass */}
      <div style={{
        position: 'absolute', top: '45%', left: '50%',
        transform: 'translate(-50%, -50%)',
        width: 320, height: 320,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        {/* concentric rings */}
        {[160, 120, 84].map((r, i) => (
          <div key={i} style={{
            position: 'absolute', width: r*2, height: r*2, borderRadius: '50%',
            border: `1px solid rgba(212,182,113,${0.08 - i*0.02})`,
          }}/>
        ))}

        {/* directional labels */}
        {[
          { dir: 'up', lbl: '削 · TRASH', k: 'trash', style: { top: 10, left: '50%', transform: 'translateX(-50%)' } },
          { dir: 'down', lbl: '★ · FAVOR', k: 'fav', style: { bottom: 10, left: '50%', transform: 'translateX(-50%)' } },
          { dir: 'left', lbl: '◁ NEXT', k: 'next', style: { left: 0, top: '50%', transform: 'translateY(-50%)' } },
          { dir: 'right', lbl: 'PREV ▷', k: 'prev', style: { right: 0, top: '50%', transform: 'translateY(-50%)' } },
        ].map((g) => (
          <div key={g.k} style={{
            position: 'absolute', ...g.style,
            fontFamily: Theme.mono, fontSize: 9, letterSpacing: 2,
            color: action === g.k ? Theme.gold : Theme.whiteFaint,
            textTransform: 'uppercase',
            transition: 'color 200ms',
          }}>{g.lbl}</div>
        ))}

        {/* the card */}
        <div
          onMouseDown={onStart} onMouseMove={onMove} onMouseUp={onEnd} onMouseLeave={() => dragging && onEnd()}
          onTouchStart={onStart} onTouchMove={onMove} onTouchEnd={onEnd}
          style={{
            width: 120, height: 160,
            background: `linear-gradient(135deg, hsl(${hues[idx]}, 20%, 30%), hsl(${hues[idx]}, 20%, 12%))`,
            border: `1px solid ${Theme.gold}`,
            transform: `translate(${offset.x}px, ${offset.y}px) rotate(${offset.x/15}deg)`,
            transition: dragging ? 'none' : 'transform 260ms cubic-bezier(.2,.9,.3,1)',
            cursor: dragging ? 'grabbing' : 'grab',
            position: 'relative', overflow: 'hidden',
            boxShadow: '0 8px 40px rgba(0,0,0,0.7), 0 0 0 6px rgba(0,0,0,0.4)',
            userSelect: 'none', zIndex: 2,
          }}
        >
          <div style={{
            position: 'absolute', top: 6, left: 6, right: 6,
            display: 'flex', justifyContent: 'space-between',
            fontFamily: Theme.mono, fontSize: 7, letterSpacing: 1,
            color: Theme.gold,
          }}>
            <span>IMG · {String(idx+1).padStart(3,'0')}</span>
            <span>●</span>
          </div>
          <div style={{
            position: 'absolute', bottom: 6, left: 6, right: 6,
            fontFamily: Theme.mono, fontSize: 7, letterSpacing: 1,
            color: Theme.whiteFaint,
          }}>2026 · 04 · 21</div>

          {action && (
            <div style={{
              position: 'absolute', inset: 0, background: `${Theme.gold}22`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontFamily: Theme.display, fontSize: 42, fontStyle: 'italic',
              color: Theme.gold,
            }}>
              {action === 'trash' ? '削' : action === 'fav' ? '★' : action === 'next' ? '→' : '←'}
            </div>
          )}
        </div>
      </div>

      {/* hint */}
      <div style={{
        position: 'absolute', bottom: 120, left: 0, right: 0, textAlign: 'center',
        fontFamily: Theme.display, fontSize: 14, fontStyle: 'italic',
        color: Theme.whiteFaint,
      }}>— swipe in any direction —</div>
    </div>
  );
}

// V2 Page 5 — Enter
function V2Begin() {
  const [granted, setGranted] = React.useState(false);
  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', overflow: 'hidden' }}>
      {/* dramatic backdrop */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `
          radial-gradient(ellipse 100% 60% at 50% 100%, rgba(212,182,113,0.3) 0%, transparent 60%),
          linear-gradient(180deg, #000 40%, #0a0806 100%)
        `,
      }}/>

      {/* huge serif script */}
      <div style={{
        position: 'absolute', top: 110, left: 28, right: 28,
      }}>
        <div style={{
          fontFamily: Theme.mono, fontSize: 10, letterSpacing: 3,
          color: Theme.gold, marginBottom: 20,
        }}>— FINALE —</div>

        <div style={{
          fontFamily: Theme.display, fontSize: 80, fontWeight: 300,
          fontStyle: 'italic', color: Theme.white, lineHeight: 0.9,
          letterSpacing: -3, marginBottom: 8,
        }}>
          <span style={{ color: Theme.gold }}>Now,</span><br/>
          Remember.
        </div>

        <div style={{
          fontFamily: Theme.sans, fontSize: 13, lineHeight: 1.6,
          color: Theme.whiteMuted, fontWeight: 300, marginTop: 20,
          maxWidth: 280,
        }}>
          사진 라이브러리 접근 권한이 필요합니다.<br/>
          분석과 정리에만 사용되며, 서버로 전송되지 않습니다.
        </div>
      </div>

      {/* bottom CTA block — aligned with other screens (leave room for back btn) */}
      <div style={{
        position: 'absolute', bottom: 48, left: 24, right: 24,
        display: 'flex', alignItems: 'center', gap: 12,
      }}>
        {/* spacer matches the 52×52 back button from parent */}
        <div style={{ width: 52, height: 52, flexShrink: 0 }} />

        <button onClick={() => setGranted(!granted)} style={{
          flex: 1, height: 52,
          background: goldGradient,
          border: 'none', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12,
        }}>
          <span style={{
            fontFamily: Theme.sans, fontSize: 12, fontWeight: 700,
            letterSpacing: 4, color: Theme.obsidian, textTransform: 'uppercase',
          }}>{granted ? 'Enter' : 'Allow Access'}</span>
          <svg width="16" height="10" viewBox="0 0 16 10" fill="none">
            <path d="M1 5h13M10 1l4 4-4 4" stroke={Theme.obsidian} strokeWidth="1.4" strokeLinecap="round"/>
          </svg>
        </button>
      </div>

      {/* footer tag — sits above the CTA row */}
      <div style={{
        position: 'absolute', bottom: 116, left: 0, right: 0,
        display: 'flex', alignItems: 'center', gap: 8,
        fontFamily: Theme.mono, fontSize: 9, letterSpacing: 2,
        color: Theme.whiteGhost, textTransform: 'uppercase',
        justifyContent: 'center',
      }}>
        <svg width="10" height="10" viewBox="0 0 10 10" fill="none">
          <path d="M5 1L1 3v3c0 2 4 3 4 3s4-1 4-3V3L5 1z" stroke="currentColor" strokeWidth="0.8"/>
        </svg>
        On-device · Never uploaded
      </div>
    </div>
  );
}

Object.assign(window, { OnboardingV2 });
