//
//  ChessModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct Chess {
    var board: [Color]
    var pieces: [Piece]
    var frames: [CGRect]
    var theme: Theme
    var side: Side
    
    func getSquareColor(of index: Int, with theme: Theme) -> Color {
        for row in Chess.rowsIndices.indices {
            for _ in Chess.rowsIndices[row].indices {
                if Chess.rowsIndices[row].contains(index) {
                    if index.isEven && row.isEven || index.isOdd && row.isOdd {
                        return theme.primaryColor
                    }
                }
            }
        }
        return theme.secondaryColor
    }
    func getSquareNumbers(of index: Int) -> Int {
        let filteredArray = Array(Chess.boardIndices.filter { $0 % 8 == 0 }.reversed())
        if let firstIndex = filteredArray.firstIndex(where: { $0 == index}) { return firstIndex + 1 }
        return 0
    }
    func getSquareLetters(of index: Int) -> String {
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
        guard let lastRow = Chess.rowsIndices.last else { return "" }
        if let firstIndex = lastRow.firstIndex(where: { $0 == index } ) { return letters[firstIndex] }
        return ""
    }
}
