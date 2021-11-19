//
//  BoardPieceView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct BoardPieceView: View {
    @Binding var chess: Chess
    
//    @Binding var coloredOverlayMatchIndex: Int?
//    @Binding var coloredOverlayPieceIndex: Int?
//    @Binding var coloredOverlayPreMoves: [Int]
    
    var selectPiece: ((Int, Piece) -> Void)?
    var selectDestination: ((Int, Piece) -> Void)?
    var onChanged: ((CGPoint, Int, Piece) -> Void)?
    var onEnded: ((CGPoint, Int, Piece) -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: ChessViewModel.grid, spacing: 0) {
                if let chess = self.chess {
                    ForEach(chess.pieces.indices) { index in
                        PieceView(coloredOverlayPreMoves: $chess.premoves.coloredOverlay, piece: chess.pieces[index], index: index, side: chess.side, width: geometry.size.width * 0.125, height: geometry.size.width * 0.125, onChanged: onChanged, onEnded: onEnded)
                            .overlay(
                                CircleOverlayView(selectedIndex: chess.premoves.coloredOverlayMatchIndex, index: index)
                            )
                            .onTapGesture {
                                selectPiece?(index, chess.pieces[index])
                                selectDestination?(index, chess.pieces[index])
                            }
                        //.allowsHitTesting(pieces[index].color == side.rawValue || pieces[index].color == "empty" || coloredOverlayPieceIndex != nil ? true : false)
                    }
                }
            }
        }
    }
}

struct BoardPieceView_Previews: PreviewProvider {
    static var previews: some View {
        BoardPieceView(chess: .constant(Chess.defaultGame))
    }
}
