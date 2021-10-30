//
//  ChessExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

extension Chess {
    static let defaultGame = Chess(board: [Color](repeating: .clear, count: 64), pieces: [Piece](repeating: Piece.empty, count: 64), frames: [CGRect](repeating: .zero, count: 64), theme: .basic, side: .white)
    
    static let boardIndices = Array(0..<64)
    static let rowsIndices = boardIndices.separate(into: 8)
}
