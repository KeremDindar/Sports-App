//import SwiftUI
//
//struct BasketballLineupView: View {
//    let teamName: String
//    @State var players: [Player]
//    @State private var playerPositions: [CGPoint] = []
//    @State private var selectedFormation: Formation = .threeTwo
//    @State private var showingSubstitutePicker = false
//    @State private var selectedPlayerIndex: Int?
//
//
//    enum Formation: String, CaseIterable, Identifiable {
//        case threeTwo = "3-2"
//        case twoThree = "2-3"
//        case oneFour = "1-4"
//
//        var id: String { self.rawValue }
//
//        var layout: [[CGPoint]] {
//            switch self {
//            case .threeTwo:
//                return [
//                    [CGPoint(x: 0.5, y: 0.8)], // Center
//                    [CGPoint(x: 0.3, y: 0.6), CGPoint(x: 0.7, y: 0.6)], // Forwards
//                    [CGPoint(x: 0.2, y: 0.4), CGPoint(x: 0.8, y: 0.4)]  // Guards
//                ]
//            case .twoThree:
//                return [
//                    [CGPoint(x: 0.5, y: 0.8)], // Center
//                    [CGPoint(x: 0.25, y: 0.6), CGPoint(x: 0.75, y: 0.6)], // Guards
//                    [CGPoint(x: 0.2, y: 0.4), CGPoint(x: 0.4, y: 0.4), CGPoint(x: 0.6, y: 0.4), CGPoint(x: 0.8, y: 0.4)]  // Forwards
//                ]
//            case .oneFour:
//                return [
//                    [CGPoint(x: 0.5, y: 0.8)], // Center
//                    [CGPoint(x: 0.3, y: 0.6), CGPoint(x: 0.7, y: 0.6)], // Guards
//                    [CGPoint(x: 0.2, y: 0.4), CGPoint(x: 0.8, y: 0.4)] // Forwards
//                ]
//            }
//        }
//    }
//
//    init(teamName: String, players: [Player]) {
//        self.teamName = teamName
//        self.players = players
//    }
//
//    var body: some View {
//        VStack {
//            Picker("Formation", selection: $selectedFormation) {
//                ForEach(Formation.allCases) { formation in
//                    Text(formation.rawValue).tag(formation)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//            .onChange(of: selectedFormation) { _ in
//                updatePlayerPositions()
//            }
//
//            GeometryReader { geometry in
//                ZStack {
//                    Image("basket") // Basketbol sahası resmini kullanıyoruz
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: geometry.size.width, height: geometry.size.height)
//
//                    ForEach(players.indices, id: \.self) { index in
//                        if index < playerPositions.count {
//                            DraggablePlayerView(
//                                player: players[index],
//                                position: Binding(
//                                    get: {
//                                        CGPoint(
//                                            x: playerPositions[index].x * geometry.size.width,
//                                            y: playerPositions[index].y * geometry.size.height
//                                        )
//                                    },
//                                    set: { newPosition in
//                                        playerPositions[index] = CGPoint(
//                                            x: newPosition.x / geometry.size.width,
//                                            y: newPosition.y / geometry.size.height
//                                        )
//                                        resolveCollisions(for: index)
//                                    }
//                                ),
//                                onTap: {
//                                    // Burada oyuncuya tıklama işlemini tanımlayabilirsiniz
//                                    // Örneğin, oyuncunun bilgilerini yazdırabilirsiniz
//                                    print("\(players[index].firstName) tıklandı")
//                                    selectedPlayerIndex = index
//                                    showingSubstitutePicker = true
//                                    // Diğer işlemler için burada aksiyon ekleyebilirsiniz.
//                                }
//                            )
//
//                        }
//                    }
//                }
//                .onAppear {
//                    updatePlayerPositions()
//                }
//            }
//        }
//        .navigationTitle(teamName)
//        .navigationBarTitleDisplayMode(.inline)
//        
//    }
//
//    private func updatePlayerPositions() {
//        playerPositions = selectedFormation.layout.flatMap { $0 }
//        resolveCollisions(for: -1) // İlk konumlamada çakışmaları çöz
//    }
//
//    private func resolveCollisions(for draggedIndex: Int) {
//        let minimumDistance: CGFloat = 0.14 // Mesafeyi artırdık (0-1 arasında)
//
//        for i in 0..<playerPositions.count {
//            // Sadece sürüklenen oyuncuyu etkileyelim
//            if draggedIndex == -1 || i == draggedIndex {
//                for j in 0..<playerPositions.count where i != j {
//                    let distance = hypot(
//                        playerPositions[i].x - playerPositions[j].x,
//                        playerPositions[i].y - playerPositions[j].y
//                    )
//                    if distance < minimumDistance {
//                        let offset = (minimumDistance - distance) / 2
//                        playerPositions[i].x += offset
//                        playerPositions[i].y += offset
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct DraggablePlayersView: View {
//    let player: Player
//    @Binding var position: CGPoint
//    @GestureState private var dragOffset: CGSize = .zero
//
//    var body: some View {
//        VStack {
//            Image(systemName: "person.crop.circle")
//                .resizable()
//                .frame(width: 50, height: 50)
//                .foregroundColor(.white)
//            Text(player.firstName)
//                .font(.caption)
//                .bold()
//            Text("OVR: \(player.overall)")
//                .font(.caption2)
//                .foregroundColor(.black)
//        }
//        .position(position)
//        .offset(dragOffset)
//        .gesture(
//            DragGesture()
//                .updating($dragOffset) { value, state, _ in
//                    state = value.translation
//                }
//                .onEnded { value in
//                    position.x += value.translation.width
//                    position.y += value.translation.height
//                }
//        )
//    }
//}
//
//struct PlayersView: View {
//    let player: Player
//
//    var body: some View {
//        VStack {
//            Image(systemName: "person.crop.circle")
//                .resizable()
//                .frame(width: 50, height: 50)
//                .foregroundColor(.white)
//            Text(player.firstName)
//                .font(.caption)
//                .bold()
//            Text("OVR: \(player.overall)")
//                .font(.caption2)
//                .foregroundColor(.black)
//        }
//    }
//}
//
//
//struct SubstitutesPicker: View {
//    var substitutes: [Player]
//    var onPlayerSelected: (Player) -> Void
//
//    var body: some View {
//        NavigationView {
//            List(substitutes) { player in
//                Button(action: {
//                    onPlayerSelected(player)
//                }) {
//                    HStack {
//                        Image(systemName: "person.crop.circle")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(.blue)
//                        VStack(alignment: .leading) {
//                            Text("\(player.firstName) \(player.lastName)")
//                                .bold()
//                            Text("OVR: \(player.overall)")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Select Substitute")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//struct BasketballLineupView_Previews: PreviewProvider {
//    static var previews: some View {
//        let samplePlayers = [
//            Player(firstName: "Ali", lastName: "Kaya", overall: 79, position: "Guard"),
//            Player(firstName: "Ahmet", lastName: "Yılmaz", overall: 82, position: "Guard"),
//            Player(firstName: "Mehmet", lastName: "Demir", overall: 78, position: "Forward"),
//            Player(firstName: "Barış", lastName: "Öztürk", overall: 86, position: "Forward"),
//            Player(firstName: "Emre", lastName: "Gül", overall: 90, position: "Center")
//        ]
//
//        BasketballLineupView(teamName: "Aslanlar", players: samplePlayers)
//    }
//}
