//
//  HistoryManager.swift
//  MatchApp
//
//  Created by Kerem on 15.12.2024.
//

import Foundation
import Firebase
import FirebaseFirestore


struct HistoryItem: Identifiable, Codable {
     var id = UUID()
    let teamName: String
    let players: [Player]
    let substitutes: [Player]
    let eventDetail: EventDetails
    let selectedSport: String
    
    
    init(teamName: String, players: [Player], substitutes: [Player], eventDetail: EventDetails, selectedSport: String) {
        self.id = UUID()
        self.teamName = teamName
        self.players = players
        self.substitutes = substitutes
        self.eventDetail = eventDetail
        self.selectedSport = selectedSport
    }
}


class HistoryManager: ObservableObject {
    @Published var historyItems: [HistoryItem] = [] {
        didSet {
            saveHistoryItems()
//            saveHistoryItemsToFirebase()
        }
    }
    
    private let db = Firestore.firestore()
    private let historyKey = "historyKey"

    init() {
        loadHistoryItems()
//        loadHistoryItemsFromFirebase()
    }
    
  
    func addHistoryItem(_ item: HistoryItem) {
        historyItems.append(item)
        saveHistoryItems()
        saveHistoryItemsToFirebase()
    }
    
     func loadHistoryItems() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else { return }

        let decoder = JSONDecoder()
        if let decodedItems = try? decoder.decode([HistoryItem].self, from: data) {
            historyItems = decodedItems
        }
    }
    
     func saveHistoryItems() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(historyItems) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
     func loadHistoryItemsFromFirebase() {
           db.collection("historyItems").getDocuments { [weak self] snapshot, error in
               guard let self = self else { return }
               if let error = error {
                   print(" \(error.localizedDescription)")
                   return
               }
               if let snapshot = snapshot {
                   self.historyItems = snapshot.documents.compactMap { document in
                       try? document.data(as: HistoryItem.self)
                   }
               }
           }
       }

        func saveHistoryItemsToFirebase() {
           for item in historyItems {
               do {
                   let _ = try db.collection("historyItems").addDocument(from: item)
               } catch let error {
                   print(" \(error.localizedDescription)")
               }
           }
       }
}
