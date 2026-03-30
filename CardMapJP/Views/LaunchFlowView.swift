import SwiftUI

enum LaunchPhase {
    case splash
    case changelog
    case home
}

struct LaunchFlowView: View {
    @State private var phase: LaunchPhase = .splash
    @State private var opacity: Double = 0

    var body: some View {
        switch phase {
        case .splash:
            ZStack {
                Color(hex: "#CC0000").ignoresSafeArea()

                VStack(spacing: 20) {
                    Image("AppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .shadow(color: .black.opacity(0.3), radius: 10, y: 4)

                    Text("CARDMAP JP")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .tracking(4)
                }
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 0.6)) {
                    opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        phase = .changelog
                    }
                }
            }

        case .changelog:
            ChangelogView {
                withAnimation { phase = .home }
            }

        case .home:
            HomeScreen()
        }
    }
}

// MARK: - Changelog View

struct ChangelogView: View {
    let onDismiss: () -> Void

    private let entries: [ChangelogEntry] = [
        ChangelogEntry(
            version: "1.0",
            date: "2026.03.30",
            items: [
                "🎉 初回リリース",
                "📍 日本全国300以上のポケカショップをマップ表示",
                "🔍 店舗名検索・フィルター機能",
                "⭐ Googleレビュー評価・営業時間表示",
                "🧭 現在地からの距離表示・ルート案内",
                "🏷️ 英語対応・初心者歓迎・PSA取扱フィルター"
            ]
        )
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            VStack(spacing: 0) {
                // ヘッダー
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 28))
                        .foregroundStyle(.yellow)
                    Text("更新履歴")
                        .font(.system(size: 20, weight: .bold))
                }
                .padding(.top, 24)
                .padding(.bottom, 16)

                Divider()

                // コンテンツ
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(entries) { entry in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("v\(entry.version)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(Color(hex: "#CC0000"))
                                    Spacer()
                                    Text(entry.date)
                                        .font(.system(size: 13))
                                        .foregroundStyle(.secondary)
                                }

                                ForEach(entry.items, id: \.self) { item in
                                    Text(item)
                                        .font(.system(size: 14))
                                        .foregroundStyle(.primary)
                                }
                            }
                        }
                    }
                    .padding(20)
                }

                Divider()

                // OKボタン
                Button(action: onDismiss) {
                    Text("OK")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 32)
            .padding(.vertical, 80)
        }
    }
}

struct ChangelogEntry: Identifiable {
    let id = UUID()
    let version: String
    let date: String
    let items: [String]
}

// MARK: - Color hex extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 6:
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8:
            (r, g, b, a) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
