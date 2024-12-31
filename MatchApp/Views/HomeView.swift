import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var sportManager:  SportManager
    @State private var showingAddPlayerView = false
    @State  var teamName: String = "Example FC"
    @State private var isEditingTeamName = false
    @State private var showEventView = false
    let sports = ["Football", "Basketball", "Volleyball", "Tennis"]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(sports, id: \.self) { sport in
                            Button(action: {
                                sportManager.selectedSport = sport
                                sportManager.fetchPlayers(for: sport)
                            }) {
                                VStack {
                                    Image(systemName: sportIcon(for: sport))
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .padding()
                                        .foregroundColor(sportManager.selectedSport == sport ? .white : .black)
                                        .background(sportManager.selectedSport == sport ? Color.blue : Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                    Text(sport)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding()
                }


                HStack {
                    if isEditingTeamName {
                        TextField("Team Name", text: $teamName)
                            .font(.system(size: 32))
                            .bold()
                            .padding()
                            .padding(.top, -7)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.black)
                    } else {
                        Text(teamName)
                            .font(.system(size: 32))
                            .bold()
                            .padding()
                            .padding(.top, -7)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isEditingTeamName.toggle()
                    }) {
                        Image(systemName: isEditingTeamName ? "checkmark.circle.fill" : "pencil.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                
                
                List {
                    ForEach(sportManager.players[sportManager.selectedSport] ?? []) { player in
                        PlayerRow(player: player)
                    }
                    .onDelete { offsets in
                        sportManager.deletePlayer(at: offsets, from: sportManager.selectedSport)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle(sportManager.selectedSport)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create Event") {
                        showEventView.toggle()
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add Player") {
                        showingAddPlayerView.toggle()
                    }
                }
            }
            .sheet(isPresented: $showEventView) {
                AddEventView(selectedSport: sportManager.selectedSport, homeTeam: teamName)
                    .environmentObject(SportManager())
            }
            .sheet(isPresented: $showingAddPlayerView) {
                AddPlayerView(onSave: { newPlayer in
                    sportManager.addPlayer(newPlayer, for: sportManager.selectedSport)
                }, selectedSport: sportManager.selectedSport)
                .environmentObject(SportManager())
            }
        }
        .onAppear {
            sportManager.fetchPlayers(for: sportManager.selectedSport)
        }
    }
    
    func sportIcon(for sport: String) -> String {
        switch sport {
        case "Football": return "soccerball"
        case "Basketball": return "basketball"
        case "Volleyball": return "volleyball"
        case "Tennis": return "tennisball"
        default: return "sportscourt"
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SportManager())
}
