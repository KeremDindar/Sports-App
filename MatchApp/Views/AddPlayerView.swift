



import SwiftUI

struct AddPlayerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var playerPhoto: UIImage? = nil
    @State private var isPhotoPickerPresented = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var position: String = ""
    @State private var overall: Int = 70
    @FocusState private var focusField: Field?
    let onSave: (Player) -> Void
    let selectedSport: String
    
    // Pozisyonlar dinamik olarak belirleniyor
    var positions: [String] {
        switch selectedSport {
        case "Football":
            return [
                "Goalkeeper", "Defender", "Center Back", "Midfielder",
                "Wing Back", "Defensive Midfielder", "Attacking Midfielder",
                "Central Midfielder", "Winger", "Forward", "Striker"
            ]
        case "Basketball":
            return [
                "Point Guard", "Shooting Guard", "Small Forward",
                "Power Forward", "Center"
            ]
        case "Volleyball":
            return [
                "Setter", "Outside Hitter", "Opposite Hitter",
                "Middle Blocker", "Libero"
            ]
        case "Tennis":
            return ["Player"]
        default:
            return []
        }
    }
    enum Field {
        case firstName
        case lastName
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    
                    // Fotoğraf Seçimi
                    Button(action: {
                        isPhotoPickerPresented = true
                    }) {
                        if let photo = playerPhoto {
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        } else {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                        }
                    }
                    .sheet(isPresented: $isPhotoPickerPresented) {
                        ImagePicker(image: $playerPhoto)
                    }
                    
                    // İsim Soyisim
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("First Name", text: $firstName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .padding(.horizontal)
                            .focused($focusField, equals: .firstName)
                            .submitLabel(.next)
                        
                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .focused($focusField, equals: .lastName)
                            .padding(.horizontal)
                            .submitLabel(.done)
                    }
                    
                    // Pozisyon Seçimi
                    HStack {
                        Text("Position")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        Menu {
                            ForEach(positions, id: \.self) { pos in
                                Button(action: {
                                    position = pos
                                }) {
                                    Text(pos)
                                }
                            }
                        } label: {
                            HStack {
                                Text(position)
                                    .foregroundColor(.black)
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                    }

                    HStack {
                        Text("Overall")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        Menu {
                            ForEach(50..<101, id: \.self) { value in
                                Button(action: {
                                    overall = value
                                }) {
                                    Text("\(value)")
                                }
                            }
                        } label: {
                            HStack {
                                Text("\(overall)")
                                    .foregroundColor(.black)
                                    .padding()
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                    }

                }
                .padding(.bottom)
            }
            .navigationTitle(selectedSport)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newPlayer = Player(
                            firstName: firstName,
                            lastName: lastName,
                            overall: overall,
                            position: position
                            
                        )
                        onSave(newPlayer)
                        dismiss()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    AddPlayerView(onSave: { newPlayer in
        print("New player added: \(newPlayer)")
    }, selectedSport: "Football")
}
