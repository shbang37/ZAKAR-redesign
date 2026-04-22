import SwiftUI
import Photos

struct HomeView: View {
    @EnvironmentObject private var photoManager: PhotoManager
    @State private var metadata: AppMetadata = LocalDB.shared.loadMetadata()

    var body: some View {
        NavigationStack {
            ZStack {
                PremiumBackground(style: .warm)

                ScrollView {
                    VStack(spacing: 24) {
                        headerSection

                        summarySection
                            .padding(.horizontal, 16)

                        recentPhotoSection
                            .padding(.horizontal, 16)

                        editorialHeadline

                        navigationSections

                        chronicleSection

                        footerSection
                            .padding(.bottom, 24)
                    }
                    .padding(.top, 16)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                print("ZAKAR Log: HomeView - onAppear, resetting filters and reloading all photos")
                photoManager.resetAnalysisState()
                photoManager.fetchPhotos(year: nil, month: nil)
                metadata = LocalDB.shared.loadMetadata()
                photoManager.loadTrash()
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - 1. 헤더
    private var headerSection: some View {
        VStack(spacing: 10) {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(AppTheme.glassBorderGradient, lineWidth: 2)
                )
                .shadow(color: AppTheme.goldenShadow(opacity: 0.28), radius: 14, x: 0, y: 4)
                .accessibilityLabel("ZAKAR 로고")

            Text("ZAKAR")
                .font(.sanctumMono(14))
                .tracking(4)
                .foregroundColor(AppTheme.warmWhite)

            Text("자카르")
                .font(.displayItalic(11))
                .foregroundColor(AppTheme.gold)
        }
        .padding(.top, 12)
    }

    // MARK: - 2. 요약 카드
    private var summarySection: some View {
        HomeSummaryCard(
            groupsCount: photoManager.groupedPhotos.count,
            photosCount: photoManager.allPhotos.count,
            estimatedSavedMB: metadata.estimatedSavedMB
        )
    }

    // MARK: - 3. 최근 사진 히어로
    private var recentPhotoSection: some View {
        RecentPhotoCard(photoManager: photoManager)
    }

    // MARK: - 4. 에디토리얼 헤드라인 (신규)
    private var editorialHeadline: some View {
        VStack(spacing: 10) {
            GoldDivider(width: 32)

            Text("Every moment, kept.")
                .font(.displayLightItalic(38))
                .foregroundColor(AppTheme.warmWhite.opacity(0.88))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 4)
    }

    // MARK: - 5. 네비게이션 섹션
    private var navigationSections: some View {
        VStack(spacing: 10) {
            NavigationLink(destination: ContentView(initialTab: 1)) {
                SanctumSectionCard(
                    title: "모든 사진",
                    subtitle: "All photographs",
                    icon: "photo.stack",
                    count: photoManager.allPhotos.count,
                    isLoading: photoManager.isLoadingList
                )
            }

            NavigationLink(destination: ContentView(initialTab: 0).id(UUID())) {
                SanctumSectionCard(
                    title: "유사 사진",
                    subtitle: "Similar groups · AI",
                    icon: "square.on.square.dashed",
                    count: photoManager.groupedPhotos.reduce(0) { $0 + $1.count },
                    isLoading: photoManager.isAnalyzing,
                    isHighlighted: true
                )
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    // MARK: - 6. Chronicle 월별
    private var chronicleSection: some View {
        MonthlyCleanupSection(photoManager: photoManager)
    }

    // MARK: - 7. 푸터
    private var footerSection: some View {
        VStack(spacing: 12) {
            GoldDivider(width: 36)
            Text("모든 은혜를 기억합니다")
                .font(.displayItalic(13))
                .foregroundColor(AppTheme.goldLight.opacity(0.7))
        }
        .padding(.top, 8)
    }
}

// MARK: - Sanctum Section Card
private struct SanctumSectionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let count: Int
    var isLoading: Bool = false
    var isHighlighted: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(AppTheme.gold)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppTheme.gold.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppTheme.gold.opacity(0.28), lineWidth: 0.5)
                        )
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(AppTheme.warmWhite)
                Text(subtitle)
                    .font(.sanctumMono(10))
                    .tracking(1)
                    .foregroundColor(AppTheme.gold.opacity(0.65))
            }

            Spacer()

            HStack(spacing: 6) {
                if isLoading {
                    ProgressView()
                        .tint(AppTheme.gold.opacity(0.5))
                        .scaleEffect(0.75)
                } else if count > 0 {
                    Text("\(count)")
                        .font(.displayLight(26))
                        .foregroundColor(isHighlighted ? AppTheme.gold : AppTheme.warmWhite.opacity(0.8))
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(AppTheme.gold.opacity(0.45))
            }
        }
        .padding(16)
        .background(GlassCard(cornerRadius: 16, style: isHighlighted ? .premium : .subtle))
        .contentShape(Rectangle())
    }
}

// MARK: - 최근 사진 히어로 카드
private struct RecentPhotoCard: View {
    @ObservedObject var photoManager: PhotoManager
    @State private var recentPhoto: PHAsset?
    @State private var thumbnail: UIImage?
    @State private var showCleanUpView = false
    @State private var showTrashView = false
    @State private var isLoading = false
    @State private var trashNotificationTask: Task<Void, Never>?

    var body: some View {
        Button {
            if recentPhoto != nil { showCleanUpView = true }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                heroImage
                cardBottom
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.gold.opacity(0.22), lineWidth: 0.5)
            )
            .shadow(color: AppTheme.goldenShadow(opacity: 0.14), radius: 18, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .onAppear { loadRecentPhoto() }
        .onChange(of: photoManager.allPhotos.count) { _, _ in
            loadRecentPhoto()
        }
        .fullScreenCover(isPresented: $showCleanUpView) {
            if let photo = recentPhoto,
               let index = photoManager.allPhotos.firstIndex(of: photo) {
                CleanUpView(
                    photos: photoManager.allPhotos,
                    startIndex: index,
                    isPresented: $showCleanUpView,
                    trashAlbum: Binding(
                        get: { photoManager.trashAssets },
                        set: { photoManager.trashAssets = $0; photoManager.saveTrash() }
                    ),
                    photoManager: photoManager
                )
            }
        }
        .sheet(isPresented: $showTrashView) {
            TrashView(
                trashAssets: Binding(
                    get: { photoManager.trashAssets },
                    set: { photoManager.trashAssets = $0; photoManager.saveTrash() }
                ),
                photoManager: photoManager
            ) {
                photoManager.fetchPhotos()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenTrash"))) { _ in
            trashNotificationTask?.cancel()
            trashNotificationTask = Task {
                try? await Task.sleep(nanoseconds: 300_000_000)
                guard !Task.isCancelled else { return }
                self.showTrashView = true
            }
        }
        .onDisappear {
            trashNotificationTask?.cancel()
        }
    }

    @ViewBuilder
    private var heroImage: some View {
        ZStack(alignment: .topLeading) {
            if let img = thumbnail {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    .clipped()

                // Gold light cone overlay
                LinearGradient(
                    colors: [AppTheme.gold.opacity(0.20), .clear],
                    startPoint: .topLeading,
                    endPoint: .center
                )
                .frame(height: 280)
                .allowsHitTesting(false)

                // Time badge
                if let asset = recentPhoto {
                    Text(timeSince(asset))
                        .font(.sanctumMono(9))
                        .tracking(1)
                        .foregroundColor(AppTheme.warmWhite.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(AppTheme.obsidian.opacity(0.72))
                                .overlay(
                                    Capsule()
                                        .stroke(AppTheme.gold.opacity(0.38), lineWidth: 0.5)
                                )
                        )
                        .padding(14)
                }
            } else {
                Rectangle()
                    .fill(AppTheme.graphite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    .overlay(
                        VStack(spacing: 10) {
                            ProgressView().tint(AppTheme.gold.opacity(0.5))
                            Text("사진 불러오는 중...")
                                .font(.sanctumMono(10))
                                .foregroundColor(AppTheme.warmWhite.opacity(0.35))
                        }
                    )
            }
        }
    }

    private var cardBottom: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Begin curating.")
                .font(.displayLightItalic(24))
                .foregroundColor(AppTheme.warmWhite.opacity(0.9))

            // CTA visual row (tap handled by outer Button)
            HStack {
                Text("정리 시작하기")
                    .font(.sanctumMono(11))
                    .tracking(3)
                    .foregroundColor(AppTheme.obsidian)
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(AppTheme.obsidian)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(AppTheme.goldGradient)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [AppTheme.gold.opacity(0.07), AppTheme.obsidian.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .background(.ultraThinMaterial)
        )
    }

    private func timeSince(_ asset: PHAsset) -> String {
        guard let date = asset.creationDate else { return "" }
        let diff = Date().timeIntervalSince(date)
        if diff < 60 { return "방금" }
        if diff < 3600 { return "\(Int(diff / 60))분 전" }
        if diff < 86400 { return "\(Int(diff / 3600))시간 전" }
        return "\(Int(diff / 86400))일 전"
    }

    private func loadRecentPhoto() {
        guard !photoManager.allPhotos.isEmpty else {
            print("ZAKAR Log: RecentPhoto - allPhotos is empty, waiting...")
            return
        }
        print("ZAKAR Log: RecentPhoto - allPhotos has \(photoManager.allPhotos.count) photos")
        recentPhoto = photoManager.allPhotos.first
        guard let asset = recentPhoto else {
            print("ZAKAR Log: RecentPhoto - Failed to get first asset")
            return
        }
        print("ZAKAR Log: RecentPhoto - Starting image request for asset: \(asset.localIdentifier)")
        isLoading = true
        let manager = PHImageManager.default()
        let fastOptions = PHImageRequestOptions()
        fastOptions.deliveryMode = .fastFormat
        fastOptions.resizeMode = .fast
        fastOptions.isNetworkAccessAllowed = true
        fastOptions.isSynchronous = false
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 300, height: 400),
            contentMode: .aspectFill,
            options: fastOptions
        ) { image, info in
            print("ZAKAR Log: RecentPhoto - Image callback received")
            if let image = image {
                Task { @MainActor in
                    self.thumbnail = image
                    self.isLoading = false
                    print("ZAKAR Log: RecentPhoto - Fast thumbnail loaded successfully!")
                }
                self.loadHighQualityImage(for: asset, manager: manager)
            } else {
                print("ZAKAR Log: RecentPhoto - Image is nil, info: \(String(describing: info))")
            }
        }
    }

    private func loadHighQualityImage(for asset: PHAsset, manager: PHImageManager) {
        let hqOptions = PHImageRequestOptions()
        hqOptions.deliveryMode = .opportunistic
        hqOptions.isNetworkAccessAllowed = true
        hqOptions.isSynchronous = false
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 800, height: 1000),
            contentMode: .aspectFill,
            options: hqOptions
        ) { image, info in
            if let image = image {
                Task { @MainActor in
                    self.thumbnail = image
                    print("ZAKAR Log: High quality thumbnail loaded")
                }
            }
        }
    }
}

// MARK: - 월별 데이터 모델
struct MonthData: Identifiable {
    let id = UUID()
    let year: Int
    let month: Int
    let photoCount: Int
    let isCurrentMonth: Bool

    var displayText: String { "\(year)년 \(month)월" }
}

// MARK: - Chronicle 월별 섹션
private struct MonthlyCleanupSection: View {
    @ObservedObject var photoManager: PhotoManager
    @State private var monthlyData: [MonthData] = []

    private let monthAbbrevs = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Section header
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("CHRONICLE")
                        .font(.sanctumMono(10))
                        .tracking(4)
                        .foregroundColor(AppTheme.gold)
                    Text("By month")
                        .font(.displaySerif(22))
                        .foregroundColor(AppTheme.warmWhite)
                }
                Spacer()
            }
            .padding(.horizontal, 16)

            // Horizontal scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(monthlyData) { data in
                        MonthChronicleCard(
                            data: data,
                            abbrev: monthAbbrevs[safe: data.month] ?? "\(data.month)"
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 200_000_000)
                loadMonthlyData()
            }
        }
        .onChange(of: photoManager.allPhotos.count) { _, newCount in
            if newCount > 100 || monthlyData.isEmpty {
                loadMonthlyData()
            }
        }
    }

    private func loadMonthlyData() {
        print("ZAKAR Log: MonthlyCleanupSection - Loading monthly data from \(photoManager.allPhotos.count) photos")
        monthlyData = photoManager.getMonthlyPhotoData()
        print("ZAKAR Log: MonthlyCleanupSection - Loaded \(monthlyData.count) months")
    }
}

// MARK: - 개별 Chronicle 카드
private struct MonthChronicleCard: View {
    let data: MonthData
    let abbrev: String

    var body: some View {
        NavigationLink(destination: ContentView(initialTab: 1, year: data.year, month: data.month)) {
            VStack(alignment: .leading, spacing: 0) {
                // Month name
                Text(abbrev)
                    .font(.displayLightItalic(38))
                    .tracking(-1)
                    .foregroundColor(data.isCurrentMonth ? AppTheme.gold : AppTheme.warmWhite.opacity(0.85))
                    .lineLimit(1)

                // Year
                Text(String(data.year))
                    .font(.sanctumMono(9))
                    .foregroundColor(AppTheme.warmWhite.opacity(0.4))
                    .padding(.top, 2)

                Spacer()

                // Count
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text("\(data.photoCount)")
                        .font(.displayLight(24))
                        .foregroundColor(data.isCurrentMonth ? AppTheme.gold : AppTheme.warmWhite.opacity(0.75))
                    Text("장")
                        .font(.sanctumMono(9))
                        .foregroundColor(AppTheme.warmWhite.opacity(0.4))
                }

                // Active dot for current month
                if data.isCurrentMonth {
                    Circle()
                        .fill(AppTheme.gold)
                        .frame(width: 5, height: 5)
                        .shadow(color: AppTheme.goldenShadow(opacity: 0.6), radius: 4)
                        .padding(.top, 8)
                }
            }
            .padding(16)
            .frame(width: 118, height: 160)
            .background(GlassCard(cornerRadius: 16, style: data.isCurrentMonth ? .premium : .subtle))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        data.isCurrentMonth ? AppTheme.gold.opacity(0.45) : Color.clear,
                        lineWidth: data.isCurrentMonth ? 1 : 0
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Safe subscript helper
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
