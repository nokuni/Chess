//
//  SquareBoardView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

// question ? question :

struct SquareBoardView: View {
    @Binding var chess: Chess
    
//    @Binding var coloredOverlayMatchIndex: Int?
//    @Binding var coloredOverlayPieceIndex: Int?
//    @Binding var coloredOverlayPreMoves: [Int]
    
    func overlay(_ index: Int) -> some View {
        GeometryReader { geo in
            Rectangle()
                .foregroundColor(chess.premoves.coloredOverlayMatchIndex == index || chess.premoves.coloredOverlayPieceIndex == index ? .theme.premove : .clear)
                .opacity(0.5)
                .onAppear {
                    chess.frames[index] = geo.frame(in: .global)
                }
                .onChange(of: geo.frame(in: .global)) { value in
                    chess.frames[index] = geo.frame(in: .global)
                }
        }
    }
    func preMovesOverlay(_ index: Int) -> some View {
        GeometryReader { geo in
            Rectangle()
                .foregroundColor(!chess.premoves.coloredOverlay.contains(index) ? .clear :  chess.premoves.coloredOverlay.contains(index) && chess.pieces[index].color != chess.side.rawValue && chess.pieces[index] != Piece.empty ? .red : .orange)
                .opacity(0.5)
                .onAppear {
                    chess.frames[index] = geo.frame(in: .global)
                }
                .onChange(of: geo.frame(in: .global)) { value in
                    chess.frames[index] = geo.frame(in: .global)
                }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: ChessViewModel.grid, spacing: 0) {
                ForEach(chess.board.indices, id: \.self) { index in
                    ZStack {
                        SquareView(theme: chess.theme,
                                   color: chess.getSquareColor(of: index, with: chess.theme),
                                   number: chess.getSquareNumbers(of: index),
                                   letter: chess.getSquareLetters(of: index),
                                   index: index, width: geometry.size.width * 0.125, height: geometry.size.width * 0.125)
                        //Text("\(index)")
                    }
                    .allowsHitTesting(false)
                    .overlay(overlay(index))
                    .overlay(preMovesOverlay(index))
                }
            }
        }
    }
}

struct SquareBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SquareBoardView(chess: .constant(Chess.defaultGame))
    }
}
