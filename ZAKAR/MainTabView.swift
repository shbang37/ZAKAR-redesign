import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var auth: AuthService
    @EnvironmentObject private var photoManager: PhotoManager
    @State private var selectedTab = 0
    @State private var showOnboarding = false

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)

                AlbumsView()
                    .tag(1)

                ArchiveView()
                    .tag(2)

                ProfileView()
                    .tag(3)
            }
            .tint(AppTheme.gold)
            .preferredColorScheme(.dark)
            .toolbar(.hidden, for: .tabBar)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                SanctumTabBar(selected: $selectedTab)
            }

            if showOnboarding {
                Color.black
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.2)
                    )
            }
        }
        .task {
            showOnboarding = !LocalDB.shared.isOnboardingCompleted()

            if !showOnboarding {
                print("🟢 ZAKAR Log: Onboarding completed - loading photos")
                await loadPhotosAsync()
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                LocalDB.shared.setOnboardingCompleted(true)
                showOnboarding = false

                print("🟢 ZAKAR Log: Onboarding finished - loading photos")
                Task {
                    await loadPhotosAsync()
                }
            }
        }
    }

    private func loadPhotosAsync() async {
        photoManager.fetchPhotos()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        photoManager.analyzeSimilaritiesIfNeeded()
    }
}

// MARK: - Sanctum Tab Bar
struct SanctumTabBar: View {
    @Binding var selected: Int

    private let tabs: [(icon: String, label: String)] = [
        ("house.fill",                              "HOME"),
        ("folder",                                  "ALBUMS"),
        ("externaldrive.connected.to.line.below",   "ARCHIVE"),
        ("person.crop.circle",                      "MY")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Gold hairline top border
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.gold.opacity(0.08),
                            AppTheme.gold.opacity(0.38),
                            AppTheme.gold.opacity(0.08)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 0.5)

            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    tabButton(index: index)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
        }
        .background(
            AppTheme.obsidian.opacity(0.88)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    @ViewBuilder
    private func tabButton(index: Int) -> some View {
        let isActive = selected == index
        let tab = tabs[index]

        Button {
            withAnimation(.easeInOut(duration: 0.18)) { selected = index }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isActive ? .semibold : .regular))

                Text(tab.label)
                    .font(.sanctumMono(8))
                    .tracking(2)
            }
            .foregroundColor(isActive ? AppTheme.gold : AppTheme.warmWhite.opacity(0.32))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isActive {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(AppTheme.gold.opacity(0.10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(AppTheme.gold.opacity(0.32), lineWidth: 0.5)
                            )
                            .shadow(color: AppTheme.goldenShadow(opacity: 0.12), radius: 8, x: 0, y: 2)
                    }
                }
            )
            .padding(.horizontal, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
        .environmentObject(PhotoManager())
}
