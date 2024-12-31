import SwiftUI




struct MatchLineupView: View {
    let teamName: String
    @State var players: [Player]
    @EnvironmentObject var sportManager: SportManager
    @State private var showingSubstitutePicker = false
    @State private var playerPositions: [CGPoint] = []
    @State private var selectedFormation: Formation = .twoThreeOne
    @State private var selectedPlayerIndex: Int?
    @State private var substitutes: [Player] = []
    
    
    enum Formation: String, CaseIterable, Identifiable {
        case twoThreeOne = "2-3-1"
        case threeTwoOne = "3-2-1"
        case oneFourOne = "1-4-1"
        
        var id: String { self.rawValue }
        
        var layout: [[CGPoint]] {
            switch self {
            case .twoThreeOne:
                return [
                    [CGPoint(x: 0.5, y: 0.84)],
                    [CGPoint(x: 0.25, y: 0.7), CGPoint(x: 0.75, y: 0.7)],
                    [CGPoint(x: 0.15, y: 0.5), CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0.85, y: 0.5)],
                    [CGPoint(x: 0.5, y: 0.3)]
                ]
            case .threeTwoOne:
                return [
                    [CGPoint(x: 0.5, y: 0.84)],
                    [CGPoint(x: 0.2, y: 0.7), CGPoint(x: 0.5, y: 0.7), CGPoint(x: 0.8, y: 0.7)],
                    [CGPoint(x: 0.35, y: 0.5), CGPoint(x: 0.65, y: 0.5)],
                    [CGPoint(x: 0.5, y: 0.3)]
                ]
            case .oneFourOne:
                return [
                    [CGPoint(x: 0.5, y: 0.84)],
                    [CGPoint(x: 0.5, y: 0.7)],
                    [CGPoint(x: 0.15, y: 0.5), CGPoint(x: 0.35, y: 0.5), CGPoint(x: 0.65, y: 0.5), CGPoint(x: 0.85, y: 0.5)],
                    [CGPoint(x: 0.5, y: 0.3)]
                ]
            }
        }
    }
    
    init(teamName: String, players: [Player]) {
        self.teamName = teamName
        self.players = players
        self._substitutes = State(initialValue: Array(players.dropFirst(7)))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Formation", selection: $selectedFormation) {
                    ForEach(Formation.allCases) { formation in
                        Text(formation.rawValue).tag(formation)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedFormation) { _ in
                    updatePlayerPositions()
                }
                
                GeometryReader { geometry in
                    ZStack {
                        Image("saha")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                        ForEach(players.indices, id: \.self) { index in
                            if index < playerPositions.count {
                                DraggablePlayerView(
                                    player: players[index],
                                    position: Binding(
                                        get: { // başlangıç pozisyonu bulmak için kullanılır
                                            CGPoint(
                                                x: playerPositions[index].x * geometry.size.width,
                                                y: playerPositions[index].y * geometry.size.height
                                            )
                                        },
                                        set: { newPosition in // yeni pozisyon için kullanılır
                                            print("height: ",geometry.size.height)
                                            print("y value : ",newPosition.y)
                                            playerPositions[index] = CGPoint(
                                                x: newPosition.x / geometry.size.width ,
                                                y: newPosition.y / geometry.size.height
                                            )
                                            resolveCollisions(for: index)
                                        }
                                    ),
                                    onTap: {
                                        selectedPlayerIndex = index
                                        showingSubstitutePicker = true
                                    }
                                )
                                
                            }
                        }
                    }
                    .onAppear {
                        updatePlayerPositions()
                    }
                }
                
                
                
                
            }
            
            .sheet(isPresented: $showingSubstitutePicker) {
                SubstitutePicker(substitutes: substitutes) { selectedSubstitute in
                    if let index = selectedPlayerIndex {
                        let removedPlayer = players[index]
                        players[index] = selectedSubstitute
                        substitutes.append(removedPlayer)
                        substitutes.removeAll { $0.id == selectedSubstitute.id }
                    }
                    showingSubstitutePicker = false
                }
            }
            .onAppear {
                          
                           sportManager.fetchPlayers(for: "Football")  
                           players = sportManager.players["Football"] ?? []
                       }
            .navigationTitle(teamName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func updatePlayerPositions() {
        playerPositions = selectedFormation.layout.flatMap { $0 }
        resolveCollisions(for: -1)
    }
    
    private func resolveCollisions(for draggedIndex: Int) {
        let minimumDistance: CGFloat = 0.12
        
        for i in 0..<playerPositions.count {
            if draggedIndex == -1 || i == draggedIndex {
                for j in 0..<playerPositions.count where i != j {
                    let distance = hypot(
                        playerPositions[i].x - playerPositions[j].x,
                        playerPositions[i].y - playerPositions[j].y
                    )
                    if distance < minimumDistance {
                        let offset = (minimumDistance - distance) / 2
                        playerPositions[i].x += offset
                        playerPositions[i].y += offset
                    }
                }
            }
        }
        
    }
    
}


struct MatchLineupView_Previews: PreviewProvider {
    static var previews: some View {
        MatchLineupView(teamName: "Fenerbahçe", players: Player.sample)
            .environmentObject(SportManager())
            .environmentObject(HistoryManager())
    }
}


