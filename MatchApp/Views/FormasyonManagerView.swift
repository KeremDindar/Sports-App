//
//  FormasyonManagerView.swift
//  MatchApp
//
//  Created by Kerem on 3.12.2024.
//

import SwiftUI
struct DraggablePlayerView: View {
    let player: Player
    @Binding var position: CGPoint
    let onTap: () -> Void
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        VStack {
            if let photoString = player.photo,
                let imageData = Data(base64Encoded: photoString),
                let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .background(.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
            Text(player.firstName)
                .font(.caption)
                .bold()
                .foregroundStyle(.white)
            Text("OVR: \(player.overall)")
                .font(.caption2)
                .foregroundColor(.black)
        }
        .position(position)
        .offset(dragOffset)
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    let newPosition = CGPoint(
                        x: position.x + value.translation.width,
                        y: position.y + value.translation.height
                    )
                    position = clampedPosition(newPosition, fieldWidth: UIScreen.main.bounds.width, fieldHeight: 561)
                }
        )
        .onTapGesture {
            onTap()
        }
    }

    /// Pozisyonu saha sınırlarına sıkıştıran fonksiyon
    private func clampedPosition(_ position: CGPoint, fieldWidth: CGFloat, fieldHeight: CGFloat) -> CGPoint {
        let fieldPadding: CGFloat = position.y < 50 ? 50 : 10 // Sahanın kenarlarında boşluk bırakmak için
        let minX = fieldPadding
        let maxX = fieldWidth - fieldPadding
        let minY = fieldPadding
        let maxY = fieldHeight - fieldPadding

        return CGPoint(
            x: min(max(position.x, minX), maxX),
            y: min(max(position.y, minY), maxY)
        )
    }
}
