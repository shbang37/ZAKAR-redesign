// Home V2 — SANCTUM
// Bold, cinematic. Hero recent photo dominant, dramatic serif headlines,
// gold-tinted cards, magazine-spread feel.

function HomeV2() {
  return (
    <div style={{
      width: '100%', height: '100%',
      background: '#000',
      color: Theme.white, fontFamily: Theme.sans,
      overflowY: 'auto', overflowX: 'hidden',
    }}>
      {/* Header bar */}
      <div style={{
        position: 'sticky', top: 0, zIndex: 10,
        padding: '54px 20px 12px',
        background: 'linear-gradient(180deg, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0.6) 100%)',
        backdropFilter: 'blur(12px)',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{
            width: 28, height: 28, borderRadius: '50%',
            border: `1px solid ${Theme.gold}`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: Theme.display, fontSize: 14, fontStyle: 'italic',
            color: Theme.gold,
          }}>Z</div>
          <div>
            <div style={{
              fontFamily: Theme.sans, fontSize: 14, fontWeight: 600,
              letterSpacing: 4, color: Theme.white,
            }}>ZAKAR</div>
            <div style={{
              fontFamily: Theme.display, fontSize: 10, fontStyle: 'italic',
              color: Theme.gold, letterSpacing: 0.5, marginTop: -1,
            }}>자카르</div>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <IconBtn icon="search" />
          <IconBtn icon="dots" />
        </div>
      </div>

      <div style={{ paddingBottom: 110 }}>

        {/* HERO — Most recent */}
        <V2Hero />

        {/* Hook row — 3 primary actions */}
        <div style={{
          padding: '24px 20px 28px',
          display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10,
        }}>
          {[
            { n: '42', l: 'Similar', s: 'Groups', accent: true },
            { n: '2,847', l: 'Photos', s: 'All' },
            { n: '38', l: 'Albums', s: 'Curated' },
          ].map((stat, i) => (
            <div key={i} style={{
              padding: '16px 14px',
              background: stat.accent ? `linear-gradient(145deg, rgba(212,182,113,0.14), rgba(212,182,113,0.04))` : 'rgba(255,255,255,0.03)',
              border: stat.accent ? `1px solid ${Theme.gold}` : hairlineWhite,
              position: 'relative', overflow: 'hidden',
            }}>
              {stat.accent && (
                <div style={{
                  position: 'absolute', top: 8, right: 8,
                  width: 6, height: 6, borderRadius: '50%', background: Theme.gold,
                  boxShadow: `0 0 8px ${Theme.gold}`,
                }}/>
              )}
              <div style={{
                fontFamily: Theme.display, fontSize: 34, fontWeight: 300,
                color: stat.accent ? Theme.gold : Theme.white,
                lineHeight: 1, letterSpacing: -1, marginBottom: 6,
              }}>{stat.n}</div>
              <div style={{
                fontFamily: Theme.sans, fontSize: 11, fontWeight: 600,
                color: Theme.white, letterSpacing: 2,
                textTransform: 'uppercase',
              }}>{stat.l}</div>
              <div style={{
                fontFamily: Theme.display, fontSize: 10, fontStyle: 'italic',
                color: stat.accent ? Theme.goldLight : Theme.whiteFaint,
                marginTop: 1,
              }}>{stat.s}</div>
            </div>
          ))}
        </div>

        {/* Big feature card — Similar groups */}
        <div style={{ padding: '0 20px 28px' }}>
          <SimilarGroupsFeature />
        </div>

        {/* Editorial headline */}
        <div style={{ padding: '12px 20px 20px' }}>
          <div style={{
            fontFamily: Theme.mono, fontSize: 10, letterSpacing: 3,
            color: Theme.gold, marginBottom: 10, textTransform: 'uppercase',
          }}>— The Archive —</div>
          <div style={{
            fontFamily: Theme.display, fontSize: 44, fontWeight: 300,
            color: Theme.white, lineHeight: 0.95, letterSpacing: -1.5,
          }}>
            <span style={{ fontStyle: 'italic', color: Theme.gold }}>Every</span><br/>
            moment,<br/>
            kept.
          </div>
        </div>

        {/* Collections grid — magazine */}
        <div style={{ padding: '0 20px 28px' }}>
          <CollectionsGrid />
        </div>

        {/* Monthly strip */}
        <div style={{ padding: '8px 0 24px' }}>
          <div style={{
            padding: '0 20px', display: 'flex', alignItems: 'baseline',
            justifyContent: 'space-between', marginBottom: 14,
          }}>
            <div>
              <div style={{
                fontFamily: Theme.mono, fontSize: 10, letterSpacing: 3,
                color: Theme.gold, marginBottom: 4,
              }}>CHRONICLE</div>
              <div style={{
                fontFamily: Theme.display, fontSize: 22, color: Theme.white,
                fontWeight: 400,
              }}>By month</div>
            </div>
            <div style={{
              fontFamily: Theme.display, fontSize: 12, fontStyle: 'italic',
              color: Theme.gold,
            }}>See all →</div>
          </div>

          <div style={{
            display: 'flex', gap: 10, padding: '0 20px', overflowX: 'auto',
          }}>
            {[
              { m: 'APR', y: '2026', n: 284, hue: 25, active: true },
              { m: 'MAR', y: '2026', n: 412, hue: 215 },
              { m: 'FEB', y: '2026', n: 356, hue: 280 },
              { m: 'JAN', y: '2026', n: 298, hue: 120 },
              { m: 'DEC', y: '2025', n: 524, hue: 350 },
            ].map((mo, i) => <MonthCard key={i} {...mo} />)}
          </div>
        </div>

        {/* Footer */}
        <div style={{
          padding: '32px 20px 12px', textAlign: 'center',
        }}>
          <GoldDivider width={28} />
          <div style={{
            marginTop: 14,
            fontFamily: Theme.display, fontSize: 13, fontStyle: 'italic',
            color: Theme.goldLight, letterSpacing: 1,
          }}>"모든 은혜를 기억합니다"</div>
          <div style={{
            marginTop: 6,
            fontFamily: Theme.mono, fontSize: 9, letterSpacing: 2,
            color: Theme.whiteGhost, textTransform: 'uppercase',
          }}>ZAKAR · EST. MMXXVI</div>
        </div>
      </div>

      {/* Tab bar */}
      <V2TabBar active="home" />
    </div>
  );
}

function IconBtn({ icon }) {
  return (
    <div style={{
      width: 36, height: 36, borderRadius: '50%',
      border: hairlineGold,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      background: 'rgba(255,255,255,0.03)',
    }}>
      {icon === 'search' ? (
        <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
          <circle cx="6" cy="6" r="4.5" stroke={Theme.gold} strokeWidth="1"/>
          <path d="M10 10l3 3" stroke={Theme.gold} strokeWidth="1" strokeLinecap="round"/>
        </svg>
      ) : (
        <svg width="14" height="4" viewBox="0 0 14 4" fill={Theme.gold}>
          <circle cx="2" cy="2" r="1.4"/>
          <circle cx="7" cy="2" r="1.4"/>
          <circle cx="12" cy="2" r="1.4"/>
        </svg>
      )}
    </div>
  );
}

function V2Hero() {
  return (
    <div style={{
      position: 'relative', margin: '0 20px', aspectRatio: '3/4',
      overflow: 'hidden',
      boxShadow: '0 20px 60px rgba(0,0,0,0.6)',
    }}>
      {/* photo */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `linear-gradient(160deg, hsl(28, 22%, 32%) 0%, hsl(28, 22%, 12%) 60%, #0a0806 100%)`,
      }}/>
      {/* light cone */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse 60% 45% at 50% 35%, rgba(212,182,113,0.28) 0%, transparent 65%)`,
      }}/>
      {/* figure silhouettes (abstract) */}
      <div style={{
        position: 'absolute', bottom: '12%', left: '15%', right: '15%',
        height: '35%',
        background: `linear-gradient(180deg, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0.8) 100%)`,
        clipPath: 'polygon(10% 100%, 5% 40%, 20% 30%, 35% 45%, 50% 25%, 65% 50%, 80% 35%, 95% 55%, 90% 100%)',
      }}/>
      {/* grain */}
      <div style={{
        position: 'absolute', inset: 0,
        backgroundImage: `url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='100' height='100'><filter id='n'><feTurbulence baseFrequency='1' numOctaves='2' stitchTiles='stitch'/></filter><rect width='100%' height='100%' filter='url(%23n)' opacity='0.4'/></svg>")`,
        mixBlendMode: 'overlay', opacity: 0.5,
      }}/>
      {/* vignette */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse at 50% 50%, transparent 30%, rgba(0,0,0,0.7) 100%)`,
      }}/>

      {/* top overlay */}
      <div style={{
        position: 'absolute', top: 16, left: 16, right: 16,
        display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start',
      }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 6,
          padding: '5px 10px',
          background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(8px)',
          border: hairlineGold,
        }}>
          <div style={{ width: 5, height: 5, borderRadius: '50%', background: Theme.gold, boxShadow: `0 0 6px ${Theme.gold}` }}/>
          <div style={{
            fontFamily: Theme.mono, fontSize: 9, letterSpacing: 2,
            color: Theme.gold,
          }}>JUST NOW · 2 MIN AGO</div>
        </div>
        <div style={{
          fontFamily: Theme.mono, fontSize: 9, color: Theme.whiteMuted,
          letterSpacing: 1.5, textAlign: 'right', lineHeight: 1.5,
        }}>
          N° 2,847<br/>
          <span style={{ color: Theme.gold }}>04 · 21 · 26</span>
        </div>
      </div>

      {/* bottom overlay */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        padding: 20,
      }}>
        <div style={{
          fontFamily: Theme.mono, fontSize: 9, letterSpacing: 3,
          color: Theme.gold, marginBottom: 8, textTransform: 'uppercase',
        }}>— Latest Plate —</div>
        <div style={{
          fontFamily: Theme.display, fontSize: 36, fontWeight: 300,
          color: Theme.white, lineHeight: 0.95, letterSpacing: -1,
          marginBottom: 14,
        }}>
          <span style={{ fontStyle: 'italic', color: Theme.gold }}>Begin</span><br/>
          curating.
        </div>

        <button style={{
          width: '100%', padding: '14px 18px',
          background: goldGradient, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          cursor: 'pointer',
        }}>
          <span style={{
            fontFamily: Theme.sans, fontSize: 11, fontWeight: 700,
            letterSpacing: 3, color: Theme.obsidian, textTransform: 'uppercase',
          }}>Sort this photo now</span>
          <svg width="16" height="10" viewBox="0 0 16 10" fill="none">
            <path d="M1 5h13M10 1l4 4-4 4" stroke={Theme.obsidian} strokeWidth="1.4" strokeLinecap="round"/>
          </svg>
        </button>
      </div>
    </div>
  );
}

function SimilarGroupsFeature() {
  return (
    <div style={{
      position: 'relative',
      background: `linear-gradient(135deg, rgba(212,182,113,0.08) 0%, rgba(0,0,0,0.4) 100%)`,
      border: hairlineGold,
      padding: 20, overflow: 'hidden',
    }}>
      {/* corner flourish */}
      <div style={{
        position: 'absolute', top: 0, right: 0, width: 80, height: 80,
        background: `radial-gradient(circle at 100% 0%, ${Theme.goldGlow}, transparent 70%)`,
        pointerEvents: 'none',
      }}/>

      <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 16 }}>
        <div>
          <div style={{
            fontFamily: Theme.mono, fontSize: 10, letterSpacing: 3,
            color: Theme.gold, marginBottom: 6, textTransform: 'uppercase',
          }}>AI · Similar Groups</div>
          <div style={{
            fontFamily: Theme.display, fontSize: 28, fontWeight: 300,
            color: Theme.white, lineHeight: 1, letterSpacing: -0.5,
          }}>
            <span style={{ fontStyle: 'italic', color: Theme.gold }}>42</span> groups found
          </div>
        </div>
        <div style={{
          fontFamily: Theme.display, fontSize: 11, fontStyle: 'italic',
          color: Theme.gold,
        }}>Review →</div>
      </div>

      {/* group previews */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        {[
          { ttl: 'Sunday Worship', sub: '주일예배 · 04.21', n: 6, hue: 215 },
          { ttl: 'Easter Retreat', sub: '부활절 수련회', n: 8, hue: 35 },
          { ttl: 'Communion Table', sub: '성찬식', n: 4, hue: 280 },
        ].map((g, i) => (
          <div key={i} style={{
            display: 'flex', alignItems: 'center', gap: 12,
            padding: '10px 12px',
            background: 'rgba(0,0,0,0.3)',
            border: hairlineWhite,
          }}>
            {/* mini photos */}
            <div style={{ display: 'flex', gap: 2 }}>
              {[0,1,2].map(j => (
                <div key={j} style={{
                  width: 36, height: 36,
                  background: `linear-gradient(135deg, hsl(${g.hue}, 20%, ${26+j*3}%), hsl(${g.hue}, 20%, ${14+j*2}%))`,
                  border: j === 0 ? `1px solid ${Theme.gold}` : hairlineWhite,
                }}/>
              ))}
            </div>
            <div style={{ flex: 1 }}>
              <div style={{
                fontFamily: Theme.display, fontSize: 15, color: Theme.white,
                fontWeight: 400, lineHeight: 1.1, marginBottom: 2,
              }}>{g.ttl}</div>
              <div style={{
                fontFamily: Theme.sans, fontSize: 10, color: Theme.whiteFaint,
                letterSpacing: 0.5,
              }}>{g.sub}</div>
            </div>
            <div style={{
              fontFamily: Theme.mono, fontSize: 10, color: Theme.gold,
              letterSpacing: 1, padding: '3px 8px',
              border: hairlineGold,
            }}>× {g.n}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

function CollectionsGrid() {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
      {/* big card */}
      <div style={{
        gridColumn: '1 / -1',
        position: 'relative', aspectRatio: '16/7',
        background: `linear-gradient(120deg, hsl(215, 18%, 24%) 0%, hsl(215, 18%, 10%) 100%)`,
        padding: 18, overflow: 'hidden',
      }}>
        <div style={{
          position: 'absolute', right: -20, bottom: -20,
          fontFamily: Theme.display, fontSize: 140, fontStyle: 'italic',
          color: Theme.gold, opacity: 0.15, lineHeight: 0.8,
        }}>2,847</div>
        <div style={{
          fontFamily: Theme.mono, fontSize: 9, letterSpacing: 2,
          color: Theme.gold, marginBottom: 6,
        }}>01 · ALL PHOTOS</div>
        <div style={{
          fontFamily: Theme.display, fontSize: 26, fontWeight: 300,
          color: Theme.white, lineHeight: 1,
        }}>
          Every <span style={{ fontStyle: 'italic', color: Theme.gold }}>photograph</span>
        </div>
        <div style={{
          fontFamily: Theme.sans, fontSize: 11, color: Theme.whiteMuted,
          marginTop: 4,
        }}>모든 사진을 한 곳에서</div>
      </div>

      {/* smaller cards */}
      {[
        { n: '02', t: 'Albums', sub: '앨범 · 38', hue: 280 },
        { n: '03', t: 'Archive', sub: 'NAS · Drive', hue: 120 },
      ].map((c, i) => (
        <div key={i} style={{
          aspectRatio: '1/1',
          background: `linear-gradient(135deg, hsl(${c.hue}, 12%, 18%), hsl(${c.hue}, 12%, 8%))`,
          padding: 16, position: 'relative', overflow: 'hidden',
        }}>
          <div style={{
            fontFamily: Theme.mono, fontSize: 9, letterSpacing: 2,
            color: Theme.gold, marginBottom: 6,
          }}>{c.n}</div>
          <div style={{
            fontFamily: Theme.display, fontSize: 22, fontWeight: 300,
            color: Theme.white, lineHeight: 1, marginBottom: 4,
          }}>{c.t}</div>
          <div style={{
            fontFamily: Theme.display, fontSize: 11, fontStyle: 'italic',
            color: Theme.goldLight,
          }}>{c.sub}</div>
          <div style={{
            position: 'absolute', bottom: 14, right: 14,
            fontFamily: Theme.display, fontSize: 20, fontStyle: 'italic',
            color: Theme.gold,
          }}>→</div>
        </div>
      ))}
    </div>
  );
}

function MonthCard({ m, y, n, hue, active }) {
  return (
    <div style={{
      minWidth: 110, aspectRatio: '3/4',
      background: active ? `linear-gradient(180deg, hsl(${hue}, 18%, 24%), hsl(${hue}, 18%, 10%))` : 'rgba(255,255,255,0.03)',
      border: active ? `1px solid ${Theme.gold}` : hairlineWhite,
      padding: 14, display: 'flex', flexDirection: 'column',
      justifyContent: 'space-between',
      position: 'relative', overflow: 'hidden',
    }}>
      {active && (
        <div style={{
          position: 'absolute', top: 8, right: 8,
          width: 5, height: 5, borderRadius: '50%', background: Theme.gold,
          boxShadow: `0 0 6px ${Theme.gold}`,
        }}/>
      )}
      <div>
        <div style={{
          fontFamily: Theme.display, fontSize: 40, fontWeight: 300,
          fontStyle: 'italic', color: active ? Theme.gold : Theme.white,
          lineHeight: 0.9, marginBottom: 2, letterSpacing: -1,
        }}>{m}</div>
        <div style={{
          fontFamily: Theme.mono, fontSize: 9, letterSpacing: 2,
          color: active ? Theme.goldLight : Theme.whiteFaint,
        }}>{y}</div>
      </div>
      <div>
        <div style={{
          fontFamily: Theme.display, fontSize: 22, fontWeight: 300,
          color: Theme.white, lineHeight: 1,
        }}>{n}</div>
        <div style={{
          fontFamily: Theme.sans, fontSize: 9, color: Theme.whiteFaint,
          letterSpacing: 1, textTransform: 'uppercase', marginTop: 2,
        }}>photos</div>
      </div>
    </div>
  );
}

function V2TabBar({ active }) {
  const tabs = [
    { k: 'home', lbl: 'HOME', glyph: '◐' },
    { k: 'photos', lbl: 'PHOTOS', glyph: '▣' },
    { k: 'albums', lbl: 'ALBUMS', glyph: '❖' },
    { k: 'archive', lbl: 'ARCHIVE', glyph: '⟁' },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0,
      background: 'rgba(0,0,0,0.85)',
      backdropFilter: 'blur(24px)',
      borderTop: hairlineGold,
      padding: '14px 16px 30px',
      display: 'flex', justifyContent: 'space-around', alignItems: 'center',
    }}>
      {tabs.map((t) => {
        const isActive = active === t.k;
        return (
          <div key={t.k} style={{
            textAlign: 'center', position: 'relative',
            padding: '6px 14px',
            background: isActive ? `${Theme.goldGlow}` : 'transparent',
            border: isActive ? `1px solid ${Theme.gold}` : `1px solid transparent`,
          }}>
            <div style={{
              fontSize: 14, color: isActive ? Theme.gold : Theme.whiteFaint,
              marginBottom: 2, lineHeight: 1,
            }}>{t.glyph}</div>
            <div style={{
              fontFamily: Theme.mono, fontSize: 8, letterSpacing: 2,
              color: isActive ? Theme.gold : Theme.whiteFaint,
            }}>{t.lbl}</div>
          </div>
        );
      })}
    </div>
  );
}

Object.assign(window, { HomeV2, V2TabBar });
