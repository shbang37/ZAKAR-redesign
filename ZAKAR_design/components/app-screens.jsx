// Sanctum app screens — Photos grid, Similar Review, Album Detail
// Reuses Theme, goldGradient, hairlines from theme.jsx

// ─────────────────────────────────────────────────────────
// 1. PHOTOS — all photos grid (masonry-ish, editorial)
// ─────────────────────────────────────────────────────────
function PhotosView() {
  const [filter, setFilter] = React.useState('all');

  // generate a photo set
  const photos = React.useMemo(() => {
    const hues = [25, 25, 215, 280, 120, 35, 215, 350, 25, 280, 215, 35, 120, 350, 25, 215, 280, 35, 25, 215, 120, 280, 35, 215, 25, 280, 35, 120];
    return hues.map((h, i) => ({ id: i, hue: h, light: 18 + (i%5)*3 }));
  }, []);

  return (
    <div style={{
      width: '100%', height: '100%', background: '#000', color: Theme.white,
      fontFamily: Theme.sans, overflowY: 'auto', overflowX: 'hidden',
    }}>
      {/* Header */}
      <div style={{
        position: 'sticky', top: 0, zIndex: 10,
        padding: '54px 20px 12px',
        background: 'linear-gradient(180deg, rgba(0,0,0,0.95) 70%, rgba(0,0,0,0.6) 100%)',
        backdropFilter: 'blur(12px)',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={{
              width: 28, height: 28, border: `1px solid ${Theme.gold}`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontFamily: Theme.display, fontSize: 14, fontStyle: 'italic', color: Theme.gold,
            }}>←</div>
            <div>
              <div style={{
                fontFamily: Theme.mono, fontSize: 9, letterSpacing: 3,
                color: Theme.gold, textTransform: 'uppercase',
              }}>02 · PHOTOS</div>
              <div style={{
                fontFamily: Theme.display, fontSize: 22, fontWeight: 400,
                color: Theme.white, letterSpacing: -0.5, marginTop: 2,
              }}>All <span style={{ fontStyle: 'italic', color: Theme.gold }}>photographs</span></div>
            </div>
          </div>
          <div style={{ fontFamily: Theme.mono, fontSize: 10, letterSpacing: 1.5, color: Theme.whiteMuted }}>
            {photos.length} / 2,847
          </div>
        </div>

        {/* filter pills */}
        <div style={{ display: 'flex', gap: 6, overflowX: 'auto' }}>
          {[
            { k: 'all', lbl: 'ALL', sub: '전체' },
            { k: 'recent', lbl: 'RECENT', sub: '최근' },
            { k: 'favorites', lbl: 'FAV', sub: '즐겨찾기' },
            { k: 'archived', lbl: 'KEPT', sub: '보관' },
          ].map((f) => (
            <div key={f.k} onClick={() => setFilter(f.k)} style={{
              padding: '6px 12px',
              border: filter === f.k ? `1px solid ${Theme.gold}` : hairlineWhite,
              background: filter === f.k ? Theme.goldGlow : 'transparent',
              cursor: 'pointer', flexShrink: 0,
            }}>
              <div style={{
                fontFamily: Theme.sans, fontSize: 10, fontWeight: 600, letterSpacing: 2,
                color: filter === f.k ? Theme.gold : Theme.whiteMuted,
              }}>{f.lbl}</div>
              <div style={{
                fontFamily: Theme.display, fontSize: 10, fontStyle: 'italic',
                color: filter === f.k ? Theme.goldLight : Theme.whiteFaint, marginTop: -1,
              }}>{f.sub}</div>
            </div>
          ))}
        </div>
      </div>

      {/* grid */}
      <div style={{ padding: '16px 12px 110px' }}>
        {/* section label */}
        <div style={{
          display: 'flex', alignItems: 'baseline', gap: 10, padding: '0 8px 10px',
        }}>
          <div style={{
            fontFamily: Theme.display, fontSize: 18, fontStyle: 'italic',
            color: Theme.gold,
          }}>Today</div>
          <div style={{ flex: 1, height: 1, background: `linear-gradient(90deg, ${Theme.gold}22, transparent)` }}/>
          <div style={{ fontFamily: Theme.mono, fontSize: 9, color: Theme.whiteFaint, letterSpacing: 1.5 }}>04 · 21</div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 3, marginBottom: 24 }}>
          {photos.slice(0, 9).map((p, i) => <PhotoCell key={i} {...p} featured={i===0} />)}
        </div>

        {/* older */}
        <div style={{
          display: 'flex', alignItems: 'baseline', gap: 10, padding: '0 8px 10px',
        }}>
          <div style={{
            fontFamily: Theme.display, fontSize: 18, fontStyle: 'italic',
            color: Theme.gold,
          }}>Yesterday</div>
          <div style={{ flex: 1, height: 1, background: `linear-gradient(90deg, ${Theme.gold}22, transparent)` }}/>
          <div style={{ fontFamily: Theme.mono, fontSize: 9, color: Theme.whiteFaint, letterSpacing: 1.5 }}>04 · 20</div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 3, marginBottom: 24 }}>
          {photos.slice(9, 18).map((p, i) => <PhotoCell key={i} {...p} />)}
        </div>

        <div style={{
          display: 'flex', alignItems: 'baseline', gap: 10, padding: '0 8px 10px',
        }}>
          <div style={{
            fontFamily: Theme.display, fontSize: 18, fontStyle: 'italic',
            color: Theme.gold,
          }}>This week</div>
          <div style={{ flex: 1, height: 1, background: `linear-gradient(90deg, ${Theme.gold}22, transparent)` }}/>
          <div style={{ fontFamily: Theme.mono, fontSize: 9, color: Theme.whiteFaint, letterSpacing: 1.5 }}>04 · 15–19</div>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 3 }}>
          {photos.slice(18).map((p, i) => <PhotoCell key={i} {...p} />)}
        </div>
      </div>

      <V2TabBar active="photos" />
    </div>
  );
}

function PhotoCell({ hue, light, featured }) {
  return (
    <div style={{
      aspectRatio: '1',
      background: `linear-gradient(135deg, hsl(${hue}, 16%, ${light+6}%) 0%, hsl(${hue}, 16%, ${light-2}%) 100%)`,
      border: featured ? `1px solid ${Theme.gold}` : 'none',
      boxShadow: featured ? `0 0 16px ${Theme.goldGlow}` : 'none',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* subtle texture */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse at 30% 30%, rgba(255,255,255,0.04) 0%, transparent 60%)`,
      }}/>
      {featured && (
        <div style={{
          position: 'absolute', top: 6, right: 6,
          width: 5, height: 5, background: Theme.gold,
          boxShadow: `0 0 6px ${Theme.gold}`,
        }}/>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────
// 2. SIMILAR REVIEW — AI-grouped photos, keep/remove
// ─────────────────────────────────────────────────────────
function SimilarReview() {
  const [selected, setSelected] = React.useState(new Set([0, 2]));
  const photos = [
    { hue: 215, light: 22 },
    { hue: 215, light: 26, keeper: true },
    { hue: 215, light: 20 },
    { hue: 215, light: 18 },
    { hue: 215, light: 24 },
  ];
  const toggle = (i) => {
    const s = new Set(selected);
    s.has(i) ? s.delete(i) : s.add(i);
    setSelected(s);
  };

  return (
    <div style={{
      width: '100%', height: '100%', background: '#000',
      color: Theme.white, fontFamily: Theme.sans,
      overflowY: 'auto', overflowX: 'hidden',
    }}>
      {/* Header */}
      <div style={{ padding: '54px 20px 16px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20 }}>
          <div style={{
            width: 32, height: 32, border: hairlineGold,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: Theme.gold,
          }}>
            <svg width="10" height="16" viewBox="0 0 10 16" fill="none">
              <path d="M8 2L2 8l6 6" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
            </svg>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontFamily: Theme.mono, fontSize: 9, letterSpacing: 3, color: Theme.gold }}>GROUP · 01 / 42</div>
            <div style={{ fontFamily: Theme.display, fontSize: 12, fontStyle: 'italic', color: Theme.whiteMuted, marginTop: 2 }}>주일예배 · 04.21</div>
          </div>
          <div style={{
            width: 32, height: 32, border: hairlineGold,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: Theme.gold, fontSize: 10,
          }}>•••</div>
        </div>

        {/* progress */}
        <div style={{ display: 'flex', gap: 3, marginBottom: 20 }}>
          {[...Array(42)].map((_, i) => (
            <div key={i} style={{
              flex: 1, height: 2,
              background: i === 0 ? Theme.gold : i < 0 ? Theme.goldDeep : 'rgba(255,255,255,0.08)',
            }}/>
          ))}
        </div>
      </div>

      {/* Hero featured photo */}
      <div style={{ padding: '0 20px 20px' }}>
        <div style={{
          position: 'relative', aspectRatio: '4/5',
          background: `linear-gradient(160deg, hsl(215, 20%, 32%), hsl(215, 20%, 12%))`,
          border: `1px solid ${Theme.gold}`,
          overflow: 'hidden',
        }}>
          <div style={{
            position: 'absolute', inset: 0,
            background: `radial-gradient(ellipse at 50% 30%, rgba(212,182,113,0.24) 0%, transparent 60%)`,
          }}/>

          {/* top badges */}
          <div style={{
            position: 'absolute', top: 14, left: 14, right: 14,
            display: 'flex', justifyContent: 'space-between',
          }}>
            <div style={{
              padding: '5px 10px',
              background: goldGradient,
              fontFamily: Theme.mono, fontSize: 9, fontWeight: 700,
              letterSpacing: 2, color: Theme.obsidian,
            }}>★ KEEPER · AI PICK</div>
            <div style={{
              padding: '5px 10px',
              background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(8px)',
              border: hairlineGold,
              fontFamily: Theme.mono, fontSize: 9, letterSpacing: 1.5,
              color: Theme.gold,
            }}>1 / 5</div>
          </div>

          {/* silhouette hint */}
          <div style={{
            position: 'absolute', bottom: '18%', left: '20%', right: '20%', height: '40%',
            background: `linear-gradient(180deg, rgba(0,0,0,0.2), rgba(0,0,0,0.7))`,
            clipPath: 'polygon(10% 100%, 5% 50%, 30% 35%, 50% 20%, 70% 38%, 95% 55%, 90% 100%)',
          }}/>

          {/* bottom meta */}
          <div style={{
            position: 'absolute', bottom: 0, left: 0, right: 0,
            padding: 18,
            background: 'linear-gradient(180deg, transparent, rgba(0,0,0,0.85))',
          }}>
            <div style={{
              fontFamily: Theme.mono, fontSize: 9, letterSpacing: 2,
              color: Theme.goldLight, marginBottom: 6,
            }}>IMG · 2,847 · f/2.8 · 1/160s</div>
            <div style={{
              fontFamily: Theme.display, fontSize: 26, fontWeight: 300,
              color: Theme.white, lineHeight: 1,
            }}>
              <span style={{ fontStyle: 'italic', color: Theme.gold }}>Similar</span> moments
            </div>
            <div style={{
              fontFamily: Theme.sans, fontSize: 11, color: Theme.whiteMuted, marginTop: 4,
            }}>AI가 5장을 한 묶음으로 찾았습니다</div>
          </div>
        </div>
      </div>

      {/* thumbnail strip — checkboxes */}
      <div style={{ padding: '0 20px 20px' }}>
        <div style={{
          display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 10,
        }}>
          <div style={{ fontFamily: Theme.mono, fontSize: 10, letterSpacing: 2, color: Theme.gold }}>
            ▸ SELECT TO KEEP
          </div>
          <div style={{ fontFamily: Theme.display, fontSize: 12, fontStyle: 'italic', color: Theme.whiteMuted }}>
            {selected.size} / 5 selected
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: 6 }}>
          {photos.map((p, i) => {
            const isSel = selected.has(i);
            return (
              <div key={i} onClick={() => toggle(i)} style={{
                aspectRatio: '2/3',
                background: `linear-gradient(135deg, hsl(${p.hue}, 18%, ${p.light+4}%), hsl(${p.hue}, 18%, ${p.light-4}%))`,
                border: isSel ? `1.5px solid ${Theme.gold}` : '1px solid rgba(255,255,255,0.12)',
                position: 'relative', cursor: 'pointer', overflow: 'hidden',
                opacity: isSel ? 1 : 0.55,
                transition: 'all 180ms',
              }}>
                {p.keeper && (
                  <div style={{
                    position: 'absolute', top: 4, left: 4,
                    fontFamily: Theme.mono, fontSize: 8, color: Theme.gold,
                  }}>★</div>
                )}
                <div style={{
                  position: 'absolute', bottom: 4, right: 4,
                  width: 14, height: 14,
                  border: `1px solid ${isSel ? Theme.gold : Theme.whiteFaint}`,
                  background: isSel ? Theme.gold : 'rgba(0,0,0,0.4)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  {isSel && (
                    <svg width="8" height="8" viewBox="0 0 8 8" fill="none">
                      <path d="M1 4l2 2 4-5" stroke={Theme.obsidian} strokeWidth="1.5" strokeLinecap="round"/>
                    </svg>
                  )}
                </div>
                <div style={{
                  position: 'absolute', bottom: 4, left: 4,
                  fontFamily: Theme.mono, fontSize: 7, color: Theme.whiteMuted, letterSpacing: 0.5,
                }}>{String(i+1).padStart(2,'0')}</div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Stats block */}
      <div style={{
        margin: '0 20px 24px', padding: '16px 18px',
        background: `linear-gradient(135deg, rgba(212,182,113,0.08), rgba(0,0,0,0.4))`,
        border: hairlineGold,
        display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 0,
      }}>
        <div style={{ borderRight: hairlineWhite, paddingRight: 12 }}>
          <div style={{ fontFamily: Theme.display, fontSize: 22, fontWeight: 300, color: Theme.gold, lineHeight: 1 }}>
            <span style={{ fontStyle: 'italic' }}>{selected.size}</span>
          </div>
          <div style={{ fontFamily: Theme.sans, fontSize: 9, fontWeight: 600, color: Theme.white, letterSpacing: 1.5, marginTop: 4, textTransform: 'uppercase' }}>Keep</div>
        </div>
        <div style={{ borderRight: hairlineWhite, paddingLeft: 12, paddingRight: 12 }}>
          <div style={{ fontFamily: Theme.display, fontSize: 22, fontWeight: 300, color: Theme.ember, lineHeight: 1 }}>
            <span style={{ fontStyle: 'italic' }}>{5 - selected.size}</span>
          </div>
          <div style={{ fontFamily: Theme.sans, fontSize: 9, fontWeight: 600, color: Theme.white, letterSpacing: 1.5, marginTop: 4, textTransform: 'uppercase' }}>Remove</div>
        </div>
        <div style={{ paddingLeft: 12 }}>
          <div style={{ fontFamily: Theme.display, fontSize: 22, fontWeight: 300, color: Theme.white, lineHeight: 1 }}>
            <span style={{ fontStyle: 'italic' }}>12MB</span>
          </div>
          <div style={{ fontFamily: Theme.sans, fontSize: 9, fontWeight: 600, color: Theme.white, letterSpacing: 1.5, marginTop: 4, textTransform: 'uppercase' }}>Saved</div>
        </div>
      </div>

      {/* Bottom CTAs */}
      <div style={{
        position: 'absolute', bottom: 34, left: 20, right: 20,
        display: 'flex', gap: 10,
      }}>
        <button style={{
          flex: 1, padding: '14px',
          background: 'transparent', border: hairlineGold, cursor: 'pointer',
          fontFamily: Theme.sans, fontSize: 11, fontWeight: 600,
          letterSpacing: 3, color: Theme.gold, textTransform: 'uppercase',
        }}>SKIP GROUP</button>
        <button style={{
          flex: 2, padding: '14px',
          background: goldGradient, border: 'none', cursor: 'pointer',
          fontFamily: Theme.sans, fontSize: 11, fontWeight: 700,
          letterSpacing: 3, color: Theme.obsidian, textTransform: 'uppercase',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
        }}>
          <span>Confirm · Next</span>
          <svg width="14" height="10" viewBox="0 0 14 10" fill="none">
            <path d="M1 5h11M9 1l4 4-4 4" stroke={Theme.obsidian} strokeWidth="1.4" strokeLinecap="round"/>
          </svg>
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────
// 3. ALBUM DETAIL — hero cover + photo grid
// ─────────────────────────────────────────────────────────
function AlbumDetail() {
  const hues = [25, 25, 30, 25, 35, 30, 25, 35, 30, 25, 30, 35, 25, 30, 30];
  return (
    <div style={{
      width: '100%', height: '100%', background: '#000',
      color: Theme.white, fontFamily: Theme.sans,
      overflowY: 'auto', overflowX: 'hidden',
    }}>
      {/* Hero cover */}
      <div style={{ position: 'relative', width: '100%', aspectRatio: '1/1', overflow: 'hidden' }}>
        <div style={{
          position: 'absolute', inset: 0,
          background: `linear-gradient(160deg, hsl(28, 22%, 34%), hsl(28, 22%, 10%))`,
        }}/>
        <div style={{
          position: 'absolute', inset: 0,
          background: `radial-gradient(ellipse 70% 50% at 50% 30%, rgba(212,182,113,0.3) 0%, transparent 60%)`,
        }}/>
        <div style={{
          position: 'absolute', inset: 0,
          backgroundImage: `url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='120' height='120'><filter id='n'><feTurbulence baseFrequency='0.9' numOctaves='2' stitchTiles='stitch'/></filter><rect width='100%' height='100%' filter='url(%23n)' opacity='0.4'/></svg>")`,
          mixBlendMode: 'overlay', opacity: 0.5,
        }}/>
        <div style={{
          position: 'absolute', inset: 0,
          background: 'linear-gradient(180deg, rgba(0,0,0,0.3) 0%, transparent 40%, rgba(0,0,0,0.9) 100%)',
        }}/>

        {/* top chrome */}
        <div style={{
          position: 'absolute', top: 54, left: 20, right: 20,
          display: 'flex', justifyContent: 'space-between',
        }}>
          <div style={{
            width: 36, height: 36,
            background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(12px)',
            border: hairlineGold,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: Theme.gold,
          }}>
            <svg width="10" height="16" viewBox="0 0 10 16" fill="none">
              <path d="M8 2L2 8l6 6" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
            </svg>
          </div>
          <div style={{ display: 'flex', gap: 6 }}>
            {['share', 'edit'].map((k) => (
              <div key={k} style={{
                width: 36, height: 36,
                background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(12px)',
                border: hairlineGold,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: Theme.gold, fontFamily: Theme.mono, fontSize: 10, letterSpacing: 1,
              }}>{k === 'share' ? '↑' : '✎'}</div>
            ))}
          </div>
        </div>

        {/* bottom text */}
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0, padding: '0 24px 28px',
        }}>
          <div style={{
            fontFamily: Theme.mono, fontSize: 10, letterSpacing: 3,
            color: Theme.gold, marginBottom: 10, textTransform: 'uppercase',
          }}>— ALBUM · N° 14 —</div>
          <div style={{
            fontFamily: Theme.display, fontSize: 44, fontWeight: 300,
            color: Theme.white, lineHeight: 0.9, letterSpacing: -1.5,
            marginBottom: 10,
          }}>
            Easter<br/>
            <span style={{ fontStyle: 'italic', color: Theme.gold }}>Retreat</span>
          </div>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 12,
            fontFamily: Theme.sans, fontSize: 11, color: Theme.whiteMuted, letterSpacing: 0.5,
          }}>
            <span>부활절 수련회</span>
            <span style={{ color: Theme.gold }}>·</span>
            <span>03.28 → 03.30</span>
            <span style={{ color: Theme.gold }}>·</span>
            <span style={{ color: Theme.gold }}>127 photos</span>
          </div>
        </div>
      </div>

      {/* Story / notes */}
      <div style={{
        padding: '24px 24px 20px',
        borderBottom: hairlineWhite,
      }}>
        <div style={{
          fontFamily: Theme.display, fontSize: 15, fontStyle: 'italic',
          color: Theme.goldLight, lineHeight: 1.5, marginBottom: 12,
        }}>
          "새벽 예배, 첨탑 아래 묵상, 함께 나눈 식사."
        </div>
        <div style={{
          fontFamily: Theme.sans, fontSize: 12, color: Theme.whiteMuted,
          lineHeight: 1.6, fontWeight: 300,
        }}>
          봄의 가장 밝은 사흘. 주께서 다시 사신 날을 기념하며 강원도 춘천에서 모인 공동체의 기록. 34명의 성도가 참여하였고, 세 번의 예배와 두 번의 교제가 있었습니다.
        </div>
      </div>

      {/* Metadata strip */}
      <div style={{
        padding: '16px 24px 20px',
        display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 0,
      }}>
        {[
          { num: '127', lbl: 'Photos', sub: '사진' },
          { num: '34', lbl: 'People', sub: '성도' },
          { num: '3', lbl: 'Days', sub: '일간' },
        ].map((s, i, arr) => (
          <div key={i} style={{
            borderRight: i < arr.length - 1 ? hairlineWhite : 'none',
            paddingRight: i < arr.length - 1 ? 12 : 0,
            paddingLeft: i > 0 ? 12 : 0,
          }}>
            <div style={{
              fontFamily: Theme.display, fontSize: 28, fontWeight: 300,
              color: Theme.gold, lineHeight: 1, letterSpacing: -0.5,
            }}>{s.num}</div>
            <div style={{
              fontFamily: Theme.sans, fontSize: 10, fontWeight: 600,
              color: Theme.white, letterSpacing: 2, marginTop: 4, textTransform: 'uppercase',
            }}>{s.lbl}</div>
            <div style={{
              fontFamily: Theme.display, fontSize: 10, fontStyle: 'italic',
              color: Theme.whiteFaint, marginTop: 1,
            }}>{s.sub}</div>
          </div>
        ))}
      </div>

      {/* Photos grid */}
      <div style={{ padding: '12px 16px 100px' }}>
        <div style={{
          display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
          padding: '0 4px 14px',
        }}>
          <div style={{ fontFamily: Theme.mono, fontSize: 10, letterSpacing: 3, color: Theme.gold }}>▸ COLLECTION</div>
          <div style={{ fontFamily: Theme.display, fontSize: 12, fontStyle: 'italic', color: Theme.whiteMuted }}>
            View all 127 →
          </div>
        </div>

        {/* featured big + small grid */}
        <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: 3, marginBottom: 3 }}>
          <div style={{
            aspectRatio: '1',
            background: `linear-gradient(160deg, hsl(28, 22%, 30%), hsl(28, 22%, 10%))`,
            border: `1px solid ${Theme.gold}`,
            position: 'relative', overflow: 'hidden',
          }}>
            <div style={{
              position: 'absolute', inset: 0,
              background: `radial-gradient(ellipse at 50% 30%, rgba(212,182,113,0.2), transparent 60%)`,
            }}/>
            <div style={{
              position: 'absolute', bottom: 8, left: 8,
              fontFamily: Theme.display, fontSize: 14, fontStyle: 'italic', color: Theme.gold,
            }}>cover</div>
          </div>
          <div style={{ display: 'grid', gridTemplateRows: '1fr 1fr', gap: 3 }}>
            <div style={{
              background: `linear-gradient(135deg, hsl(25, 14%, 22%), hsl(25, 14%, 10%))`,
            }}/>
            <div style={{
              background: `linear-gradient(135deg, hsl(35, 14%, 22%), hsl(35, 14%, 10%))`,
            }}/>
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 3 }}>
          {hues.map((h, i) => (
            <div key={i} style={{
              aspectRatio: '1',
              background: `linear-gradient(135deg, hsl(${h}, 14%, ${20 + (i%5)*3}%), hsl(${h}, 14%, ${10 + (i%5)*2}%))`,
              position: 'relative', overflow: 'hidden',
            }}>
              {i === 14 && (
                <div style={{
                  position: 'absolute', inset: 0,
                  background: 'rgba(0,0,0,0.6)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  <div style={{
                    fontFamily: Theme.display, fontSize: 16, fontStyle: 'italic',
                    color: Theme.gold,
                  }}>+112</div>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>

      <V2TabBar active="albums" />
    </div>
  );
}

Object.assign(window, { PhotosView, SimilarReview, AlbumDetail });
