


import SwiftUI

struct AddEventView: View {
    let selectedSport: String
    @State private var eventName: String = ""
    @State private var location: String = ""
    @State private var district: String = ""
    @State private var date: Date = Date()
    @State private var iban: String = ""
    @State private var entryFee: String = ""
    @State  var homeTeam: String 
    @State private var awayTeam: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlayerCount: PlayerCount = .sixSix
    @FocusState private var focusField: Field?
    @State var isNavigate = false
    
    

    enum PlayerCount: String, CaseIterable, Identifiable, Codable {
        case oneone = "1x1"
        case twoTwo = "2x2"
        case threeThree = "3x3"
        case fourFour = "4x4"
        case fiveFive = "5x5"
        case sixSix = "6x6"
        case sevenSeven = "7x7"
        case eightEight = "8x8"
        case nineNine = "9x9"
        case tenTen = "10x10"
        case elevenEleven = "11x11"

        var id: String { self.rawValue }
    }
    enum Field {
        case eventName
        case location
        case district
        case homeTeam
        case awayTeam
        case iban
        case entryFee
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Event Details")) {
                        TextField("Event Area", text: $eventName)
                            .focused($focusField, equals: .eventName)
                            .submitLabel(.next)
                        TextField("City", text: $location)
                            .submitLabel(.next)
                            .focused($focusField, equals: .location)
                        TextField("District", text: $district)
                            .focused($focusField, equals: .district)
                            .submitLabel(.next)
                        DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    }
                    
                    Section(header: Text("Teams")) {
                        TextField("Home Team", text: $homeTeam)
                            .focused($focusField, equals: .homeTeam)
                            .submitLabel(.next)
                        TextField("Away Team", text: $awayTeam)
                            .focused($focusField, equals: .awayTeam)
                            .submitLabel(.next)
                    }
                    
                    Section(header: Text("Payment Details")) {
                        TextField("IBAN", text: $iban)
                            .focused($focusField, equals: .iban)
                            .keyboardType(.asciiCapable)
                            .submitLabel(.next)
                        TextField("Entry Fee (Optional)", text: $entryFee)
                            .focused($focusField, equals: .entryFee)
                            .submitLabel(.done)
                            .keyboardType(.numberPad)
                    }
                    
                    Section(header: Text("Player Settings")) {
                        if selectedSport.lowercased() == "basketball" || selectedSport.lowercased() == "volleyball" {
                            Text("Player Count: 5x5")
                        }else if selectedSport.lowercased() == "tennis" {
                            Text("PlayerCount: 1x1 ")
                            
                        } else {
                            Picker("Player Count", selection: $selectedPlayerCount) {
                                ForEach(PlayerCount.allCases) { count in
                                    Text(count.rawValue).tag(count)
                                }
                            }
                        }
                    }
                }
                
                            
                        
                               
                Button(action: {
                    isNavigate = true
//                    dismiss()
                    
                }) {
                    Text("Create Match")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                .navigationTitle(selectedSport.capitalized)
                .navigationDestination(isPresented: $isNavigate) {
                                    CombinedView(
                                        teamName: homeTeam,
                                        players: [
                                            Player(firstName: "Ali", lastName: "Kaya", overall: 79, position: "Goalkeeper"),
                                            Player(firstName: "Ahmet", lastName: "Yılmaz", overall: 82, position: "Defender"),
                                            Player(firstName: "Mehmet", lastName: "Demir", overall: 78, position: "Defender"),
                                            Player(firstName: "Barış", lastName: "Öztürk", overall: 86, position: "Midfielder"),
                                            Player(firstName: "Emre", lastName: "Gül", overall: 90, position: "Midfielder"),
                                            Player(firstName: "Cenk", lastName: "Kara", overall: 84, position: "Midfielder"),
                                            Player(firstName: "Mert", lastName: "Şahin", overall: 76, position: "Forward")
                                        ],
                                        substitutes: [
                                            Player(firstName: "Cenk", lastName: "Kara", overall: 84, position: "Midfielder"),
                                            Player(firstName: "Mert", lastName: "Şahin", overall: 76, position: "Forward")
                                        ],
                                        eventDetail: EventDetails(
                                            eventName: eventName,
                                            location: location,
                                            district: district,
                                            date: date,
                                            iban: iban,
                                            entryFee: entryFee,
                                            homeTeam: homeTeam,
                                            awayTeam: awayTeam,
                                            playerCount: selectedPlayerCount
                                        ),
                                        selectedSport: selectedSport
                                    )
                                    .environmentObject(SportManager())
                                }
            }
        }
    }
}

#Preview {
    AddEventView(selectedSport: "Football", homeTeam: "asdsd")
        .environmentObject(HistoryManager())
}

struct EventDetails: Codable {
    let eventName: String
    let location: String
    let district: String
    let date: Date
    let iban: String
    let entryFee: String
    let homeTeam: String
    let awayTeam: String
    let playerCount: AddEventView.PlayerCount
    
}
