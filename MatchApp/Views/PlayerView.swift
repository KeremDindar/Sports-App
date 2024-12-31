//
//  PlayerView.swift
//  MatchApp
//
//  Created by Kerem on 3.12.2024.
//

import SwiftUI

struct PlayerView: View {
    let player: Player

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
            Text(player.firstName)
                .font(.caption)
                .bold()
            Text("OVR: \(player.overall)")
                .font(.caption2)
                .foregroundColor(.white)
        }
    }
}
