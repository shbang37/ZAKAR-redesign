import SwiftUI
import Combine

// MARK: - 승인 대기 화면
struct PendingApprovalView: View {
    @EnvironmentObject private var auth: AuthService
    @State private var pulseScale: CGFloat = 1.0
    @State private var appear = false
    @State private var now = Date()

    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            PremiumBackground(style: .warm)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 60)

                    pulseIcon
                        .scaleEffect(appear ? 1 : 0.7)
                        .opacity(appear ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: appear)

                    Spacer().frame(height: 28)

                    headerText
                        .opacity(appear ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.2), value: appear)

                    Spacer().frame(height: 28)

                    if let user = auth.currentUser {
                        userInfoCard(user: user)
                            .padding(.horizontal, 24)
                            .opacity(appear ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.30), value: appear)

                        Spacer().frame(height: 10)

                        requestTimeCard(requestedAt: user.requestedAt)
                            .padding(.horizontal, 24)
                            .opacity(appear ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.36), value: appear)
                    }

                    Spacer().frame(height: 10)

                    waitingSteps
                        .padding(.horizontal, 24)
                        .opacity(appear ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.42), value: appear)

                    Spacer().frame(height: 10)

                    contactCard
                        .padding(.horizontal, 24)
                        .opacity(appear ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.48), value: appear)

                    if let user = auth.currentUser, isTimeout(requestedAt: user.requestedAt) {
                        Spacer().frame(height: 16)
                        recontactSection
                            .padding(.horizontal, 24)
                            .opacity(appear ? 1 : 0)
                            .animation(.easeOut(duration: 0.5).delay(0.52), value: appear)
                    }

                    Spacer().frame(height: 20)

                    syncStatusRow
                        .opacity(appear ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.54), value: appear)

                    Spacer().frame(height: 28)

                    Button { auth.signOut() } label: {
                        Text("다른 계정으로 로그인")
                            .font(.sanctumMono(10))
                            .tracking(1)
                            .foregroundColor(AppTheme.warmWhite.opacity(0.38))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(AppTheme.warmWhite.opacity(0.05))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(AppTheme.warmWhite.opacity(0.1), lineWidth: 0.5))
                    }
                    .opacity(appear ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.56), value: appear)

                    Spacer().frame(height: 48)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            appear = true
            startPulse()
            if let uid = auth.currentUser?.id {
                auth.listenForApprovalChange(uid: uid)
            }
        }
        .onReceive(timer) { _ in now = Date() }
    }

    // MARK: - 골드 동심원 맥박 아이콘
    private var pulseIcon: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.gold.opacity(0.06), lineWidth: 1)
                .frame(width: 160, height: 160)
                .scaleEffect(pulseScale)
                .opacity(2.0 - pulseScale)

            Circle()
                .stroke(AppTheme.gold.opacity(0.12), lineWidth: 1)
                .frame(width: 122, height: 122)

            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 90, height: 90)
                .overlay(
                    Circle().stroke(AppTheme.gold.opacity(0.45), lineWidth: 1.5)
                )
                .shadow(color: AppTheme.goldenShadow(opacity: 0.22), radius: 18)

            Image(systemName: "clock.badge")
                .font(.system(size: 34, weight: .light))
                .foregroundColor(AppTheme.gold)
        }
    }

    // MARK: - 헤더
    private var headerText: some View {
        VStack(spacing: 8) {
            Text("승인 대기 중")
                .font(.displayMedium(24))
                .foregroundColor(AppTheme.warmWhite)

            Text("공동체 관리자의 승인 후 이용하실 수 있습니다.")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.warmWhite.opacity(0.48))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    // MARK: - 사용자 정보 카드
    private func userInfoCard(user: UserRecord) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(AppTheme.obsidian.opacity(0.7))
                    .frame(width: 44, height: 44)
                    .overlay(Circle().stroke(AppTheme.gold.opacity(0.4), lineWidth: 1))
                Text(String(user.name.prefix(1)))
                    .font(.displayMedium(18))
                    .foregroundColor(AppTheme.warmWhite)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(user.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.warmWhite)
                Text(user.email)
                    .font(.sanctumMono(10))
                    .foregroundColor(AppTheme.warmWhite.opacity(0.45))
            }

            Spacer()

            Text(user.department)
                .font(.sanctumMono(9))
                .tracking(1)
                .foregroundColor(AppTheme.gold)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(AppTheme.gold.opacity(0.12))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(AppTheme.gold.opacity(0.28), lineWidth: 0.5))
        }
        .padding(16)
        .background(GlassCard(cornerRadius: 16))
    }

    // MARK: - 신청 시간 카드
    private func requestTimeCard(requestedAt: Date) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("신청일")
                    .font(.sanctumMono(9))
                    .tracking(2)
                    .foregroundColor(AppTheme.gold.opacity(0.5))
                Text(formatRequestDate(requestedAt))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppTheme.warmWhite.opacity(0.85))
            }

            Spacer()

            Rectangle()
                .fill(AppTheme.gold.opacity(0.15))
                .frame(width: 0.5, height: 32)
                .padding(.horizontal, 16)

            VStack(alignment: .trailing, spacing: 4) {
                Text("경과")
                    .font(.sanctumMono(9))
                    .tracking(2)
                    .foregroundColor(AppTheme.gold.opacity(0.5))
                Text(elapsedString(from: requestedAt))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(
                        isTimeout(requestedAt: requestedAt)
                            ? .orange.opacity(0.85)
                            : AppTheme.warmWhite.opacity(0.75)
                    )
                    .monospacedDigit()
            }
        }
        .padding(14)
        .background(GlassCard(cornerRadius: 14, style: .subtle))
    }

    // MARK: - 진행 단계
    private var waitingSteps: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("— 진행 단계 —")
                .font(.sanctumMono(9))
                .tracking(3)
                .foregroundColor(AppTheme.gold.opacity(0.45))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 4)

            stepRow(number: "1", text: "관리자에게 알림이 전송되었습니다", done: true)
            stepRow(number: "2", text: "관리자 검토 및 승인 중", done: false, isActive: true)
            stepRow(number: "3", text: "승인 완료 시 자동으로 앱이 열립니다", done: false)
        }
        .padding(16)
        .background(GlassCard(cornerRadius: 14, style: .subtle))
    }

    private func stepRow(number: String, text: String, done: Bool, isActive: Bool = false) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        done
                            ? AnyShapeStyle(AppTheme.goldGradient)
                            : AnyShapeStyle(isActive ? AppTheme.gold.opacity(0.2) : AppTheme.warmWhite.opacity(0.07))
                    )
                    .frame(width: 22, height: 22)
                    .overlay(
                        Circle().stroke(
                            done ? Color.clear : (isActive ? AppTheme.gold.opacity(0.5) : AppTheme.warmWhite.opacity(0.12)),
                            lineWidth: 0.8
                        )
                    )
                if done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(AppTheme.obsidian)
                } else {
                    Text(number)
                        .font(.sanctumMono(10))
                        .foregroundColor(isActive ? AppTheme.gold : AppTheme.warmWhite.opacity(0.35))
                }
            }
            Text(text)
                .font(.system(size: 13, weight: isActive ? .semibold : .regular))
                .foregroundColor(isActive ? AppTheme.warmWhite : AppTheme.warmWhite.opacity(done ? 0.65 : 0.38))
        }
    }

    // MARK: - 담당자 연락처
    private var contactCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppTheme.gold.opacity(0.55))
                Text("담당자 문의")
                    .font(.sanctumMono(9))
                    .tracking(2)
                    .foregroundColor(AppTheme.gold.opacity(0.55))
            }

            Text("은혜의교회 담당 사역자에게\n승인 요청 사실을 알려주세요.")
                .font(.system(size: 12))
                .foregroundColor(AppTheme.warmWhite.opacity(0.48))
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(GlassCard(cornerRadius: 14, style: .subtle))
    }

    // MARK: - 48시간 초과 섹션
    private var recontactSection: some View {
        VStack(spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.orange.opacity(0.8))
                Text("48시간 이상 경과됨")
                    .font(.sanctumMono(10))
                    .tracking(1)
                    .foregroundColor(.orange.opacity(0.8))
            }

            Button { auth.signOut() } label: {
                Text("다시 등록 요청하기")
                    .font(.sanctumMono(11))
                    .tracking(3)
                    .foregroundColor(AppTheme.obsidian)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(AppTheme.goldGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            }
        }
    }

    // MARK: - 실시간 동기화 상태
    private var syncStatusRow: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(AppTheme.gold.opacity(0.65))
                .frame(width: 5, height: 5)
                .shadow(color: AppTheme.goldenShadow(opacity: 0.6), radius: 3)
            Text("실시간 동기화 중")
                .font(.sanctumMono(9))
                .tracking(1)
                .foregroundColor(AppTheme.warmWhite.opacity(0.32))
        }
    }

    // MARK: - 맥박 애니메이션 (보존)
    private func startPulse() {
        withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: false)) {
            pulseScale = 1.5
        }
    }

    // MARK: - 날짜 / 경과 시간
    private func formatRequestDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy년 M월 d일 HH:mm"
        f.locale = Locale(identifier: "ko_KR")
        return f.string(from: date)
    }

    private func elapsedString(from date: Date) -> String {
        let elapsed = max(now.timeIntervalSince(date), 0)
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        if hours >= 24 {
            let days = hours / 24
            return "\(days)일 \(hours % 24)시간"
        } else if hours > 0 {
            return "\(hours)시간 \(minutes)분"
        } else {
            return "\(max(minutes, 1))분"
        }
    }

    private func isTimeout(requestedAt: Date) -> Bool {
        now.timeIntervalSince(requestedAt) > 48 * 3600
    }
}

// MARK: - 승인 거절 화면
struct RejectedView: View {
    @EnvironmentObject private var auth: AuthService
    @State private var appear = false

    var body: some View {
        ZStack {
            PremiumBackground(style: .warm)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 90, height: 90)
                        .overlay(Circle().stroke(Color.red.opacity(0.4), lineWidth: 1.5))
                        .shadow(color: Color.red.opacity(0.12), radius: 16)
                    Image(systemName: "xmark.shield.fill")
                        .font(.system(size: 38, weight: .light))
                        .foregroundColor(.red.opacity(0.85))
                }
                .scaleEffect(appear ? 1 : 0.7)
                .opacity(appear ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: appear)

                Spacer().frame(height: 28)

                VStack(spacing: 10) {
                    Text("접근이 거절되었습니다")
                        .font(.displayMedium(22))
                        .foregroundColor(AppTheme.warmWhite)
                    Text("관리자에 의해 접근이 거절되었습니다.\n담당 사역자에게 문의해주세요.")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.warmWhite.opacity(0.48))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 40)
                }
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.2), value: appear)

                Spacer()

                Button { auth.signOut() } label: {
                    Text("로그아웃")
                        .font(.sanctumMono(11))
                        .tracking(3)
                        .foregroundColor(AppTheme.warmWhite.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(AppTheme.warmWhite.opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AppTheme.warmWhite.opacity(0.12), lineWidth: 0.5)
                        )
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 48)
                .opacity(appear ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: appear)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { appear = true }
    }
}

#Preview {
    PendingApprovalView()
        .environmentObject(AuthService())
}
