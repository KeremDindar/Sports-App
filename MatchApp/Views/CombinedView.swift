import SwiftUI

struct CombinedView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var sporManager: SportManager
    @EnvironmentObject var historyManager: HistoryManager
    let teamName: String
    let players: [Player]
    let substitutes: [Player]
    let eventDetail: EventDetails
    @Environment(\.dismiss) var dismiss
    let selectedSport: String
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Picker("Select View", selection: $selectedTab) {
                    Text("Players").tag(0)
                    Text("Event Details").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    sportSpecificPlayersView()
                } else {
                    EventDetailView(eventDetail: eventDetail)
                }
            }
            .navigationTitle("Match & Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Share Button
                    Button(action: shareEventDetails) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: createHistoryItem) {
                        Text("Create")
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func shareEventDetails() {
        let activityViewController = UIActivityViewController(activityItems: [eventDetail.eventName, eventDetail.location], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }

    private func createHistoryItem() {
        let historyItem = HistoryItem(
            teamName: teamName,
            players: players,
            substitutes: substitutes,
            eventDetail: eventDetail,
            selectedSport: selectedSport
        )
        historyManager.addHistoryItem(historyItem)
        dismiss()
    }

    
    private func sportSpecificPlayersView() -> some View {
        switch selectedSport {
        case "Football":
            return AnyView(footballPlayerView())
        case "Basketball":
            return AnyView(basketballPlayerView())
        case "Volleyball":
            return AnyView(volleyballPlayerView())
        case "Tennis":
            return AnyView(tennisPlayerView())
        default:
            return AnyView(Text("böyle view yok"))
        }
    }

    private func footballPlayerView() -> some View {
        switch eventDetail.playerCount {
        case .sixSix:
            return AnyView(SixsixFormasyon(teamName: teamName, players: players))
        case .sevenSeven:
            return AnyView(MatchLineupView(teamName: teamName, players: players))
        case .eightEight:
            return AnyView(EighEightFormasyon(teamName: teamName, players: players))
        default:
            return AnyView(Text(" böyle view yok futbol"))
        }
    }

    private func basketballPlayerView() -> some View {
        ScrollView {
            VStack {
                Section(header: Text("Main Players").font(.headline)) {
                    ForEach(players.prefix(5)) { player in
                        PlayerRow(player: player)
                            .padding(.horizontal)
                    }
                }
                Section(header: Text("Substitutes").font(.headline).padding(.top, 10)) {
                    ForEach(players.dropFirst(5)) { player in
                        PlayerRow(player: player)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }

    private func volleyballPlayerView() -> some View {
        ScrollView {
            VStack {
                Section(header: Text("Main Players").font(.headline)) {
                    ForEach(players.prefix(5)) { player in
                        PlayerRow(player: player)
                            .padding(.horizontal)
                    }
                }
                Section(header: Text("Substitutes").font(.headline).padding(.top, 10)) {
                    ForEach(players.dropFirst(5)) { player in
                        PlayerRow(player: player)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }

    private func tennisPlayerView() -> some View {
        ScrollView {
            VStack {
                ForEach(players.prefix(1)) { player in
                    PlayerRow(player: player)
                        .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    CombinedView(
        teamName: "Fenerbahçe",
        players: Player.sample,
        substitutes: [
            Player(firstName: "Can", lastName: "Eren", overall: 75, position: "Defender"),
            Player(firstName: "Serkan", lastName: "Yıldırım", overall: 80, position: "Midfielder")
        ],
        eventDetail: EventDetails(
            eventName: "Champions League Final",
            location: "Istanbul",
            district: "Kadikoy",
            date: .now,
            iban: "TR123456789012345678901234",
            entryFee: "100",
            homeTeam: "Fenerbahçe",
            awayTeam: "Galatasaray",
            playerCount: .sevenSeven
        ), selectedSport: "Football"
    )
    .environmentObject(SportManager())
    .environmentObject(HistoryManager())
}
