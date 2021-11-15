//
//  PieceView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct PieceView: View {
    @State var dragAmount = CGSize.zero
    @Binding var coloredOverlayPreMoves: [Int]
    var piece: Piece
    var index: Int
    var side: Side
    var width, height: CGFloat
    var onChanged: ((CGPoint, Int, Piece) -> Void)?
    var onEnded: ((CGPoint, Int, Piece) -> Void)?
    var gesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged {
                if piece.color != "empty" && piece.color == side.rawValue {
                    dragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                    onChanged?($0.location, index, piece)
                }
            }
            .onEnded {
                onEnded?($0.location, index, piece)
                withAnimation {
                    coloredOverlayPreMoves.removeAll()
                    dragAmount = .zero
                }
            }
    }
    
    var body: some View {
        ZStack {
            if let image = piece.image {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.7)
            } else {
                Image(Piece.empty.color)
                    .resizable()
            }
        }
        .scaleEffect(dragAmount == .zero ? 1 : 1.5)
        .frame(width: width, height: height)
        .zIndex(dragAmount == .zero ? 0 : 1)
        .offset(dragAmount)
        .gesture(gesture)
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView(coloredOverlayPreMoves: .constant([]), piece: Piece.empty, index: 0, side: .white, width: 100, height: 100)
    }
}
