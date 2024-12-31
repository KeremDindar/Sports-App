






import SwiftUI

struct EventDetailView: View {
    let eventDetail: EventDetails
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(spacing: 10) {
                    Text(eventDetail.eventName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(eventDetail.date.formatted(date: .long, time: .shortened))
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.3), .blue.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(15)

                // Teams Section
                VStack(spacing: 15) {
                    HStack {
                        VStack {
                            Text(eventDetail.homeTeam)
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Home Team")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        Image(systemName: "sportscourt")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        VStack {
                            Text(eventDetail.awayTeam)
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Away Team")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.1))
                    )
                }
              
            
                

                // Event Details Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Event Details")
                        .font(.headline)
                        .padding(.bottom, 5)

                    HStack {
                        Image(systemName: "map")
                            .foregroundColor(.blue)
                        Text("Location: \(eventDetail.location), \(eventDetail.district)")
                    }

                    HStack {
                        Image(systemName: "eurosign.circle")
                            .foregroundColor(.green)
                        Text("Entry Fee: \(eventDetail.entryFee.isEmpty ? "Free" : "\(eventDetail.entryFee) ₺")")
                    }

                    HStack {
                        Image(systemName: "banknote")
                            .foregroundColor(.purple)
                        Text("IBAN: \(eventDetail.iban)")
                            .lineLimit(1)
//                            .truncationMode(.middle)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.1))
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text("Match Settings")
                        .font(.headline)
                        .padding(.bottom, 5)

                    HStack {
                        Image(systemName: "person.3")
                            .foregroundColor(.orange)
                        Text("Player Count: \(eventDetail.playerCount.rawValue)")
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.1))
                )
            }
            .padding()
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EventDetailView(eventDetail: EventDetails(
        eventName: "Champions League Final",
        location: "Istanbul",
        district: "Kadikoy",
        date: .now,
        iban: "TR123456789012345678901234",
        entryFee: "100",
        homeTeam: "Fenerbahçe",
        awayTeam: "Galatasaray",
        playerCount: .sevenSeven
    ))
}
