//
//  SubstitutePickerView.swift
//  MatchApp
//
//  Created by Kerem on 3.12.2024.
//

import SwiftUI

struct SubstitutePicker: View {
    var substitutes: [Player]
    var onPlayerSelected: (Player) -> Void

    var body: some View {
        NavigationView {
            List(substitutes) { player in
                Button(action: {
                    onPlayerSelected(player)
                }) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("\(player.firstName) \(player.lastName)")
                                .bold()
                            Text("OVR: \(player.overall)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Select Substitute")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

