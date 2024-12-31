//
//  PlayerRow.swift
//  MatchApp
//
//  Created by Kerem on 4.12.2024.
//


import SwiftUI

struct PlayerRow: View {
    let player: Player

    var body: some View {
        HStack {
            if let photo = player.photo, let imageData = Data(base64Encoded: photo), let uiImage = UIImage(data: imageData){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading) {
                Text("\(player.firstName) \(player.lastName)")
                    .font(.headline)
                Text("Position: \(player.position)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("Overall: \(player.overall)")
                .font(.callout)
                .bold()
        }
    }
}

#Preview {
    PlayerRow(player: Player(firstName: "Kerem", lastName: "Dindar", overall: 79, position: "fv"))
}

