import SwiftUI

struct CreateMatchView: View {
    
    @State private var selectedPlayerIndex: Int? = nil
    @State private var showingSubstitutePicker = false
    let teamName: String
    @State var players: [Player] 
    @State var substitutes: [Player] = [
        Player(firstName: "Can", lastName: "Eren", overall: 75, position: "Defender", photo: nil),
        Player(firstName: "Serkan", lastName: "Yıldırım", overall: 80, position: "Midfielder", photo: nil)
    ]

    @State private var selectedFormation: Formation = .twoThreeOne

    enum Formation: String, CaseIterable, Identifiable {
        case twoThreeOne = "2-3-1"
        case threeTwoOne = "3-2-1"
        case oneFourOne = "1-4-1"

        var id: String { self.rawValue }

        var layout: [[Int]] {
            switch self {
            case .twoThreeOne:
                return [[6], [3, 4, 5], [1, 2], [0]]
                
            case .threeTwoOne:
                return [[6], [4, 5], [1, 2, 3], [0]]
                
            case .oneFourOne:
                return [[6], [2, 3, 4, 5], [1], [0]]
            }
        }
    }

    var body: some View {
        VStack {
            // Diziliş Seçimi
            Picker("Formation", selection: $selectedFormation) {
                ForEach(Formation.allCases) { formation in
                    Text(formation.rawValue).tag(formation)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

           
            ZStack {
                
                Image("saha")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()

                VStack {
                    ForEach(selectedFormation.layout.indices, id: \.self) { rowIndex in
                        HStack(spacing: 30) {
                            ForEach(selectedFormation.layout[rowIndex], id: \.self) { positionIndex in
                                if positionIndex < players.count {
                                    Button(action: {
                                        
                                        selectedPlayerIndex = positionIndex
                                        showingSubstitutePicker = true
                                    }) {
                                        PlayerView(player: players[positionIndex])
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    Spacer()
                                }
                            }
                        }
                        .padding(.vertical)
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
        }
        .navigationTitle(teamName)
        .navigationBarTitleDisplayMode(.inline)
    }

}



// Örnek Veri
struct Create: PreviewProvider {
    static var previews: some View {
        let samplePlayers = [
            Player(firstName: "Ali", lastName: "Kaya", overall: 79, position: "Goalkeeper", photo: nil),
            Player(firstName: "Ahmet", lastName: "Yılmaz", overall: 82, position: "Defender", photo: nil),
            Player(firstName: "Mehmet", lastName: "Demir", overall: 78, position: "Defender", photo: nil),
            Player(firstName: "Barış", lastName: "Öztürk", overall: 86, position: "Midfielder", photo: nil),
            Player(firstName: "Emre", lastName: "Gül", overall: 90, position: "Midfielder", photo: nil),
            Player(firstName: "Cenk", lastName: "Kara", overall: 84, position: "Midfielder", photo: nil),
            Player(firstName: "Mert", lastName: "Şahin", overall: 76, position: "Forward", photo: nil)
        ]

        CreateMatchView(teamName: "Aslanlar", players: samplePlayers)
    }
}
