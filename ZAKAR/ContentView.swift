import SwiftUI
import Photos

struct ContentView: View {
    @EnvironmentObject private var photoManager: PhotoManager
    @State private var selectedTab = 0

    private let filterYear: Int?
    private let filterMonth: Int?
    private let initialTabParam: Int

    @State private var showTrashView = false
    @State private var isCleanModeActive = false
    @State private var selectedPhotosForClean: [PHAsset] = []
    @State private var startPosition: Int = 0
    @State private var currentGroupIndex: Int = 0
    @State private var cleanModeID = UUID()
    @State private var pendingCleanModeRetry: (photoIndex: Int, groupIndex: Int?)? = nil

    @State private var showCreateAlbumSheet = false
    @State private var newAlbumName: String = ""

    @State private var showTutorialOverlay = false
    @State private var showAutoCleanDialog = false

    init(initialTab: Int = 0, year: Int? = nil, month: Int? = nil) {
        self._selectedTab = State(initialValue: initialTab)
        self.filterYear = year
        self.filterMonth = month
        self.initialTabParam = initialTab
    }

    // MARK: - Main Content

    @ViewBuilder
    private var mainContent: some View {
        if photoManager.isLoadingList {
            loadingView
        } else {
            ScrollView {
                Color.clear.frame(height: 6)
                if selectedTab == 0 {
                    similarPhotosContent
                } else {
                    allPhotosContent
                }
            }
        }
    }

    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView().tint(AppTheme.gold.opacity(0.7))
            Text("사진 목록 불러오는 중...")
                .font(.sanctumMono(10))
                .tracking(1)
                .foregroundColor(AppTheme.warmWhite.opacity(0.45))
        }
        .padding(24)
        .background(GlassCard(cornerRadius: 20))
        .frame(maxHeight: .infinity)
    }

    // MARK: - Similar Photos Tab

    @ViewBuilder
    private var similarPhotosContent: some View {
        // Section header
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text("SIMILAR")
                    .font(.sanctumMono(9))
                    .tracking(3)
                    .foregroundColor(AppTheme.gold)
                Text(photoManager.isAnalyzing ? "분석 중..." : "\(photoManager.groupedPhotos.count) groups found")
                    .font(.displaySerif(22))
                    .foregroundColor(AppTheme.warmWhite)
            }
            Spacer()
            if photoManager.isAnalyzing {
                ProgressView().tint(AppTheme.gold.opacity(0.6)).scaleEffect(0.8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 6)

        if photoManager.groupedPhotos.isEmpty && !photoManager.isAnalyzing {
            VStack(spacing: 14) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 44, weight: .light))
                    .foregroundColor(AppTheme.gold.opacity(0.5))
                Text("유사 사진이 없습니다")
                    .font(.sanctumMono(11))
                    .tracking(1)
                    .foregroundColor(AppTheme.warmWhite.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(60)
        } else {
            similarGroupsList
        }
    }

    @ViewBuilder
    private var similarGroupsList: some View {
        LazyVStack(spacing: 14) {
            ForEach(photoManager.groupedPhotos.indices, id: \.self) { groupIndex in
                SimilarityGroupRow(group: photoManager.groupedPhotos[groupIndex]) { photoIndex in
                    openCleanMode(at: photoIndex, groupIndex: groupIndex)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(AppTheme.gold.opacity(0.05))
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(AppTheme.gold.opacity(0.18), lineWidth: 0.5)
                        )
                )
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - All Photos Tab

    @ViewBuilder
    private var allPhotosContent: some View {
        // Section header
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text("02 · PHOTOS")
                    .font(.sanctumMono(9))
                    .tracking(3)
                    .foregroundColor(AppTheme.gold)
                Text("All photographs")
                    .font(.displaySerif(22))
                    .foregroundColor(AppTheme.warmWhite)
            }
            Spacer()
            Text("\(photoManager.allPhotos.count)")
                .font(.displayLight(28))
                .foregroundColor(AppTheme.gold.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 6)

        if photoManager.allPhotos.isEmpty {
            VStack(spacing: 14) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 44, weight: .light))
                    .foregroundColor(AppTheme.warmWhite.opacity(0.3))
                Text("사진이 없습니다")
                    .font(.sanctumMono(11))
                    .tracking(1)
                    .foregroundColor(AppTheme.warmWhite.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(60)
        } else {
            photoGrid
        }
    }

    private var photoGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 2)], spacing: 2) {
            ForEach(photoManager.allPhotos.indices, id: \.self) { photoIndex in
                Button {
                    openCleanMode(at: photoIndex, groupIndex: nil)
                } label: {
                    ZStack(alignment: .topLeading) {
                        AssetThumbnail(asset: photoManager.allPhotos[photoIndex], size: 125)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(AppTheme.gold.opacity(photoIndex == 0 ? 0.45 : 0.10), lineWidth: photoIndex == 0 ? 1 : 0.5)
                            )

                        // Gold featured dot on first photo
                        if photoIndex == 0 {
                            Circle()
                                .fill(AppTheme.gold)
                                .frame(width: 7, height: 7)
                                .shadow(color: AppTheme.goldenShadow(opacity: 0.7), radius: 4)
                                .padding(6)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 2)
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                PremiumBackground(style: .deep)

                VStack(spacing: 0) {
                    mainContent
                }
                .padding(.top, 4)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(AppTheme.gold.opacity(0.03))
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(AppTheme.gold.opacity(0.12), lineWidth: 0.5)
                        )
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 8)

                // Tutorial overlay
                if showTutorialOverlay {
                    Color.black.opacity(0.7).ignoresSafeArea()
                        .overlay(
                            VStack(spacing: 18) {
                                Text("— GUIDE —")
                                    .font(.sanctumMono(10))
                                    .tracking(4)
                                    .foregroundColor(AppTheme.gold)

                                Text("스와이프 정리")
                                    .font(.displaySerif(24))
                                    .foregroundColor(AppTheme.warmWhite)

                                Text("위로 스와이프 → 휴지통 이동\n아래로 → 즐겨찾기\n좌/우 → 사진 이동")
                                    .font(.system(size: 13, weight: .light))
                                    .foregroundColor(AppTheme.warmWhite.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)

                                Button {
                                    withAnimation { showTutorialOverlay = false }
                                } label: {
                                    Text("알겠어요")
                                        .font(.sanctumMono(11))
                                        .tracking(3)
                                        .foregroundColor(AppTheme.obsidian)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 48)
                                        .background(AppTheme.goldGradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                                .accessibilityLabel("튜토리얼 닫기")
                            }
                            .padding(24)
                            .background(GlassCard(cornerRadius: 20))
                            .padding(.horizontal, 32)
                        )
                        .transition(.opacity)
                }

                // Floating auto-clean button (Similar tab only)
                if selectedTab == 0 && !photoManager.groupedPhotos.isEmpty && !photoManager.isAnalyzing {
                    VStack {
                        Spacer()
                        Button {
                            showAutoCleanDialog = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("대표만 남기기")
                                    .font(.sanctumMono(11))
                                    .tracking(2)
                            }
                            .foregroundColor(AppTheme.obsidian)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 13)
                            .background(AppTheme.goldGradient)
                            .clipShape(Capsule())
                            .shadow(color: AppTheme.goldenShadow(opacity: 0.4), radius: 12, x: 0, y: 5)
                        }
                        .padding(.bottom, 90)
                        .accessibilityLabel("대표 사진만 자동 선택")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    tabSwitcher
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateAlbumSheet = true
                    } label: {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppTheme.gold.opacity(0.8))
                    }
                    .accessibilityLabel("새 앨범 만들기")
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    TrashBucketButton(count: photoManager.trashAssets.count) {
                        print("ZAKAR Log: ContentView - Opening trash view, trashAssets count: \(photoManager.trashAssets.count)")
                        showTrashView = true
                    }
                }
            }
            .fullScreenCover(isPresented: $isCleanModeActive) {
                CleanUpView(
                    photos: selectedPhotosForClean,
                    startIndex: startPosition,
                    isPresented: $isCleanModeActive,
                    trashAlbum: Binding(
                        get: { photoManager.trashAssets },
                        set: { photoManager.trashAssets = $0; photoManager.saveTrash() }
                    ),
                    photoManager: photoManager,
                    onFinishGroup: { moveToNextGroup() }
                )
                .id(cleanModeID)
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
            .sheet(isPresented: $showCreateAlbumSheet) {
                NavigationView {
                    VStack(spacing: 16) {
                        Text("새 앨범 만들기").font(.headline)
                        TextField("앨범 이름", text: $newAlbumName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        HStack {
                            Button("취소") { showCreateAlbumSheet = false }
                                .foregroundColor(.secondary)
                            Spacer()
                            Button("생성") {
                                let name = newAlbumName.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !name.isEmpty else { return }
                                photoManager.fetchOrCreateAlbum(named: name) { _ in }
                                newAlbumName = ""
                                showCreateAlbumSheet = false
                            }
                            .bold()
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .alert("대표 사진 자동 선택", isPresented: $showAutoCleanDialog) {
                Button("취소", role: .cancel) { }
                Button("시작", role: .destructive) { performAutoClean() }
            } message: {
                let groupCount = photoManager.groupedPhotos.count
                let totalPhotos = photoManager.groupedPhotos.flatMap { $0 }.count
                let estimatedRemoved = totalPhotos - groupCount
                Text("""
                \(groupCount)개 그룹에서 대표 사진을 자동으로 선택합니다.

                • 유지: 약 \(groupCount)장
                • 휴지통 이동: 약 \(estimatedRemoved)장

                선택 기준:
                1. 즐겨찾기 우선
                2. 학습된 사용자 취향
                3. 고화질 & 최신 사진
                """)
            }
            .onAppear {
                self.selectedTab = initialTabParam
                if filterYear != nil || filterMonth != nil {
                    photoManager.fetchPhotos(year: filterYear, month: filterMonth)
                } else {
                    photoManager.fetchPhotos()
                }
                if initialTabParam == 0 || !photoManager.allPhotos.isEmpty {
                    photoManager.analyzeSimilaritiesIfNeeded()
                }
                let hasShown = UserDefaults.standard.bool(forKey: "ZAKAR_TutorialShown")
                if !hasShown {
                    showTutorialOverlay = true
                    UserDefaults.standard.set(true, forKey: "ZAKAR_TutorialShown")
                }
                photoManager.loadTrash()
            }
            .onDisappear {
                if filterYear != nil || filterMonth != nil {
                    print("ZAKAR Log: ContentView - onDisappear, resetting analysis state for filtered view")
                    photoManager.resetAnalysisState()
                }
            }
            .onChange(of: selectedTab) { _, newValue in
                if newValue == 0 { photoManager.analyzeSimilaritiesIfNeeded() }
            }
            .onChange(of: isCleanModeActive) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    if let retry = pendingCleanModeRetry {
                        print("ZAKAR Log: Auto-retry detected - photoIndex: \(retry.photoIndex), groupIndex: \(String(describing: retry.groupIndex))")
                        Task {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            self.pendingCleanModeRetry = nil
                            self.openCleanMode(at: retry.photoIndex, groupIndex: retry.groupIndex)
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenTrash"))) { _ in
                Task {
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    self.showTrashView = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Sanctum Tab Switcher

    private var tabSwitcher: some View {
        HStack(spacing: 4) {
            sanctumTabBtn("SIMILAR", tag: 0)
            sanctumTabBtn("PHOTOS",  tag: 1)
        }
        .padding(3)
        .background(
            AppTheme.graphite.opacity(0.5)
                .background(.ultraThinMaterial),
            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(AppTheme.gold.opacity(0.18), lineWidth: 0.5)
        )
    }

    private func sanctumTabBtn(_ title: String, tag: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.18)) { selectedTab = tag }
        } label: {
            Text(title)
                .font(.sanctumMono(10))
                .tracking(2)
                .foregroundColor(selectedTab == tag ? AppTheme.obsidian : AppTheme.warmWhite.opacity(0.42))
                .padding(.vertical, 7)
                .padding(.horizontal, 14)
                .background(
                    selectedTab == tag
                        ? AnyShapeStyle(AppTheme.goldGradient)
                        : AnyShapeStyle(Color.clear),
                    in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                )
        }
    }

    // MARK: - Preserved Logic

    private func openCleanMode(at photoIndex: Int, groupIndex: Int? = nil) {
        print("ZAKAR Log: openCleanMode called - photoIndex: \(photoIndex), groupIndex: \(String(describing: groupIndex))")
        print("ZAKAR Log: selectedTab: \(selectedTab)")
        print("ZAKAR Log: photoManager.allPhotos.count: \(photoManager.allPhotos.count)")
        print("ZAKAR Log: photoManager.groupedPhotos.count: \(photoManager.groupedPhotos.count)")

        pendingCleanModeRetry = (photoIndex, groupIndex)

        let photoList: [PHAsset]
        let actualGroupIndex: Int

        if let gIndex = groupIndex {
            guard gIndex < photoManager.groupedPhotos.count else {
                print("ZAKAR Log: ERROR - groupIndex \(gIndex) out of range!")
                pendingCleanModeRetry = nil
                return
            }
            photoList = photoManager.groupedPhotos[gIndex]
            actualGroupIndex = gIndex
            print("ZAKAR Log: Using groupedPhotos[\(gIndex)] - count: \(photoList.count)")
        } else {
            photoList = photoManager.allPhotos
            actualGroupIndex = 0
            print("ZAKAR Log: Using allPhotos - count: \(photoList.count)")
        }

        guard !photoList.isEmpty else {
            print("ZAKAR Log: FATAL - photoList is empty! Will auto-retry...")
            return
        }

        guard photoList.indices.contains(photoIndex) else {
            print("ZAKAR Log: ERROR - photoIndex \(photoIndex) out of range (list size: \(photoList.count))!")
            pendingCleanModeRetry = nil
            return
        }

        pendingCleanModeRetry = nil
        self.selectedPhotosForClean = photoList
        self.startPosition = photoIndex
        self.currentGroupIndex = actualGroupIndex
        self.cleanModeID = UUID()

        let asset = photoList[photoIndex]
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false

        print("ZAKAR Log: Pre-fetching first image before opening CleanUpView - photoIndex: \(photoIndex)")

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 600, height: 600),
            contentMode: .aspectFit,
            options: options
        ) { img, info in
            if let img = img {
                print("ZAKAR Log: Pre-fetch completed - size: \(img.size)")
            } else {
                print("ZAKAR Log: Pre-fetch failed or returned nil")
            }
            Task { @MainActor in self.isCleanModeActive = true }
        }
    }

    private func moveToNextGroup() {
        let nextIndex = currentGroupIndex + 1
        print("ZAKAR Log: moveToNextGroup() - 현재 그룹: \(currentGroupIndex), 다음 그룹: \(nextIndex), 전체 그룹: \(photoManager.groupedPhotos.count)")

        if nextIndex < photoManager.groupedPhotos.count {
            isCleanModeActive = false
            print("ZAKAR Log: 다음 그룹 사진 개수: \(photoManager.groupedPhotos[nextIndex].count)")
            Task {
                try? await Task.sleep(nanoseconds: 200_000_000)
                self.openCleanMode(at: 0, groupIndex: nextIndex)
            }
        } else {
            print("ZAKAR Log: 마지막 그룹 완료, CleanUpView 닫기")
            isCleanModeActive = false
        }
    }

    private func performAutoClean() {
        let result = photoManager.autoCleanAllGroups()
        photoManager.loadTrash()
        photoManager.fetchPhotos()
        print("ZAKAR Log: Auto-clean completed - kept: \(result.keptCount), removed: \(result.removedCount)")
    }
}
