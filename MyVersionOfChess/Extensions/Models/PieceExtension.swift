//
//  PieceExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import Foundation

extension Piece {
    static let empty = Piece(name: "", image: "empty", value: 0, color: "empty")
    static var basic: [Piece] { Bundle.main.decode("BasicChessPieces") }
    static func kingMoves(index: Int) -> [Int] {
        return [index - 8, index - 7, index + 1, index + 9, index + 8, index + 7, index - 1, index - 9].filter { Chess.boardIndices.contains($0) }
    }
    static func knightMoves(chess: Chess, index: Int) -> [Int] {
        var topRow = [Int]()
        var bottomRow = [Int]()
        var leftColumn = [Int]()
        var rightColumn = [Int]()
        
        if (chess.getRowIndex(at: index) - 2) >= 0 {
            topRow = chess.rowsIndices[chess.getRowIndex(at: index) - 2]
        }
        if (chess.getRowIndex(at: index) + 2) <= chess.rowsIndices.count - 1 {
            bottomRow = chess.rowsIndices[chess.getRowIndex(at: index) + 2]
        }
        if (chess.getColumnIndex(at: index) - 2) >= 0 {
            leftColumn = chess.board.getColumnsIndices(number: 8)[chess.getColumnIndex(at: index) - 2]
        }
        if (chess.getColumnIndex(at: index) + 2) <= chess.board.getColumnsIndices(number: 8).count - 1 {
            rightColumn = chess.board.getColumnsIndices(number: 8)[chess.getColumnIndex(at: index) + 2]
        }
        
        let topMoves = [index - 17, index - 15].filter { topRow.contains($0) }
        let rightMoves = [index - 6, index + 10].filter { rightColumn.contains($0) }
        let bottomMoves = [index + 17, index + 15].filter { bottomRow.contains($0) }
        let leftMoves = [index + 6, index - 10].filter { leftColumn.contains($0) }
        
        return (topMoves + rightMoves + bottomMoves + leftMoves).filter { Chess.boardIndices.contains($0) }
    }
    var isSquareEmpty: Bool { self.color == "empty" }
}
