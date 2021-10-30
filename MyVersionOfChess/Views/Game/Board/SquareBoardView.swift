//
//  SquareBoardView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

// question ? question :

struct SquareBoardView: View {
    @Binding var chess: Chess?
    
    @Binding var coloredOverlayMatchIndex: Int?
    @Binding var coloredOverlayPieceIndex: Int?
    @Binding var coloredOverlayPreMoves: [Int]
    
    var squareColors: ((Int) -> Color)?
    var squareNumbers: ((Int) -> Int)?
    var squareLetters: ((Int) -> String)?
    
    func overlay(_ index: Int) -> some View {
        GeometryReader { geo in
            Rectangle()
                .foregroundColor(coloredOverlayMatchIndex == index || coloredOverlayPieceIndex == index ? .theme.premove : .clear)
                .opacity(0.5)
                .onChange(of: geo.frame(in: .global)) { value in
                    chess?.frames[index] = geo.frame(in: .global)
                }
        }
    }
    func preMovesOverlay(_ index: Int) -> some View {
        GeometryReader { geo in
            Rectangle()
                .foregroundColor(!coloredOverlayPreMoves.contains(index) ? .clear :  coloredOverlayPreMoves.contains(index) && chess?.pieces[index].color != chess?.side.rawValue && chess?.pieces[index] != Piece.empty ? .red : .orange)
                .opacity(0.5)
                .onChange(of: geo.frame(in: .global)) { value in
                    chess?.frames[index] = geo.frame(in: .global)
                }
        }
    }
    
    var body: some View {
        LazyVGrid(columns: ChessViewModel.grid, spacing: 0) {
            ForEach(chess!.board.indices) { index in
                ZStack {
                    SquareView(theme: chess!.theme,
                               color: squareColors?(index),
                               number: squareNumbers?(index),
                               letter: squareLetters?(index),
                               index: index)
                }
                .allowsHitTesting(false)
                .overlay(overlay(index))
                .overlay(preMovesOverlay(index))
            }
        }
    }
}

struct SquareBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SquareBoardView(chess: .constant(Chess.defaultGame), coloredOverlayMatchIndex: .constant(0), coloredOverlayPieceIndex: .constant(0), coloredOverlayPreMoves: .constant([]))
    }
}
