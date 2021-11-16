//
//  AIJunkFile.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/11/2021.
//

import Foundation

/*func aiScopeAxis(index: Int) -> [Int] {
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
            if chess.pieces[squareIndex].image == "empty" { result.append(squareIndex)} else {
                if isOurSide(chess.pieces[squareIndex]) { result.append(squareIndex) }
                break
            }
        }
    }
    
    return result
}
func aiScopeDiagonals(index: Int) -> [Int] {
    let rookColumn = getColumn(at: index)
    
    guard let firstColumn = columnsIndices.first else { return [] }
    guard let lastColumn = columnsIndices.last else { return [] }
    
    let goingUp = Array(rookColumn.filter { $0 < index }.reversed())
    let goingDown = rookColumn.filter { $0 > index }
    
    let goingDiagonalTopRight = incrementIndices(goingUp).filter { !firstColumn.contains($0) }
    let goingDiagonalTopLeft = decrementIndices(goingUp).filter { !lastColumn.contains($0) }
    let goingDiagonalBottomRight = incrementIndices(goingDown).filter { !firstColumn.contains($0) }
    let goingDiagonalBottomLeft = decrementIndices(goingDown).filter { !lastColumn.contains($0) }
    
    let scope = [goingDiagonalTopRight, goingDiagonalTopLeft, goingDiagonalBottomRight, goingDiagonalBottomLeft]
    
    var result = [Int]()
    
    for way in scope {
        for squareIndex in way.filter({ Chess.boardIndices.contains($0) }) {
            if chess.pieces[squareIndex].image == "empty" { result.append(squareIndex) } else {
                if isOurSide(chess.pieces[squareIndex]) { result.append(squareIndex) }
                break
            }
        }
    }
    return result
}

func aiPawnMovementResult(piece: Piece, index: Int) -> [[Int]] {
    var result = [[Int]](repeating: [], count: 3)
    
    let pawnStartIndices = rowsIndices[1]
    let isOnStartRow = pawnStartIndices.contains(index)
    
    let one = pawnMoveOneIndex(piece: piece, index: index)
    let two = pawnMoveTwoIndex(piece: piece, index: index)
    let diagonals = pawnMoveDiagonals(piece: piece, index: index)
    
    let isMovingOne = chess.pieces[one].isSquareEmpty
    let isMovingTwo = isOnStartRow && chess.pieces[two].isSquareEmpty && chess.pieces[one].isSquareEmpty
    
    for moveIndex in diagonals {
        if isOurSide(chess.pieces[moveIndex]) && !chess.pieces[moveIndex].isSquareEmpty {
            result[0].append(moveIndex)
        }
    }
    
    if isMovingTwo { result[1].append(two) }
    if isMovingOne { result[2].append(one) }
    
    return result
    
}
func aiPawnMoveOneResult() {
    
}
/*func aiPawnMoveOneResult() -> Bool {
 var moveOneResults = [Int]()
 var moveTwoResults = [Int]()
 var moveDiagonalsResults = [Int]()
 
 let piecesIndices = Chess.boardIndices.filter { !isOurSide(chess?.pieces[$0] ?? Piece.empty) }
 let pawnsIndices = piecesIndices.filter { chess?.pieces[$0].name == "Pawn" }
 guard let firstPawnIndex = pawnsIndices.first else { return false }
 
 let pawnStartIndices = rowsIndices[1]
 let isOnStartRow = pawnStartIndices.contains(firstPawnIndex)
 
 let one = pawnMoveOneIndex(piece: chess?.pieces[firstPawnIndex] ?? Piece.empty, index: firstPawnIndex)
 let two = pawnMoveTwoIndex(piece: chess?.pieces[firstPawnIndex] ?? Piece.empty, index: firstPawnIndex)
 let diagonals = pawnMoveDiagonals(piece: chess?.pieces[firstPawnIndex] ?? Piece.empty, index: firstPawnIndex)
 
 let isMovingOne = isSquareEmpty(chess?.pieces[one] ?? Piece.empty)
 let isMovingTwo = isOnStartRow && isSquareEmpty(chess?.pieces[two] ?? Piece.empty) && isSquareEmpty(chess?.pieces[one] ?? Piece.empty)
 
 if isMovingOne { moveOneResults.append(one) }
 if isMovingTwo { moveTwoResults.append(two) }
 
 for diagonal in diagonals {
 if isOurSide(chess?.pieces[diagonal] ?? Piece.empty) && !isSquareEmpty(chess?.pieces[diagonal] ?? Piece.empty) { moveDiagonalsResults.append(diagonal) }
 }
 
 
 if !moveDiagonalsResults.isEmpty {
 guard let firstIndex = moveDiagonalsResults.first else { return false }
 chess?.pieces[firstIndex] = chess?.pieces[firstPawnIndex] ?? Piece.empty
 chess?.pieces[firstPawnIndex] = Piece.empty
 } else if !moveTwoResults.isEmpty {
 guard let firstIndex = moveTwoResults.first else { return false }
 chess?.pieces[firstIndex] = chess?.pieces[firstPawnIndex] ?? Piece.empty
 chess?.pieces[firstPawnIndex] = Piece.empty
 } else if !moveOneResults.isEmpty {
 guard let firstIndex = moveOneResults.first else { return false }
 chess?.pieces[firstIndex] = chess?.pieces[firstPawnIndex] ?? Piece.empty
 chess?.pieces[firstPawnIndex] = Piece.empty
 }
 return false
 }*/

func aiRookMovementResult(piece: Piece, index: Int) -> [Int] {
    var result = [Int]()
    let scope = aiScopeAxis(index: index)
    
    for move in scope {
        if chess.pieces[move] == Piece.empty || chess.pieces[move].color == chess.side.rawValue {
            result.append(move)
        }
    }
    print(result)
    return result
}
func aiBishopMovementResult(piece: Piece, index: Int) -> [Int] {
    var result = [Int]()
    let scope = aiScopeDiagonals(index: index)
    
    for move in scope {
        if chess.pieces[move] == Piece.empty || chess.pieces[move].color == chess.side.rawValue {
            result.append(move)
        }
    }
    return result
}
func aiKnightMovementResult(piece: Piece, index: Int) -> [Int] {
    var result = [Int]()
    
    var topRow = [Int]()
    var bottomRow = [Int]()
    var leftColumn = [Int]()
    var rightColumn = [Int]()
    
    if (getRowIndex(at: index) - 2) >= 0 {
        topRow = rowsIndices[getRowIndex(at: index) - 2]
    }
    if (getRowIndex(at: index) + 2) <= rowsIndices.count - 1 {
        bottomRow = rowsIndices[getRowIndex(at: index) + 2]
    }
    if (getColumnIndex(at: index) - 2) >= 0 {
        leftColumn = columnsIndices[getColumnIndex(at: index) - 2]
    }
    if (getColumnIndex(at: index) + 2) <= columnsIndices.count - 1 {
        rightColumn = columnsIndices[getColumnIndex(at: index) + 2]
    }
    
    let topMoves = [index - 17, index - 15].filter { topRow.contains($0) }
    let rightMoves = [index - 6, index + 10].filter { rightColumn.contains($0) }
    let bottomMoves = [index + 17, index + 15].filter { bottomRow.contains($0) }
    let leftMoves = [index + 6, index - 10].filter { leftColumn.contains($0) }
    let moves = (topMoves + rightMoves + bottomMoves + leftMoves).filter { Chess.boardIndices.contains($0) }
    
    for move in moves {
        if chess.pieces[move] == Piece.empty || chess.pieces[move].color == chess.side.rawValue {
            result.append(move)
        }
    }
    return result
}
func aiQueenMovementResult(piece: Piece, index: Int) -> [Int] {
    var result = [Int]()
    let scope = aiScopeAxis(index: index) + aiScopeDiagonals(index: index)
    for move in scope {
        if chess.pieces[move] == Piece.empty || chess.pieces[move].color == chess.side.rawValue {
            result.append(move)
        }
    }
    return result
}
func aiKingMovementResult(piece: Piece, index: Int) -> [Int] {
    var result = [Int]()
    let moves = [index - 8, index - 7, index + 1, index + 9, index + 8, index + 7, index - 1, index - 9].filter { Chess.boardIndices.contains($0) }
    for move in moves {
        if chess.pieces[move] == Piece.empty || chess.pieces[move].color == chess.side.rawValue {
            result.append(move)
        }
    }
    return result
}

func movePawn() -> Bool {
    let piecesIndices = Chess.boardIndices.filter { !isOurSide(chess.pieces[$0]) }
    let pawnsIndices = piecesIndices.filter { chess.pieces[$0].name == "Pawn" }
    guard let firstPawnIndex = pawnsIndices.first else { return false }
    
    let possiblesMovesIndices = aiPawnMovementResult(piece: chess.pieces[firstPawnIndex], index: firstPawnIndex)
    
    if !possiblesMovesIndices[0].isEmpty {
        if let index = possiblesMovesIndices[0].first {
            chess.pieces[index] = chess.pieces[firstPawnIndex]
            chess.pieces[firstPawnIndex] = Piece.empty
            return true
        }
    } else if !possiblesMovesIndices[1].isEmpty {
        if let index = possiblesMovesIndices[1].first {
            chess.pieces[index] = chess.pieces[firstPawnIndex]
            chess.pieces[firstPawnIndex] = Piece.empty
            return true
        }
    } else if !possiblesMovesIndices[2].isEmpty {
        if let index = possiblesMovesIndices[2].first {
            chess.pieces[index] = chess.pieces[firstPawnIndex]
            chess.pieces[firstPawnIndex] = Piece.empty
            return true
        }
    }
    
    return false
}
func moveKnight() -> Bool {
    let piecesIndices = Chess.boardIndices.filter { chess.pieces[$0].color == "Black" }
    let knightsIndices = piecesIndices.filter { chess.pieces[$0].name == "Knight" }
    guard let randomKnightIndex = knightsIndices.randomElement() else { return false }
    
    let possiblesMovesIndices = aiKnightMovementResult(piece: chess.pieces[randomKnightIndex], index: randomKnightIndex)
    
    //let eatMoves = possiblesMovesIndices.filter { chess?.pieces[$0] != Piece.empty }
    
    //        if !eatMoves.isEmpty {
    //            if let first = eatMoves.first {
    //
    //            }
    //        } else {
    //
    //        }
    
    guard let randomMoveIndex = possiblesMovesIndices.randomElement() else { return false }
    
    chess.pieces[randomMoveIndex] = chess.pieces[randomKnightIndex]
    chess.pieces[randomKnightIndex] = Piece.empty
    
    return true
}
func moveRook() -> Bool {
    let piecesIndices = Chess.boardIndices.filter { chess.pieces[$0].color == "Black" }
    let rooksIndices = piecesIndices.filter { chess.pieces[$0].name == "Rook" }
    guard let randomRookIndex = rooksIndices.randomElement() else { return false }
    
    let possiblesMovesIndices = aiRookMovementResult(piece: chess.pieces[randomRookIndex], index: randomRookIndex)
    
    guard let randomMoveIndex = possiblesMovesIndices.randomElement() else { return false }
    
    chess.pieces[randomMoveIndex] = chess.pieces[randomRookIndex]
    chess.pieces[randomRookIndex] = Piece.empty
    return true
}
func moveBishop() -> Bool {
    let piecesIndices = Chess.boardIndices.filter { chess.pieces[$0].color == "Black" }
    let bishopsIndices = piecesIndices.filter { chess.pieces[$0].name == "Bishop" }
    guard let randomBishopIndex = bishopsIndices.randomElement() else { return false }
    
    let possiblesMovesIndices = aiBishopMovementResult(piece: chess.pieces[randomBishopIndex], index: randomBishopIndex)
    
    guard let randomMoveIndex = possiblesMovesIndices.randomElement() else { return false }
    
    chess.pieces[randomMoveIndex] = chess.pieces[randomBishopIndex]
    chess.pieces[randomBishopIndex] = Piece.empty
    return true
}
func moveQueen() -> Bool {
    let piecesIndices = Chess.boardIndices.filter { chess.pieces[$0].color == "Black" }
    guard let queenIndex = piecesIndices.filter({ chess.pieces[$0].name == "Queen" }).first else { return false }
    let possiblesMovesIndices = aiQueenMovementResult(piece: chess.pieces[queenIndex], index: queenIndex)
    guard let randomMoveIndex = possiblesMovesIndices.randomElement() else { return false }
    
    chess.pieces[randomMoveIndex] = chess.pieces[queenIndex]
    chess.pieces[queenIndex] = Piece.empty
    return true
}
func moveKing() -> Bool {
    let piecesIndices = Chess.boardIndices.filter { chess.pieces[$0].color == "Black" }
    guard let kingIndex = piecesIndices.filter({ chess.pieces[$0].name == "King" }).first else { return false }
    let possiblesMovesIndices = aiKingMovementResult(piece: chess.pieces[kingIndex], index: kingIndex)
    guard let randomMoveIndex = possiblesMovesIndices.randomElement() else { return false }
    chess.pieces[randomMoveIndex] = chess.pieces[kingIndex]
    chess.pieces[kingIndex] = Piece.empty
    return true
}

func AIMove() {
    switch true {
//        case moveRook():
//            print("Moved Rook")
//        case moveBishop():
//            print("Moved Bishop")
//        case moveKnight():
//            print("Moved Knight")
//        case moveQueen():
//            print("Moved Queen")
    case movePawn():
        print("Moved Pawn")
//        case moveKing():
//            print("Moved King")
    default:
        print("Moved Nothing")
    }
} */
