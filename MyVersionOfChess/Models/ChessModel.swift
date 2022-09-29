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
    var premoves: Premove
    var promotion: Promotion
    var isYourTurn: Bool
    var hasGameStarted: Bool = false
    
    func isOurSide(_ piece: Piece) -> Bool { piece.color == side.rawValue && !piece.name.isEmpty }
    
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
    
    var rowsIndices: [[Int]] { Array(board.indices).separate(into: 8) }
    func getRow(at index: Int) -> [Int] {
        guard let result = rowsIndices.first(where: { $0.contains(index)}) else { return [] }
        return result
    }
    func getRowIndex(at index: Int) -> Int {
        guard let rowIndex = rowsIndices.firstIndex(where: { $0.contains(index) }) else { return 0 }
        return rowIndex
    }
    func getColumn(at index: Int) -> [Int] {
        let columns = board.getColumnsIndices(number: 8)
        guard let result = columns.first(where: { $0.contains(index) }) else { return [] }
        return result
    }
    func getColumnIndex(at index: Int) -> Int {
        let columns = board.getColumnsIndices(number: 8)
        guard let columnIndex = columns.firstIndex(where: { $0.contains(index)}) else { return 0 }
        return columnIndex
    }
    func getIncrementedIndices(_ indices: [Int], by amount: Int) -> [Int] {
        var incrementValue = amount
        var tempIndices = indices
        var result = [Int]()
        
        guard let firstColumn = board.getColumnsIndices(number: 8).first else { return [] }
        guard let lastColumn = board.getColumnsIndices(number: 8).last else { return [] }
        
        for index in tempIndices.indices {
            tempIndices[index] += incrementValue
            incrementValue += amount
            result.append(tempIndices[index])
            if firstColumn.contains(tempIndices[index]) || lastColumn.contains(tempIndices[index]) { break }
        }
        return result
    }
    
    func getAxisScope(at index: Int) -> [Int] {
        let rookColumn = getColumn(at: index)
        let rookRow = getRow(at: index)
        
        let goingUp = Array(rookColumn.filter { $0 < index }.reversed())
        let goingDown = rookColumn.filter { $0 > index }
        let goingRight = rookRow.filter { $0 > index }
        let goingLeft = Array(rookRow.filter { $0 < index }.reversed())
        
        let scope = [goingUp, goingDown, goingRight, goingLeft]
        
        var result = [Int]()
        
        for way in scope {
            for squareIndex in way.filter({ Chess.boardIndices.contains($0) }) {
                if pieces[squareIndex].image == "empty" { result.append(squareIndex)} else {
                    if !isOurSide(pieces[squareIndex]) { result.append(squareIndex) }
                    break
                }
            }
        }
        
        return result
    }
    func getDiagonalScope(at index: Int) -> [Int] {
        let rookColumn = getColumn(at: index)
        
        guard let firstColumn = board.getColumnsIndices(number: 8).first else { return [] }
        guard let lastColumn = board.getColumnsIndices(number: 8).last else { return [] }
        
        let goingUp = Array(rookColumn.filter { $0 < index }.reversed())
        let goingDown = rookColumn.filter { $0 > index }
        
        let goingDiagonalTopRight = getIncrementedIndices(goingUp, by: 1).filter { !firstColumn.contains($0) }
        let goingDiagonalTopLeft = getIncrementedIndices(goingUp, by: -1).filter { !lastColumn.contains($0) }
        let goingDiagonalBottomRight = getIncrementedIndices(goingDown, by: 1).filter { !firstColumn.contains($0) }
        let goingDiagonalBottomLeft = getIncrementedIndices(goingDown, by: -1).filter { !lastColumn.contains($0) }
        
        let scope = [goingDiagonalTopRight, goingDiagonalTopLeft, goingDiagonalBottomRight, goingDiagonalBottomLeft]
        
        var result = [Int]()
        
        for way in scope {
            for squareIndex in way.filter({ Chess.boardIndices.contains($0) }) {
                if pieces[squareIndex].image == "empty" { result.append(squareIndex) } else {
                    if !isOurSide(pieces[squareIndex]) { result.append(squareIndex) }
                    break
                }
            }
        }
        return result
    }
}
