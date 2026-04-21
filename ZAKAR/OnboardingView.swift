import SwiftUI
import Photos

// MARK: - 온보딩 진입점
struct OnboardingView: View {
    var onFinish: () -> Void
    @State private var currentPage = 0
    @State private var permissionStatus: PHAuthorizationStatus = .notDetermined

    private let totalPages = 5

    var body: some View {
        ZStack {
            PremiumBackground(style: .warm)
                .ignoresSafeArea()

            TabView(selection: $currentPage) {
                OnboardingWelcomePage().tag(0)
                OnboardingMeaningPage().tag(1)
                OnboardingAnalysisPage().tag(2)
                OnboardingGesturePage().tag(3)
                OnboardingPermissionPage(
                    permissionStatus: $permissionStatus,
                    onFinish: onFinish
                ).tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeOut(duration: 0.35), value: currentPage)

            // Navigation overlay
            VStack(spacing: 0) {
                topNavBar
                Spacer()
                if currentPage < 4 { bottomNavBar }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            permissionStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        }
    }

    // MARK: - Top Nav (progress bar + skip)
    private var topNavBar: some View {
        VStack(spacing: 10) {
            HStack(spacing: 5) {
                ForEach(0..<totalPages, id: \.self) { i in
                    Capsule()
                        .fill(i <= currentPage ? AppTheme.gold : AppTheme.warmWhite.opacity(0.12))
                        .frame(maxWidth: .infinity)
                        .frame(height: 2)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)

            HStack {
                Spacer()
                if (1...3).contains(currentPage) {
                    Button {
                        withAnimation(.easeOut(duration: 0.35)) { currentPage = 4 }
                    } label: {
                        Text("SKIP")
                            .font(.sanctumMono(10))
                            .tracking(2)
                            .foregroundColor(AppTheme.warmWhite.opacity(0.38))
                    }
                    .padding(.trailing, 24)
                }
            }
        }
    }

    // MARK: - Bottom Nav (back + CTA)
    private var bottomNavBar: some View {
        HStack(spacing: 12) {
            // Back button
            if currentPage > 0 {
                Button {
                    withAnimation(.easeOut(duration: 0.35)) { currentPage -= 1 }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.gold)
                        .frame(width: 52, height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AppTheme.gold.opacity(0.35), lineWidth: 0.5)
                        )
                }
            } else {
                Spacer().frame(width: 52)
            }

            // CTA button
            Button {
                withAnimation(.easeOut(duration: 0.35)) { currentPage += 1 }
            } label: {
                Text(currentPage == 0 ? "DISCOVER" : "CONTINUE")
                    .font(.sanctumMono(12))
                    .tracking(4)
                    .foregroundColor(AppTheme.obsidian)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppTheme.goldGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 36)
    }
}

// MARK: - 페이지 0: 환영 (Welcome)
struct OnboardingWelcomePage: View {
    @State private var appear = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // 로고
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(AppTheme.gold.opacity(0.06 - Double(i) * 0.015), lineWidth: 1)
                        .frame(width: CGFloat(110 + i * 36), height: CGFloat(110 + i * 36))
                        .scaleEffect(appear ? 1 : 0.7)
                        .animation(.easeOut(duration: 0.8).delay(Double(i) * 0.15), value: appear)
                }

                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(AppTheme.gold.opacity(0.28), lineWidth: 1))
                    .shadow(color: AppTheme.goldenShadow(opacity: 0.18), radius: 20)

                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 66, height: 66)
                    .clipShape(Circle())
            }
            .scaleEffect(appear ? 1 : 0.6)
            .opacity(appear ? 1 : 0)
            .animation(.spring(response: 0.7, dampingFraction: 0.7), value: appear)

            Spacer().frame(height: 36)

            // ZAKAR 워드마크 (A 이탤릭 골드)
            HStack(spacing: 0) {
                Text("Z").font(.displayLight(96)).foregroundColor(AppTheme.warmWhite)
                Text("A").font(.displayLightItalic(96)).foregroundColor(AppTheme.gold)
                Text("K").font(.displayLight(96)).foregroundColor(AppTheme.warmWhite)
                Text("A").font(.displayLightItalic(96)).foregroundColor(AppTheme.gold)
                Text("R").font(.displayLight(96)).foregroundColor(AppTheme.warmWhite)
            }
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .offset(y: appear ? 0 : 16)
            .opacity(appear ? 1 : 0)
            .animation(.easeOut(duration: 0.6).delay(0.2), value: appear)

            Spacer().frame(height: 8)

            Text("to remember.")
                .font(.displayLightItalic(22))
                .foregroundColor(AppTheme.goldLight.opacity(0.8))
                .offset(y: appear ? 0 : 12)
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.32), value: appear)

            Spacer().frame(height: 28)

            // Gold hairline divider
            GoldDivider(width: 32)
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.45), value: appear)

            Spacer().frame(height: 24)

            // 소개 문구
            Text("교회의 모든 순간을\n체계적으로 기억합니다")
                .font(.system(size: 15, weight: .light))
                .foregroundColor(AppTheme.warmWhite.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .offset(y: appear ? 0 : 16)
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.55), value: appear)

            Spacer()
            Spacer().frame(height: 120) // bottom nav clearance
        }
        .padding(.horizontal, 32)
        .onAppear { appear = true }
    }
}

// MARK: - 페이지 1: 의미 (Meaning) — 신규
struct OnboardingMeaningPage: View {
    @State private var appear = false

    var body: some View {
        ZStack {
            // 배경 워터마크
            Text("ZAKAR")
                .font(.displayLightItalic(180))
                .foregroundColor(AppTheme.gold.opacity(0.04))
                .rotationEffect(.degrees(-15))
                .offset(x: 40, y: -20)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Spacer()

                // 히브리어 라벨
                Text("— זָכַר · ZAKAR · 자카르 —")
                    .font(.sanctumMono(10))
                    .tracking(4)
                    .foregroundColor(AppTheme.gold)
                    .multilineTextAlignment(.center)
                    .opacity(appear ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: appear)

                Spacer().frame(height: 32)

                // "To remember..." 3행
                VStack(alignment: .leading, spacing: 2) {
                    meaningLine("To remember,", delay: 0.2)
                    meaningLine("To keep in memory,", delay: 0.35)
                    meaningLine("To call to mind.", delay: 0.5, isLast: true)
                }
                .padding(.horizontal, 32)

                Spacer().frame(height: 36)

                // 인용 바
                VStack(alignment: .leading, spacing: 10) {
                    Rectangle()
                        .fill(AppTheme.gold.opacity(0.45))
                        .frame(height: 0.5)

                    Text("기록되지 않은 순간은, 기억되지 않는다.")
                        .font(.displayItalic(14))
                        .foregroundColor(AppTheme.gold.opacity(0.85))
                }
                .padding(.horizontal, 32)
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.65), value: appear)

                Spacer()
                Spacer().frame(height: 120)
            }
        }
        .onAppear { appear = true }
    }

    private func meaningLine(_ text: String, delay: Double, isLast: Bool = false) -> some View {
        Text(text)
            .font(.displayLight(38))
            .foregroundColor(isLast ? AppTheme.gold.opacity(0.9) : AppTheme.warmWhite.opacity(0.88))
            .offset(x: appear ? 0 : -20)
            .opacity(appear ? 1 : 0)
            .animation(.easeOut(duration: 0.55).delay(delay), value: appear)
    }
}

// MARK: - 페이지 2: 유사 사진 분석 (Analysis) — 로직 보존, 스타일 업데이트
struct OnboardingAnalysisPage: View {
    @State private var phase = 0
    @State private var scanProgress: CGFloat = 0
    @State private var appear = false

    private let photos: [(color: Color, group: Int)] = [
        (.blue.opacity(0.7), 0), (.blue.opacity(0.55), 0), (.blue.opacity(0.8), 0),
        (.green.opacity(0.7), 1), (.green.opacity(0.55), 1),
        (.orange.opacity(0.7), 2), (.orange.opacity(0.6), 2), (.orange.opacity(0.8), 2),
        (.purple.opacity(0.6), 3), (.purple.opacity(0.75), 3),
        (.red.opacity(0.5), 4), (.teal.opacity(0.6), 5),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 32)

            // 헤더
            VStack(spacing: 10) {
                Text("FEATURE — 01")
                    .font(.sanctumMono(10))
                    .tracking(3)
                    .foregroundColor(AppTheme.gold)

                Text("닮은 순간들을,\n헤아립니다.")
                    .font(.displayLight(44))
                    .foregroundColor(AppTheme.warmWhite)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .opacity(appear ? 1 : 0)
            .animation(.easeOut(duration: 0.5), value: appear)

            Spacer().frame(height: 28)

            // 시뮬레이션 영역
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(AppTheme.graphite.opacity(0.4))
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(AppTheme.gold.opacity(0.15), lineWidth: 0.5)
                    )

                if phase < 2 {
                    VStack(spacing: 8) {
                        if phase == 1 {
                            HStack(spacing: 6) {
                                Image(systemName: "sparkle.magnifyingglass")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.gold)
                                Text("유사도 분석 중...")
                                    .font(.sanctumMono(11))
                                    .foregroundColor(AppTheme.gold)
                                Spacer()
                                Text("\(Int(scanProgress * 100))%")
                                    .font(.sanctumMono(11))
                                    .foregroundColor(AppTheme.gold)
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 12)

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(AppTheme.warmWhite.opacity(0.06)).frame(height: 2)
                                    Capsule()
                                        .fill(AppTheme.goldGradient)
                                        .frame(width: geo.size.width * scanProgress, height: 2)
                                }
                            }
                            .frame(height: 2)
                            .padding(.horizontal, 12)
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 4), spacing: 4) {
                            ForEach(photos.indices, id: \.self) { i in
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(photos[i].color)
                                    .frame(height: 52)
                                    .overlay(
                                        phase == 1
                                            ? RoundedRectangle(cornerRadius: 6)
                                                .stroke(AppTheme.gold.opacity(0.65), lineWidth: 1.5)
                                                .opacity(Double.random(in: 0.3...1.0))
                                            : nil
                                    )
                            }
                        }
                        .padding(12)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(groupedData, id: \.0) { groupID, groupPhotos in
                                HStack(spacing: 6) {
                                    Text("\(groupPhotos.count)장 유사")
                                        .font(.sanctumMono(10))
                                        .foregroundColor(AppTheme.warmWhite.opacity(0.6))
                                        .frame(width: 58, alignment: .leading)

                                    HStack(spacing: 4) {
                                        ForEach(groupPhotos.indices, id: \.self) { i in
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(groupPhotos[i])
                                                .frame(width: 44, height: 44)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(AppTheme.gold.opacity(0.45), lineWidth: 1)
                                                )
                                                .shadow(color: AppTheme.goldenShadow(opacity: 0.18), radius: 4)
                                                .scaleEffect(phase == 3 ? 1 : 0.5)
                                                .opacity(phase == 3 ? 1 : 0)
                                                .animation(
                                                    .spring(response: 0.4, dampingFraction: 0.7)
                                                        .delay(Double(i) * 0.06 + Double(groupID) * 0.1),
                                                    value: phase
                                                )
                                        }
                                        Spacer()
                                        if phase == 3 {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 11))
                                                .foregroundColor(AppTheme.gold.opacity(0.4))
                                        }
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(AppTheme.gold.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 10)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .frame(height: 230)
            .padding(.horizontal, 24)

            Spacer().frame(height: 16)

            Button { restartAnimation() } label: {
                Label("다시 보기", systemImage: "arrow.counterclockwise")
                    .font(.sanctumMono(11))
                    .foregroundColor(AppTheme.warmWhite.opacity(0.45))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule().fill(AppTheme.gold.opacity(0.06))
                            .overlay(Capsule().stroke(AppTheme.gold.opacity(0.15), lineWidth: 0.5))
                    )
            }

            Spacer()
            Spacer().frame(height: 120)
        }
        .onAppear {
            appear = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { startAnimation() }
        }
    }

    private var groupedData: [(Int, [Color])] {
        var result: [(Int, [Color])] = []
        let grouped = Dictionary(grouping: photos.filter { $0.group < 4 }, by: { $0.group })
        for key in grouped.keys.sorted() {
            result.append((key, grouped[key]!.map { $0.color }))
        }
        return result
    }

    private func startAnimation() {
        withAnimation { phase = 1 }
        withAnimation(.linear(duration: 1.8)) { scanProgress = 1.0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { withAnimation { phase = 2 } }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) { withAnimation { phase = 3 } }
    }

    private func restartAnimation() {
        phase = 0
        scanProgress = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { startAnimation() }
    }
}

// MARK: - 페이지 3: 제스처 (Gesture) — 로직 100% 보존, 스타일 업데이트
struct OnboardingGesturePage: View {
    @State private var offset: CGSize = .zero
    @State private var currentAction: GestureAction = .idle
    @State private var cardScale: CGFloat = 1.0
    @State private var feedbackText = "사진을 직접 스와이프해보세요"
    @State private var feedbackColor = Color.white.opacity(0.5)
    @State private var demoPhotoIndex = 0
    @State private var appear = false

    enum GestureAction { case idle, trashing, favoriting, nextPhoto, prevPhoto }

    private let demoColors: [LinearGradient] = [
        LinearGradient(colors: [.blue.opacity(0.6), .purple.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [.green.opacity(0.5), .teal.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [.orange.opacity(0.6), .red.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [.pink.opacity(0.5), .purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 32)

            VStack(spacing: 10) {
                Text("FEATURE — 02")
                    .font(.sanctumMono(10))
                    .tracking(3)
                    .foregroundColor(AppTheme.gold)

                Text("손끝 하나로\n정리.")
                    .font(.displayLight(44))
                    .foregroundColor(AppTheme.warmWhite)
                    .multilineTextAlignment(.center)
            }
            .opacity(appear ? 1 : 0)
            .animation(.easeOut(duration: 0.5), value: appear)

            Spacer().frame(height: 20)

            // 제스처 가이드 4방향
            HStack(spacing: 0) {
                gestureGuide(arrow: "↑", label: "삭제", isActive: currentAction == .trashing)
                gestureGuide(arrow: "↓", label: "즐겨찾기", isActive: currentAction == .favoriting)
                gestureGuide(arrow: "←", label: "다음", isActive: currentAction == .nextPhoto)
                gestureGuide(arrow: "→", label: "이전", isActive: currentAction == .prevPhoto)
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 16)

            // 인터랙티브 카드
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(demoColors[(demoPhotoIndex + 1) % demoColors.count])
                    .frame(width: 230, height: 286)
                    .scaleEffect(0.95)
                    .opacity(0.5)

                ZStack {
                    demoColors[demoPhotoIndex % demoColors.count]

                    // Gold tint action overlay
                    if currentAction != .idle {
                        AppTheme.gold.opacity(0.15)
                    }

                    VStack {
                        Spacer()
                        Text("사진 \(demoPhotoIndex + 1)")
                            .font(.sanctumMono(11))
                            .foregroundColor(AppTheme.warmWhite.opacity(0.6))
                            .padding(.bottom, 16)
                    }

                    // Sanctum 이탤릭 기호 오버레이
                    Group {
                        if currentAction == .trashing {
                            Text("削")
                                .font(.displayItalic(48))
                                .foregroundColor(AppTheme.gold)
                                .shadow(color: AppTheme.goldenShadow(opacity: 0.5), radius: 12)
                                .transition(.scale.combined(with: .opacity))
                        } else if currentAction == .favoriting {
                            Text("★")
                                .font(.displayItalic(48))
                                .foregroundColor(AppTheme.gold)
                                .shadow(color: AppTheme.goldenShadow(opacity: 0.5), radius: 12)
                                .transition(.scale.combined(with: .opacity))
                        } else if currentAction == .nextPhoto {
                            Text("→")
                                .font(.displayItalic(48))
                                .foregroundColor(AppTheme.gold)
                                .shadow(color: AppTheme.goldenShadow(opacity: 0.5), radius: 12)
                                .transition(.scale.combined(with: .opacity))
                        } else if currentAction == .prevPhoto {
                            Text("←")
                                .font(.displayItalic(48))
                                .foregroundColor(AppTheme.gold)
                                .shadow(color: AppTheme.goldenShadow(opacity: 0.5), radius: 12)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .frame(width: 230, height: 286)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppTheme.gold.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: AppTheme.goldenShadow(opacity: 0.18), radius: 18, y: 8)
                .shadow(color: .black.opacity(0.3), radius: 10, y: 4)
                .scaleEffect(cardScale)
                .offset(offset)
                .rotationEffect(.degrees(Double(offset.width) / 15))
                .gesture(
                    DragGesture()
                        .onChanged { g in
                            offset = g.translation
                            updateAction(from: g.translation)
                        }
                        .onEnded { g in
                            handleGestureEnd(g.translation)
                        }
                )
            }
            .frame(height: 310)

            Spacer().frame(height: 14)

            Text(feedbackText)
                .font(.sanctumMono(11))
                .tracking(1)
                .foregroundColor(feedbackColor)
                .animation(.easeInOut(duration: 0.2), value: feedbackText)
                .multilineTextAlignment(.center)
                .frame(height: 20)

            Spacer()
            Spacer().frame(height: 120)
        }
        .onAppear { appear = true }
    }

    private func gestureGuide(arrow: String, label: String, isActive: Bool) -> some View {
        VStack(spacing: 4) {
            Text(arrow)
                .font(.displaySerif(20))
                .foregroundColor(isActive ? AppTheme.gold : AppTheme.warmWhite.opacity(0.28))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(isActive ? AppTheme.gold.opacity(0.12) : AppTheme.warmWhite.opacity(0.04))
                )
                .animation(.easeInOut(duration: 0.15), value: isActive)

            Text(label)
                .font(.sanctumMono(9))
                .tracking(1)
                .foregroundColor(isActive ? AppTheme.gold : AppTheme.warmWhite.opacity(0.28))
                .animation(.easeInOut(duration: 0.15), value: isActive)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Gesture Logic (100% 보존)
    private func updateAction(from translation: CGSize) {
        let v = translation.height
        let h = translation.width
        if abs(v) > abs(h) {
            currentAction = v < -40 ? .trashing : (v > 40 ? .favoriting : .idle)
        } else {
            currentAction = h < -40 ? .nextPhoto : (h > 40 ? .prevPhoto : .idle)
        }
        withAnimation(.spring(response: 0.3)) { cardScale = 0.97 }
    }

    private func handleGestureEnd(_ translation: CGSize) {
        let v = translation.height
        let h = translation.width
        if v < -100 {
            triggerFeedback("휴지통에 임시 보관됩니다", color: AppTheme.gold)
            flyOut(direction: CGSize(width: 0, height: -600))
        } else if v > 80 {
            triggerFeedback("⭐ 즐겨찾기에 추가됩니다", color: AppTheme.gold)
            resetCard()
        } else if h < -60 {
            triggerFeedback("다음 사진", color: AppTheme.gold)
            flyOut(direction: CGSize(width: -500, height: 0))
        } else if h > 60 {
            triggerFeedback("이전 사진", color: AppTheme.gold)
            flyOut(direction: CGSize(width: 500, height: 0))
        } else {
            resetCard()
            feedbackText = "사진을 직접 스와이프해보세요"
            feedbackColor = AppTheme.warmWhite.opacity(0.4)
        }
    }

    private func flyOut(direction: CGSize) {
        withAnimation(.easeIn(duration: 0.22)) {
            offset = direction
            cardScale = 0.85
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            demoPhotoIndex = (demoPhotoIndex + 1) % demoColors.count
            offset = .zero
            cardScale = 0.85
            currentAction = .idle
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { cardScale = 1.0 }
        }
    }

    private func resetCard() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            offset = .zero
            cardScale = 1.0
            currentAction = .idle
        }
    }

    private func triggerFeedback(_ text: String, color: Color) {
        feedbackText = text
        feedbackColor = color
    }
}

// MARK: - 페이지 4: 권한 요청 (Begin) — 로직 100% 보존
struct OnboardingPermissionPage: View {
    @Binding var permissionStatus: PHAuthorizationStatus
    var onFinish: () -> Void
    @State private var isRequesting = false
    @State private var appear = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // "— FINALE —" 라벨
            Text("— FINALE —")
                .font(.sanctumMono(10))
                .tracking(4)
                .foregroundColor(AppTheme.gold)
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.5), value: appear)

            Spacer().frame(height: 28)

            // "Now, / Remember." 대형 타이틀
            VStack(alignment: .center, spacing: -4) {
                Text("Now,")
                    .font(.displayLightItalic(68))
                    .foregroundColor(AppTheme.gold)
                Text("Remember.")
                    .font(.displayLightItalic(68))
                    .foregroundColor(AppTheme.warmWhite.opacity(0.9))
            }
            .minimumScaleFactor(0.6)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .offset(y: appear ? 0 : 16)
            .opacity(appear ? 1 : 0)
            .animation(.easeOut(duration: 0.6).delay(0.15), value: appear)

            Spacer().frame(height: 20)

            // 보안 안내
            HStack(spacing: 8) {
                Text("On-device · Never uploaded · Always private")
                    .font(.sanctumMono(9))
                    .tracking(1)
                    .foregroundColor(AppTheme.warmWhite.opacity(0.3))
                    .multilineTextAlignment(.center)
            }
            .opacity(appear ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.3), value: appear)

            Spacer().frame(height: 48)

            // 권한 상태별 버튼 (로직 100% 보존)
            VStack(spacing: 12) {
                if permissionGranted {
                    Button(action: onFinish) {
                        Text("ZAKAR 시작하기")
                            .font(.sanctumMono(12))
                            .tracking(4)
                            .foregroundColor(AppTheme.obsidian)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(AppTheme.goldGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .padding(.horizontal, 24)
                } else if permissionStatus == .denied || permissionStatus == .restricted {
                    Button(action: openSettings) {
                        HStack(spacing: 8) {
                            Image(systemName: "gear")
                                .font(.system(size: 15, weight: .semibold))
                            Text("설정에서 권한 허용하기")
                                .font(.sanctumMono(11))
                                .tracking(2)
                        }
                        .foregroundColor(AppTheme.obsidian)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppTheme.goldGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .padding(.horizontal, 24)
                } else {
                    Button(action: requestPermission) {
                        HStack(spacing: 8) {
                            if isRequesting {
                                ProgressView().tint(AppTheme.obsidian).scaleEffect(0.85)
                            } else {
                                Image(systemName: "photo")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            Text(isRequesting ? "요청 중..." : "사진 접근 허용")
                                .font(.sanctumMono(11))
                                .tracking(2)
                        }
                        .foregroundColor(AppTheme.obsidian)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppTheme.goldGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(isRequesting)
                    .padding(.horizontal, 24)
                }

                // 이미 권한이 있으면 바로 완료 유도 없이 넘어가는 케이스 안내
                Text("사진 권한은 유사 사진 분석과 정리에만 사용됩니다.\n언제든 설정에서 변경할 수 있습니다.")
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.warmWhite.opacity(0.28))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .opacity(appear ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.4), value: appear)

            Spacer()
        }
        .onAppear {
            appear = true
            // 자동 권한 요청 없음 — 사용자가 버튼을 직접 눌러야 함
        }
    }

    private var permissionGranted: Bool {
        permissionStatus == .authorized || permissionStatus == .limited
    }

    private func requestPermission() {
        guard !isRequesting else { return }
        isRequesting = true
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                permissionStatus = status
                isRequesting = false
            }
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    OnboardingView { }
}
