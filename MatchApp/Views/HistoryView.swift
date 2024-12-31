//
//  HistoryView.swift
//  MatchApp
//
//  Created by Kerem on 14.12.2024.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyManager: HistoryManager
    @State private var selectedHistoryItem: HistoryItem?

    var body: some View {
        NavigationView {
            List(historyManager.historyItems) { item in
                NavigationLink(destination: HistoryDetailView(historyItem: item)) {
                    Text("\(item.eventDetail.eventName) - \(item.teamName)")
                        .bold()
                }
            

            }
            .navigationTitle("History")
        }
        .onAppear {
            historyManager.loadHistoryItems()
          
        }
    }
}


#Preview {
    let testHistoryManager = HistoryManager()
    testHistoryManager.addHistoryItem(
        HistoryItem(
            teamName: "Fenerbahçe",
            players: Player.sample,
            substitutes: [],
            eventDetail: EventDetails(
                eventName: "Test Event",
                location: "Kadikoy",
                district: "Kadikoy",
                date: .now,
                iban: "TR123456789012345678901234",
                entryFee: "100",
                homeTeam: "Fenerbahçe",
                awayTeam: "Galatasaray",
                playerCount: .sevenSeven
            ),
            selectedSport: "Football"
        )
    )
    return HistoryView()
        .environmentObject(testHistoryManager)
}


struct HistoryDetailView: View {
    let historyItem: HistoryItem
    @State private var selectedTab: DetailTab = .players

    var body: some View {
        VStack {
            Picker("Details", selection: $selectedTab) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            
            switch selectedTab {
            case .players:
                switch historyItem.selectedSport {
                case "Football":
                    matchFormationView()
                        .disabled(true)
                case "Basketball":
                    basketballPlayersView()
                case "Volleyball":
                    volleyballPlayersView()
                case "Tennis":
                    tennisPlayerView()
                default:
                    Text("Unknown Sport")
                }
            case .eventDetails:
                EventDetailView(eventDetail: historyItem.eventDetail)
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func matchFormationView() -> some View {
        switch historyItem.eventDetail.playerCount {
        case .sixSix:
            return AnyView(SixsixFormasyon(teamName: historyItem.teamName, players: historyItem.players))
        case .sevenSeven:
            return AnyView(MatchLineupView(teamName: historyItem.teamName, players: historyItem.players))
        case .eightEight:
            return AnyView(EighEightFormasyon(teamName: historyItem.teamName, players: historyItem.players))
        default:
            return AnyView(Text("böyle maç yok"))
        }
    }
    

    private func basketballPlayersView() -> some View {
        ScrollView {
            VStack {
                Section(header: Text("Main Players").font(.headline)) {
                    ForEach(historyItem.players.prefix(5)) { player in
                        PlayerRow(player: player)
                            .padding(.horizontal)
                    }
                }
                Section(header: Text("Substitutes").padding(.top, 10).font(.headline)) {
                    ForEach(historyItem.players.dropFirst(5)) { player in
                        PlayerRow(player: player)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .disabled(true) 
    }

    private func volleyballPlayersView() -> some View {
        ScrollView {
            VStack {
                Section(header: Text("Main Players").font(.headline)) {
                    ForEach(historyItem.players.prefix(5)) { player in
                        PlayerRow(player: player)
                            .padding(.horizontal)
                    }
                }
                Section(header: Text("Substitutes").padding(.top, 10).font(.headline)) {
                    ForEach(historyItem.players.dropFirst(5)) { player in
                        PlayerRow(player: player)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .disabled(true)     }

    private func tennisPlayerView() -> some View {
        ScrollView {
            VStack {
                ForEach(historyItem.players.prefix(1)) { player in
                    PlayerRow(player: player)
                        .padding(.horizontal)
                }
            }
        }
        .disabled(true)
    }
}

enum DetailTab: String, CaseIterable {
    case players = "Players"
    case eventDetails = "Event Details"
}
