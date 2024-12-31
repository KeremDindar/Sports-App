//
//  SportManager.swift
//  MatchApp
//
//  Created by Kerem on 22.11.2024.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseFirestore





struct Player: Identifiable, Codable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var overall: Int
    var position: String
    var photo: String?

    
    static let sample: [Player] = [
        Player(firstName: "Lionel", lastName: "Messi", overall: 93, position: "Forward", photo: nil),
        Player(firstName: "Cristiano", lastName: "Ronaldo", overall: 92, position: "Forward", photo: nil),
        Player(firstName: "Ali", lastName: "Kaya", overall: 79, position: "Goalkeeper", photo: nil),
        Player(firstName: "Ahmet", lastName: "Yılmaz", overall: 82, position: "Defender", photo: nil),
        Player(firstName: "Mehmet", lastName: "Demir", overall: 85, position: "Midfielder", photo: nil),
        Player(firstName: "Murat", lastName: "Şahin", overall: 81, position: "Forward", photo: nil),
        Player(firstName: "Ömer", lastName: "Çelik", overall: 77, position: "Defender", photo: nil),
        Player(firstName: "Erdem", lastName: "Can", overall: 88, position: "Midfielder", photo: nil),
        Player(firstName: "Cem", lastName: "Kurt", overall: 84, position: "Defender", photo: nil),
    ]
}

class SportManager: ObservableObject {
    @Published var selectedSport: String = "Football"
    @Published var players: [String: [Player]] = [:] {
        didSet {
            savePlayersToUserDefaults()
        }
    }
    
    
    
    private let userDefaultsKey = "SavedPlayers"

    init() {
        loadPlayersFromUserDefaults()
//        loadPlayersFromFirebase(for: selectedSport)
    }

    func fetchPlayers(for sport: String) {
        if players[sport] == nil || players[sport]!.isEmpty {
            players[sport] = Player.sample
        }
    }
    func addPlayer(_ player: Player, for sport: String) {
         if players[sport] == nil {
             players[sport] = []
         }
         players[sport]?.append(player)
        savePlayersToUserDefaults()
        savePlayerToFirebase(player: player, sport: sport)
        
     }
    
    func deletePlayer(at offsets: IndexSet, from sport: String) {
        guard let sportPlayers = players[sport] else { return }
        
        let playersToDelete = offsets.map { sportPlayers[$0] }
        
        players[sport]?.remove(atOffsets: offsets)
        
        savePlayersToUserDefaults()
        
        for player in playersToDelete {
            deletePlayerFromFirebase(player: player, sport: sport)
        }
    }


    private func savePlayersToUserDefaults() {
        do {
            let encodedData = try JSONEncoder().encode(players)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("\(error.localizedDescription)")
        }
    }

    private func loadPlayersFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        do {
            let decodedPlayers = try JSONDecoder().decode([String: [Player]].self, from: data)
            self.players = decodedPlayers
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func savePlayerToFirebase(player: Player, sport: String) {
        let db = Firestore.firestore()

        
        let playerData: [String: Any] = [
            "firstName": player.firstName,
            "lastName": player.lastName,
            "overall": player.overall,
            "position": player.position,
            "photoBase": player.photo ?? ""
        ]
        
        
        db.collection("players").addDocument(data: playerData) { error in
            if let error = error {
                print("Firestore: \(error.localizedDescription)")
            } else {
                print("Player eklendi.")
            }
        }
    }
    
//    func loadPlayersFromFirebase(for sport: String) {
//        let db = Firestore.firestore()
//        
//        db.collection("players").getDocuments { snapshot, error in
//            if let error = error {
//                print("Firestore : \(error.localizedDescription)")
//                return
//            }
//            
//            guard let documents = snapshot?.documents else { return }
//            
//            var fetchedPlayers: [Player] = []
//            
//            for document in documents {
//                let data = document.data()
//                
//                if let firstName = data["firstName"] as? String,
//                   let lastName = data["lastName"] as? String,
//                   let overall = data["overall"] as? Int,
//                   let position = data["position"] as? String,
//                   let photoBase = data["photoBase"] as? String {
//                    
//                    let photo = photoBase.isEmpty ? nil : photoBase
//                    let player = Player(firstName: firstName, lastName: lastName, overall: overall, position: position, photo: photo)
//                    fetchedPlayers.append(player)
//                }
//            }
//            
//           
//            DispatchQueue.main.async {
//                self.players[sport] = fetchedPlayers
//            }
//        }
//    }


    
    func deletePlayerFromFirebase(player: Player, sport: String) {
        let db = Firestore.firestore()
        
        db.collection("players")
            .whereField("firstName", isEqualTo: player.firstName)
            .whereField("lastName", isEqualTo: player.lastName)
            .whereField("position", isEqualTo: player.position)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Firestore silme hatası: \(error.localizedDescription)")
                } else {
                    snapshot?.documents.forEach { document in
                        document.reference.delete { error in
                            if let error = error {
                                print("Belge silinemedi: \(error.localizedDescription)")
                            } else {
                                print("Belge başarıyla silindi.")
                            }
                        }
                    }
                }
            }
    }

}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                
                if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
                    let base64String = imageData.base64EncodedString()
                    parent.image = uiImage
                    
                    print("Base64: \(base64String)")
                }
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


