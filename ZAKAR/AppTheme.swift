import SwiftUI

/// ZAKAR — Sanctum · Liquid Glass
/// 옵시디안 블랙 + 샴페인 골드 + 글래스모피즘
struct AppTheme {

    // MARK: - Background (Sanctum blacks)

    /// 가장 깊은 배경 — 거의 순수 검정
    static let obsidian  = Color(red: 0.028, green: 0.028, blue: 0.039)  // #07070A

    /// 메인 배경
    static let onyx      = Color(red: 0.055, green: 0.055, blue: 0.071)  // #0E0E12

    /// 약간 올라온 면
    static let graphite  = Color(red: 0.094, green: 0.094, blue: 0.122)  // #18181F

    /// 카드·시트 기본 배경
    static let ash       = Color(red: 0.145, green: 0.145, blue: 0.188)  // #252530

    // 레거시 퍼플 (호환성 유지 — glass 소재에 미묘한 보라 잔향 제공)
    static let deepPurple  = Color(red: 0.16, green: 0.12, blue: 0.24)
    static let midPurple   = Color(red: 0.27, green: 0.22, blue: 0.36)
    static let darkPurple  = Color(red: 0.25, green: 0.22, blue: 0.35)
    static let lightPurple = Color(red: 0.50, green: 0.45, blue: 0.60)

    // MARK: - Gold (샴페인 골드 4단계)

    /// 메인 골드
    static let gold      = Color(red: 0.831, green: 0.714, blue: 0.443)  // #D4B671

    /// 밝은 골드 — 하이라이트
    static let goldLight = Color(red: 0.918, green: 0.847, blue: 0.627)  // #EAD8A0

    /// 깊은 골드 — 섀도우·깊이
    static let goldDeep  = Color(red: 0.655, green: 0.533, blue: 0.282)  // #A78848

    // 레거시 이름 유지
    static let gracefulGold = gold
    static let goldenRose   = Color(red: 0.85, green: 0.65, blue: 0.45)
    static let lavender     = Color(red: 0.70, green: 0.65, blue: 0.85)

    // MARK: - Text (따뜻한 오프화이트)

    static let warmWhite      = Color(red: 0.965, green: 0.949, blue: 0.918)  // #F6F2EA

    // 레거시 이름 유지
    static let pureWhite  = warmWhite
    static let subText    = Color.white.opacity(0.7)
    static let divider    = Color.white.opacity(0.2)

    // MARK: - Gradients

    /// 메인 배경 — 옵시디안 베이스
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [obsidian, onyx],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// 골드 버튼·CTA — 샴페인 금속 질감
    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [goldLight, gold, goldDeep],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// 소프트 골드 글로우 (카드 내부 채움용)
    static var goldGradientSoft: LinearGradient {
        LinearGradient(
            colors: [gold.opacity(0.14), goldDeep.opacity(0.06)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// 글라스 카드 테두리 — 골드 hairline
    static var glassBorderGradient: LinearGradient {
        LinearGradient(
            colors: [
                gold.opacity(0.45),
                gold.opacity(0.22),
                gold.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // 레거시 그라디언트 별칭
    static var goldenPurpleGradient: LinearGradient { goldGradient }
    static var purpleLavenderGradient: LinearGradient {
        LinearGradient(
            colors: [lightPurple, lavender],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    static var goldenGradient: some ShapeStyle { gold }
    static var purpleGradient: some ShapeStyle  { lightPurple }
    static var dualGradient: LinearGradient     { goldGradient }

    // MARK: - Shadow / Glow

    static func goldenShadow(opacity: Double = 0.35) -> Color    { gold.opacity(opacity) }
    static func goldenRoseShadow(opacity: Double = 0.25) -> Color { goldenRose.opacity(opacity) }
    static func purpleShadow(opacity: Double = 0.25) -> Color    { midPurple.opacity(opacity) }
    static func lavenderShadow(opacity: Double = 0.18) -> Color  { lavender.opacity(opacity) }
}

// MARK: - Typography

extension Font {

    // MARK: Cormorant Garamond — 에디토리얼 디스플레이

    /// Light (weight 300) — 대형 본문·헤드라인
    static func displayLight(_ size: CGFloat) -> Font {
        Font.custom("CormorantGaramond-Light", size: size)
    }

    /// Light Italic — 골드 강조 키워드
    static func displayLightItalic(_ size: CGFloat) -> Font {
        Font.custom("CormorantGaramond-LightItalic", size: size)
    }

    /// Regular — 일반 디스플레이
    static func displaySerif(_ size: CGFloat) -> Font {
        Font.custom("CormorantGaramond-Regular", size: size)
    }

    /// Italic — 슬로건·인용
    static func displayItalic(_ size: CGFloat) -> Font {
        Font.custom("CormorantGaramond-Italic", size: size)
    }

    /// Medium — 소제목
    static func displayMedium(_ size: CGFloat) -> Font {
        Font.custom("CormorantGaramond-Medium", size: size)
    }

    /// Medium Italic — 강조 소제목
    static func displayMediumItalic(_ size: CGFloat) -> Font {
        Font.custom("CormorantGaramond-MediumItalic", size: size)
    }

    /// SemiBold — 버튼 내 디스플레이 텍스트
    static func displaySemiBold(_ size: CGFloat) -> Font {
        Font.custom("CormorantGaramond-SemiBold", size: size)
    }

    // MARK: SF Mono — 메타데이터·라벨

    /// 넓은 자간 모노 라벨 (섹션 제목, 배지, 날짜)
    static func sanctumMono(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        Font.system(size: size, design: .monospaced).weight(weight)
    }
}

// MARK: - Upload Mode Theme Extension

extension AppTheme {

    enum UploadModeTheme {
        case folder
        case album
        case photos

        var accentColor: Color { AppTheme.gold }
        var gradient: Color    { AppTheme.gold }
        var glowColor: Color   { accentColor.opacity(0.28) }

        static func from<T>(_ mode: T) -> UploadModeTheme {
            switch String(describing: mode) {
            case "folder": return .folder
            case "album":  return .album
            case "photos": return .photos
            default:       return .folder
            }
        }
    }
}

// MARK: - View Modifiers

extension View {

    func premiumBackground(style: PremiumBackground.BackgroundStyle = .deep) -> some View {
        self.background(PremiumBackground(style: style))
    }

    func goldenForeground() -> some View {
        self.foregroundStyle(AppTheme.gold)
    }

    func whiteForeground() -> some View {
        self.foregroundStyle(AppTheme.warmWhite)
    }

    func goldenGlow(radius: CGFloat = 14, opacity: Double = 0.35) -> some View {
        self.shadow(color: AppTheme.goldenShadow(opacity: opacity), radius: radius)
    }

    func purpleGlow(radius: CGFloat = 18, opacity: Double = 0.25) -> some View {
        self.shadow(color: AppTheme.purpleShadow(opacity: opacity), radius: radius)
    }
}
