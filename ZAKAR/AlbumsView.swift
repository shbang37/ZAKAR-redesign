import SwiftUI
import Photos

struct AlbumsView: View {
    @State private var albums: [PHAssetCollection] = []
    @State private var smartAlbums: [PHAssetCollection] = []
    @State private var isAuthorized = false

    var body: some View {
        NavigationView {
            ZStack {
                PremiumBackground(style: .warm)

                ScrollView {
                    VStack(spacing: 24) {
                        if !albums.isEmpty {
                            albumSection(title: "내 앨범", collections: albums, icon: "folder.fill")
                        }
                        if !smartAlbums.isEmpty {
                            albumSection(title: "스마트 앨범", collections: smartAlbums, icon: "folder")
                        }
                        Spacer(minLength: 20)
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ALBUMS")
                        .font(.sanctumMono(12))
                        .tracking(3)
                        .foregroundColor(AppTheme.warmWhite)
                }
            }
        }
        .onAppear { requestAndFetch() }
    }

    private func albumSection(title: String, collections: [PHAssetCollection], icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title.uppercased())
                    .font(.sanctumMono(10))
                    .tracking(2)
                    .foregroundColor(AppTheme.gold.opacity(0.6))
                Spacer()
                Text("\(collections.count)")
                    .font(.sanctumMono(10))
                    .foregroundColor(AppTheme.gold.opacity(0.4))
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)

            VStack(spacing: 8) {
                ForEach(collections, id: \.localIdentifier) { collection in
                    NavigationLink(destination: AlbumDetailView(collection: collection)) {
                        albumCard(
                            icon: icon,
                            title: collection.localizedTitle ?? "앨범",
                            count: getAssetCount(for: collection)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func albumCard(icon: String, title: String, count: Int) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(AppTheme.gold.opacity(0.08))
                    .frame(width: 36, height: 36)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(AppTheme.gold.opacity(0.28), lineWidth: 0.8)
                    )
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.gold.opacity(0.75))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.warmWhite)
                Text("\(count)개 항목")
                    .font(.sanctumMono(10))
                    .foregroundColor(AppTheme.warmWhite.opacity(0.38))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(AppTheme.gold.opacity(0.35))
        }
        .padding(14)
        .background(GlassCard(cornerRadius: 14, style: .subtle))
        .contentShape(Rectangle())
    }

    private func getAssetCount(for collection: PHAssetCollection) -> Int {
        PHAsset.fetchAssets(in: collection, options: nil).count
    }

    private func requestAndFetch() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                isAuthorized = (status == .authorized || status == .limited)
                guard isAuthorized else { return }
                fetchAlbums()
            }
        }
    }

    private func fetchAlbums() {
        var result: [PHAssetCollection] = []
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        userAlbums.enumerateObjects { collection, _, _ in result.append(collection) }
        self.albums = result

        var smart: [PHAssetCollection] = []
        let smartFetch = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        smartFetch.enumerateObjects { collection, _, _ in
            switch collection.assetCollectionSubtype {
            case .smartAlbumUserLibrary,
                 .smartAlbumFavorites,
                 .smartAlbumVideos,
                 .smartAlbumLivePhotos:
                smart.append(collection)
            default:
                break
            }
        }
        self.smartAlbums = smart
    }
}

struct AlbumDetailView: View {
    let collection: PHAssetCollection
    @State private var assets: [PHAsset] = []
    @EnvironmentObject var photoManager: PhotoManager
    @State private var isCleanModeActive = false
    @State private var selectedPhotoIndex = 0
    @State private var trashAssets: [PHAsset] = []

    private let grid = [GridItem(.adaptive(minimum: 100), spacing: 2)]

    var body: some View {
        ZStack {
            PremiumBackground(style: .warm)

            ScrollView {
                LazyVGrid(columns: grid, spacing: 2) {
                    ForEach(assets.indices, id: \.self) { index in
                        AssetThumbnail(asset: assets[index], size: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(AppTheme.gold.opacity(0.12), lineWidth: 0.5)
                            )
                            .onTapGesture {
                                selectedPhotoIndex = index
                                isCleanModeActive = true
                            }
                    }
                }
                .padding(8)
            }
        }
        .navigationTitle(collection.localizedTitle ?? "앨범")
        .onAppear { fetchAssets() }
        .fullScreenCover(isPresented: $isCleanModeActive) {
            CleanUpView(
                photos: assets,
                startIndex: selectedPhotoIndex,
                isPresented: $isCleanModeActive,
                trashAlbum: $trashAssets,
                photoManager: photoManager
            )
        }
    }

    private func fetchAssets() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetch = PHAsset.fetchAssets(in: collection, options: options)
        var temp: [PHAsset] = []
        fetch.enumerateObjects { asset, _, _ in temp.append(asset) }
        self.assets = temp
    }
}

#Preview { AlbumsView() }
