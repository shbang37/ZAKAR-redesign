import SwiftUI

// MARK: - 홈 요약 카드 (Sanctum 3열 통계 훅)
struct HomeSummaryCard: View {
    var groupsCount: Int
    var photosCount: Int = 0
    var lastCleanupDate: Date? = nil   // 레거시 호환성 유지
    var estimatedSavedMB: Double?

    var body: some View {
        HStack(spacing: 0) {
            statColumn(
                value: "\(groupsCount)",
                label: "GROUPS",
                isGold: groupsCount > 0,
                showDot: groupsCount > 0
            )

            columnDivider

            statColumn(
                value: "\(photosCount)",
                label: "PHOTOS",
                isGold: false
            )

            columnDivider

            statColumn(
                value: savedText,
                label: "SAVED",
                isGold: false
            )
        }
        .padding(.vertical, 20)
        .background(GlassCard(cornerRadius: 18))
    }

    // MARK: - Helpers

    private var savedText: String {
        guard let mb = estimatedSavedMB, mb > 0 else { return "—" }
        return mb >= 1024
            ? String(format: "%.1fGB", mb / 1024)
            : String(format: "%.0fMB", mb)
    }

    private var lastCleanupText: String {
        guard let date = lastCleanupDate else { return "없음" }
        let daysAgo = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        if daysAgo == 0 { return "오늘" }
        if daysAgo <= 7 { return "\(daysAgo)일 전" }
        let f = DateFormatter()
        f.dateFormat = "MM/dd"
        return f.string(from: date)
    }

    // MARK: - Sub Views

    private func statColumn(
        value: String,
        label: String,
        isGold: Bool,
        showDot: Bool = false
    ) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.displayLight(32))
                .tracking(-0.5)
                .foregroundColor(isGold ? AppTheme.gold : AppTheme.warmWhite.opacity(0.85))
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            HStack(spacing: 5) {
                if showDot {
                    Circle()
                        .fill(AppTheme.gold)
                        .frame(width: 4, height: 4)
                        .shadow(color: AppTheme.goldenShadow(opacity: 0.6), radius: 3)
                }
                Text(label)
                    .font(.sanctumMono(9))
                    .tracking(2)
                    .foregroundColor(isGold ? AppTheme.gold.opacity(0.8) : AppTheme.warmWhite.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var columnDivider: some View {
        Rectangle()
            .fill(AppTheme.gold.opacity(0.12))
            .frame(width: 0.5)
            .padding(.vertical, 8)
    }
}

#Preview {
    ZStack {
        AppTheme.obsidian.ignoresSafeArea()
        HomeSummaryCard(groupsCount: 12, photosCount: 3481, estimatedSavedMB: 320)
            .padding()
    }
}
