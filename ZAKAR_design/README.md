# ZAKAR · Redesign Mockups

iOS 앱 리브랜드 방향성 탐색을 위한 HTML 디자인 목업.

## 디자인 방향: Sanctum (블랙 & 골드 · 시네마틱)

- **Palette**: Obsidian `#0A0806` · Gold `#D4B671` · White `#F4F1EA`
- **Display**: 큰 이탤릭 세리프 (Playfair / DM Serif) — 극적 크기
- **Sans**: 넓은 자간 sans-serif (모든 대문자 레이블)
- **Mono**: 섹션 번호, 메타데이터, 라벨
- **Texture**: 필름 그레인 오버레이, 골드 방사형 글로우, hairline 구분선

## 열람 방법

`ZAKAR Redesign.html` 을 브라우저에서 열면 Design Canvas 가 로드됩니다.
툴바에서 **Tweaks** 토글 시 골드 강도 / 그레인 / 배경 톤을 실시간 조정할 수 있습니다.

## 포함된 화면

1. **Onboarding** — 5단계 (Welcome / Meaning / Analysis / Gesture / Photo Access)
2. **Home** — 메인 대시보드
3. **App Screens**
   - All Photos (날짜별 편집용 그리드)
   - Similar Review (AI 유사 사진 묶음 리뷰)
   - Album Detail (앨범 커버 + 메타 + 컬렉션)

## 파일 구조

```
design/
├── ZAKAR Redesign.html       # 메인 엔트리 (Design Canvas)
├── design-canvas.jsx         # 캔버스 컴포넌트 (pan/zoom/focus)
├── ios-frame.jsx             # iPhone bezel
└── components/
    ├── theme.jsx             # 디자인 토큰 + 공용 컴포넌트
    ├── onboarding-v2.jsx     # 온보딩 5단계
    ├── home-v2.jsx           # 홈 + 탭바
    └── app-screens.jsx       # 사진 / 유사 리뷰 / 앨범
```

## 다음 단계 후보

- 선택 → SwiftUI 컴포넌트로 이식 (AppTheme.swift 갱신)
- 사진 그리드, 유사 리뷰, 앨범 상세 추가 화면 확장
- 인터랙션 / 트랜지션 정의 (현재는 정적 목업)
