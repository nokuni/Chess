//
//  ChessViewModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import Foundation
import SwiftUI

final class ChessViewModel: ObservableObject {
    @Published var chess: Chess = Chess.defaultGame
    @Published var isYourTurn: Bool = true
    
    // Colored Overlay for pieces movements
    @Published var coloredOverlayMatchIndex: Int? = nil
    @Published var coloredOverlayPieceIndex: Int? = nil
    @Published var coloredOverlayPreMoves: [Int] = []
    
    // Pawn promotion alert and index selection of the choosen piece
    @Published var isPromotionAlertActive = false
    @Published var selectedPromotionPieceIndex: Int? = nil
    
    static let grid = [GridItem](repeating: GridItem(.flexible(), spacing: 0), count: 8)
    static let instance = ChessViewModel()
    
    // MARK: - Premoves and pieces movement visual related
    var resetPremoves: Void { coloredOverlayPreMoves.removeAll() }
    func addPremoves(piece: Piece, index: Int) {
        for moveIndex in allowedTappedMoves(piece: piece, index: index) { coloredOverlayPreMoves.append(moveIndex) }
    }
    func overlayPieceSquare(at index: Int) { coloredOverlayPieceIndex = index }
    func overlayMatchingSquare(at index: Int) { coloredOverlayMatchIndex = index }
    
    // MARK: - Pawn Promotion related
    var promotionsPieces: [Piece] {
        let playerPieces = chess.theme.pieces.filter { $0.color == chess.side.rawValue }
        let queen = playerPieces.filter { $0.name == "Queen" }
        let knight = playerPieces.filter { $0.name == "Knight" }
        let rook = playerPieces.filter { $0.name == "Rook" }
        let bishop = playerPieces.filter { $0.name == "Bishop" }
        
        return queen + knight + rook + bishop
    }
    func choosePromotionPiece(piece: Piece) {
        if let promotionIndex = selectedPromotionPieceIndex {
            chess.pieces[promotionIndex] = piece
            isPromotionAlertActive = false
        }
    }
    
    // MARK: - Conditions
    func checkPieceMovement(piece: Piece, pieceIndex: Int) {
        if let match = coloredOverlayMatchIndex {
            if allowedTappedMoves(piece: chess.pieces[pieceIndex], index: pieceIndex).contains(match) {
                movePiece(match: match, pieceIndex: pieceIndex)
                if chess.pieces[match].name == "Pawn" { promote }
                resetSelections
            } else {
                resetSelections
            }
        }
    }
    func isOurSide(_ piece: Piece) -> Bool { piece.color == chess.side.rawValue && !piece.name.isEmpty }
    
    // MARK: - Piece selection and actions
    func movePiece(match: Int, pieceIndex: Int) {
        chess.pieces[match] = chess.pieces[pieceIndex]
        chess.pieces[pieceIndex] = Piece.empty
    }
    var resetSelections: Void {
        coloredOverlayPieceIndex = nil
        coloredOverlayMatchIndex = nil
    }
    
    // via Drag Gesture
    func pieceHolded(location: CGPoint, index: Int, piece: Piece) {
        overlayPieceSquare(at: index)
        if let match = chess.frames.firstIndex(where: { $0.contains(location) }) {
            overlayMatchingSquare(at: match)
            addPremoves(piece: piece, index: index)
        }
    }
    func pieceDropped(location: CGPoint, index: Int, piece: Piece, match: Int) {
        chess.pieces[index] = chess.pieces[match]
        chess.pieces[match] = piece
        chess.pieces[index] = Piece.empty
        isYourTurn.toggle()
    }
    
    // via Tap Gesture
    func selectPiece(index: Int, piece: Piece) {
        resetPremoves
        if !piece.isSquareEmpty && isOurSide(piece) {
            overlayPieceSquare(at: index)
            addPremoves(piece: piece, index: index)
        }
    }
    func selectDestination(index: Int, piece: Piece) {
        guard let pieceIndex = coloredOverlayPieceIndex else { return }
        
        if piece.isSquareEmpty || !isOurSide(piece) {
            overlayMatchingSquare(at: index)
            checkPieceMovement(piece: piece, pieceIndex: pieceIndex)
            //turn = .AI
        }
    }
    
    // MARK: -  Get rows, columns and diagonals
    var rowsIndices: [[Int]] {
        return Array(chess.board.indices).separate(into: 8)
    }
    func getRow(at index: Int) -> [Int] {
        guard let result = rowsIndices.first(where: { $0.contains(index)}) else {
            return []
        }
        return result
    }
    func getRowIndex(at index: Int) -> Int {
        let separatedBoardIndices = Array(chess.board.indices).separate(into: 8)
        guard let rowIndex = separatedBoardIndices.firstIndex(where: { $0.contains(index) }) else { return 0 }
        return rowIndex
    }
    
    var columnsIndices: [[Int]] {
        var separatedBoardIndices = Array(chess.board.indices).separate(into: 8)
        var columns = [[Int]](repeating: [], count: 8)
        
        for i in separatedBoardIndices.indices {
            for index in separatedBoardIndices.indices {
                if let firstIndex = separatedBoardIndices[index].first {
                    columns[i].append(firstIndex)
                    separatedBoardIndices[index].removeFirst()
                }
            }
        }
        return columns
    }
    func getColumn(at index: Int) -> [Int] {
        let columns = columnsIndices
        guard let result = columns.first(where: { $0.contains(index) }) else { return [] }
        return result
    }
    func getColumnIndex(at index: Int) -> Int {
        let columns = columnsIndices
        guard let columnIndex = columns.firstIndex(where: { $0.contains(index)}) else { return 0 }
        return columnIndex
    }
    
    func incrementIndices(_ indices: [Int]) -> [Int] {
        var number = 1
        var tempIndices = indices
        var result = [Int]()
        
        guard let firstColumn = columnsIndices.first else { return [] }
        guard let lastColumn = columnsIndices.last else { return [] }
        
        for index in tempIndices.indices {
            tempIndices[index] += number
            number += 1
            result.append(tempIndices[index])
            if firstColumn.contains(tempIndices[index]) || lastColumn.contains(tempIndices[index]) {
                break
            }
        }
        return result
    }
    func decrementIndices(_ indices: [Int]) -> [Int] {
        var number = 1
        var tempIndices = indices
        var result = [Int]()
        
        guard let firstColumn = columnsIndices.first else { return [] }
        guard let lastColumn = columnsIndices.last else { return [] }
        
        for index in tempIndices.indices {
            tempIndices[index] -= number
            number += 1
            result.append(tempIndices[index])
            if firstColumn.contains(tempIndices[index]) || lastColumn.contains(tempIndices[index]) {
                break
            }
        }
        return result
    }
    func scopeAxis(index: Int) -> [Int] {
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
                    if !isOurSide(chess.pieces[squareIndex]) { result.append(squareIndex) }
                    break
                }
            }
        }
        
        return result
    }
    func scopeDiagonals(index: Int) -> [Int] {
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
                    if !isOurSide(chess.pieces[squareIndex]) { result.append(squareIndex) }
                    break
                }
            }
        }
        return result
    }
    
    // MARK: - Pawn related
    func pawnMoveOneIndex(piece: Piece, index: Int) -> Int {
        let isPawn = piece.name == "Pawn"
        let playerIndex = index - 8
        let aiIndex = index + 8
        
        return isPawn && isOurSide(piece) && isYourTurn ? playerIndex : aiIndex
    }
    func pawnMoveTwoIndex(piece: Piece, index: Int) -> Int {
        let isPawn = piece.name == "Pawn"
        let playerIndex = index - 16
        let aiIndex = index + 16
        
        return isPawn && isOurSide(piece) && isYourTurn ? playerIndex : aiIndex
    }
    func pawnMoveDiagonals(piece: Piece, index: Int) -> [Int] {
        let isPawn = piece.name == "Pawn"
        let board = Chess.boardIndices
        
        guard let leftBorder = columnsIndices.first else { return [] }
        guard let rightBorder = columnsIndices.last else { return [] }
        
        let playerRightDiagonal = rightBorder.contains(index) ? -1 : index - 7
        let playerLeftDiagonal = leftBorder.contains(index) ? -1 : index - 9
        
        let playerDiagonals = [playerRightDiagonal, playerLeftDiagonal].filter { $0 != -1 }
        
        let AIRightDiagonal = rightBorder.contains(index) ? -1 : index + 9
        let AILeftDiagonal = leftBorder.contains(index) ? -1 : index + 7
        
        let AIDiagonals = [AIRightDiagonal, AILeftDiagonal].filter { $0 != -1 }
        
        return !board.contains(where: playerDiagonals.contains) || !board.contains(where: AIDiagonals.contains) ? [] : isPawn && isOurSide(piece) && isYourTurn ? playerDiagonals : AIDiagonals
    }
    var promote: Void {
        guard let match = coloredOverlayMatchIndex else { return }
        let lastRow = rowsIndices[0]
        let isOnLastRow = lastRow.contains(match)
        
        if isOnLastRow {
            isPromotionAlertActive = true
            selectedPromotionPieceIndex = match
            print("Promoted!")
        }
    }
    
    // MARK: - Chess pieces behaviors (via Tap Gesture)
    func tappedRookMoves(piece: Piece, index: Int) -> [Int] {
        var result = [Int]()
        let scope = scopeAxis(index: index)
        
        for move in scope {
            if !isOurSide(chess.pieces[move]) {
                result.append(move)
            }
        }
        return result
    }
    func tappedKnightMoves(piece: Piece, index: Int) -> [Int] {
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
            if !isOurSide(chess.pieces[move]) { result.append(move) }
        }
        return result
    }
    func tappedBishopMoves(piece: Piece, index: Int) -> [Int] {
        var result = [Int]()
        let scope = scopeDiagonals(index: index)
        
        for move in scope {
            if !isOurSide(chess.pieces[move]) {
                result.append(move)
            }
        }
        return result
    }
    func tappedQueenMoves(piece: Piece, index: Int) -> [Int] {
        var result = [Int]()
        let scope = scopeAxis(index: index) + scopeDiagonals(index: index)
        for move in scope {
            if !isOurSide(chess.pieces[move]) {
                result.append(move)
            }
        }
        return result
    }
    func tappedKingMoves(piece: Piece, index: Int) -> [Int] {
        var result = [Int]()
        let moves = [index - 8, index - 7, index + 1, index + 9, index + 8, index + 7, index - 1, index - 9].filter { Chess.boardIndices.contains($0) }
        for move in moves {
            if !isOurSide(chess.pieces[move]) {
                result.append(move)
            }
        }
        return result
    }
    func tappedPawnMoves(piece: Piece, index: Int) -> [Int] {
        var result = [Int]()
        
        let pawnStartIndices = rowsIndices[6]
        let isOnStartRow = pawnStartIndices.contains(index)
        
        let one = pawnMoveOneIndex(piece: piece, index: index)
        let two = pawnMoveTwoIndex(piece: piece, index: index)
        let diagonals = pawnMoveDiagonals(piece: piece, index: index)
        
        let isMovingOne = chess.pieces[one].isSquareEmpty
        let isMovingTwo = isOnStartRow && chess.pieces[two].isSquareEmpty && chess.pieces[one].isSquareEmpty
        
        if isMovingOne { result.append(one) }
        if isMovingTwo { result.append(two) }
        
        for moveIndex in diagonals {
            if !isOurSide(chess.pieces[moveIndex]) && !chess.pieces[moveIndex].isSquareEmpty { result.append(moveIndex) }
        }
        return result
    }
    
    // MARK: - Chess pieces behaviors (via Drag Gesture)
    func draggedPawnMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        
        let pawnStartIndices = rowsIndices[6]
        let isOnStartRow = pawnStartIndices.contains(index)
        let lastRow = rowsIndices[0]
        let isOnLastRow = lastRow.contains(match)
        
        let one = pawnMoveOneIndex(piece: piece, index: index)
        let two = pawnMoveTwoIndex(piece: piece, index: index)
        let diagonals = pawnMoveDiagonals(piece: piece, index: index)
        
        let checkDiagonals = pawnMoveDiagonals(piece: piece, index: match)
        
        var check: Void {
            for number in checkDiagonals {
                if chess.pieces[number].name.contains("King") && !isOurSide(chess.pieces[number]) {
                    print("Check")
                    break
                }
            }
        }
        var promote: Void {
            if isOnLastRow {
                isPromotionAlertActive = true
                selectedPromotionPieceIndex = match
            }
        }
        
        let isMovingOneForward = match == one
        let isMovingTwoForWard = isOnStartRow && match == two && chess.pieces[index - 8].image == "empty"
        
        if !chess.pieces[match].isSquareEmpty {
            for number in diagonals {
                if match == number && !isOurSide(chess.pieces[number]) {
                    pieceDropped(location: location, index: index, piece: piece, match: match)
                    promote
                    check
                    break
                }
            }
        }
        if chess.pieces[match].isSquareEmpty {
            if isMovingTwoForWard {
                pieceDropped(location: location, index: index, piece: piece, match: match)
                check
            } else if isMovingOneForward {
                pieceDropped(location: location, index: index, piece: piece, match: match)
                promote
                check
            }
        }
    }
    func draggedKingMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        let pawnCheckScope = [match - 7, match - 9].filter { Chess.boardIndices.contains($0) }
        let knightCheckScope = [match - 15, match - 6, match + 10, match + 17, match + 15, match + 6, match - 10, match - 17].filter { Chess.boardIndices.contains($0) }
        let kingCheckScope = [match - 8, match - 7, match + 1, match + 9, match + 8, match + 7, match - 1, match - 9].filter { Chess.boardIndices.contains($0) }
        
        var resultScope = [Int]()
        
        for number in pawnCheckScope {
            if !isOurSide(chess.pieces[number]) && chess.pieces[number].name.contains("Pawn") {
                resultScope.append(number)
            }
        }
        for number in knightCheckScope {
            if !isOurSide(chess.pieces[number]) && chess.pieces[number].name.contains("Knight") {
                resultScope.append(number)
            }
        }
        for number in scopeDiagonals(index: match) {
            if !isOurSide(chess.pieces[number]) && (chess.pieces[number].name.contains("Bishop") || chess.pieces[number].name.contains("Queen")) {
                resultScope.append(number)
            }
        }
        for number in scopeAxis(index: match) {
            if !isOurSide(chess.pieces[number]) && (chess.pieces[number].name.contains("Rook") || chess.pieces[number].name.contains("Queen")) {
                resultScope.append(number)
            }
        }
        for number in kingCheckScope {
            if !isOurSide(chess.pieces[number]) && chess.pieces[number].name.contains("King") {
                resultScope.append(number)
            }
        }
        
        if !isOurSide(chess.pieces[match]), resultScope.isEmpty {
            for move in Piece.kingMoves(index: index) {
                if match == move {
                    pieceDropped(location: location, index: index, piece: piece, match: match)
                    break
                }
            }
        }
    }
    func draggedRookMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        var check: Void {
            for index in scopeAxis(index: match) {
                if chess.pieces[index].name == "King" {
                    print("Check")
                    break
                }
            }
        } // WIP
        var isPossibleMove: Bool { return scopeAxis(index: index).contains(match) }
        if isOurSide(chess.pieces[index]), isPossibleMove {
            pieceDropped(location: location, index: index, piece: piece, match: match)
            check
        }
    }
    func draggedKnightMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        let scope = [index - 15, index - 6, index + 10, index + 17, index + 15, index + 6, index - 10, index - 17]
        let checkScope = [match - 15, match - 6, match + 10, match + 17, match + 15, match + 6, match - 10, match - 17].filter { Chess.boardIndices.contains($0) }
        var check: Void {
            for index in checkScope {
                if chess.pieces[index].name.contains("King") && !isOurSide(chess.pieces[index]) {
                    print("Check")
                    break
                }
            }
        }
        if !isOurSide(chess.pieces[match]) {
            for number in scope {
                if match == number {
                    pieceDropped(location: location, index: index, piece: piece, match: match)
                    check
                    break
                }
            }
        }
    }
    func draggedBishopMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        var check: Void {
            for index in scopeDiagonals(index: match) {
                if chess.pieces[index].name == "King" {
                    print("Check")
                    break
                }
            }
        }
        var isPossibleToMove: Bool { return scopeDiagonals(index: index).contains(match) }
        if isOurSide(chess.pieces[index]), isPossibleToMove {
            pieceDropped(location: location, index: index, piece: piece, match: match)
            check
        }
    }
    func draggedQueenMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        var moves: [Int] { scopeAxis(index: index) + scopeDiagonals(index: index) }
        var checkMoves: [Int] { scopeAxis(index: match) + scopeDiagonals(index: match) }
        var check: Void {
            for index in checkMoves {
                if chess.pieces[index].name == "King" {
                    print("Check")
                    break
                }
            }
        }
        var isPossibleToMove: Bool { return moves.contains(match) }
        if isOurSide(chess.pieces[index]), isPossibleToMove {
            pieceDropped(location: location, index: index, piece: piece, match: match)
            check
        }
    }
    
    func allowedTappedMoves(piece: Piece, index: Int) -> [Int] {
        switch piece.name {
        case "Rook":
            return tappedRookMoves(piece: piece, index: index)
        case "Knight":
            return tappedKnightMoves(piece: piece, index: index)
        case "Bishop":
            return tappedBishopMoves(piece: piece, index: index)
        case "Queen":
            return tappedQueenMoves(piece: piece, index: index)
        case "King":
            return tappedKingMoves(piece: piece, index: index)
        case "Pawn":
            return tappedPawnMoves(piece: piece, index: index)
        default:
            return []
        }
    }
    func allowedDraggedMoved(location: CGPoint, index: Int, piece: Piece) {
        switch piece.name {
        case "Rook":
            draggedRookMoves(location: location, index: index, piece: piece)
        case "Knight":
            draggedKnightMoves(location: location, index: index, piece: piece)
        case "Bishop":
            draggedBishopMoves(location: location, index: index, piece: piece)
        case "Queen":
            draggedQueenMoves(location: location, index: index, piece: piece)
        case "King":
            draggedKingMoves(location: location, index: index, piece: piece)
        case "Pawn":
            draggedPawnMoves(location: location, index: index, piece: piece)
        default:
            print("No action")
        }
        resetSelections
        if !isYourTurn {
            moveAIPawn()
            isYourTurn.toggle()
        }
    }
    
    var startingBoard: [Piece] {
        // "Middle" pieces are Rook, Knight and Bishop. "High" pieces are Queen and King"
        var unwrappedChess = chess
        
        let blackPieces = unwrappedChess.theme.pieces.filter { $0.color.contains("Black") }
        let whitePieces = unwrappedChess.theme.pieces.filter { $0.color.contains("White") }
        
        let middleBlackPieces = blackPieces.filter { $0.value == 3 || $0.value == 5 }.sorted { $0.name > $1.name }
        let highBlackPieces = blackPieces.filter { $0.value >= 9 }.sorted { $0.name > $1.name }
        guard let blackPawn = blackPieces.filter({ $0.value == 1 }).first else { return [] }
        
        guard let whitePawn = whitePieces.filter({ $0.value == 1 }).first else { return [] }
        let highWhitePieces = whitePieces.filter { $0.value >= 9 }.sorted { $0.name > $1.name }
        let middleWhitePieces = whitePieces.filter { $0.value == 3 || $0.value == 5 }.sorted { $0.name > $1.name }
        
        let blackBackRow = middleBlackPieces + highBlackPieces + middleBlackPieces.reversed()
        let blackFrontRow = [Piece](repeating: blackPawn, count: 8)
        
        let whiteFrontRow = [Piece](repeating: whitePawn, count: 8)
        let whiteBackRow = middleWhitePieces + highWhitePieces + middleWhitePieces.reversed()
        
        if chess.side == .white {
            unwrappedChess.pieces.replaceSubrange(0..<8, with: blackBackRow)
            unwrappedChess.pieces.replaceSubrange(8..<16, with: blackFrontRow)
            unwrappedChess.pieces.replaceSubrange(48..<56, with: whiteFrontRow)
            unwrappedChess.pieces.replaceSubrange(56..<64, with: whiteBackRow)
        } else {
            unwrappedChess.pieces.replaceSubrange(0..<8, with: whiteBackRow)
            unwrappedChess.pieces.replaceSubrange(8..<16, with: whiteFrontRow)
            unwrappedChess.pieces.replaceSubrange(48..<56, with: blackFrontRow)
            unwrappedChess.pieces.replaceSubrange(56..<64, with: blackBackRow)
        }
        
        return unwrappedChess.pieces
    }
    
    func reset() {
        resetPremoves
        resetSelections
        chess.pieces = [Piece](repeating: Piece.empty, count: 64)
        chess.pieces = startingBoard
    }
    func switchSide(side: Side) {
        chess.side = side
        reset()
    }
    var isCurrentGameExisting: Bool {
        return chess.pieces != startingBoard ? true : false
    }
    
    // MARK: - AI
    
    var AIPawnIndices: [Int] {
        let piecesIndices = Chess.boardIndices.filter { !isOurSide(chess.pieces[$0]) }
        return piecesIndices.filter { chess.pieces[$0].name == "Pawn" }
    }
    var randomAIPawn: Piece {
        guard let randomPawnIndex = AIPawnIndices.randomElement() else { return Piece.empty }
        return chess.pieces[randomPawnIndex]
    }
    
    func AIPawnEat() {
        if let firstIndex = indicesOfPawnsWhoCanEat.first {
            let diagonals = pawnMoveDiagonals(piece: chess.pieces[firstIndex], index: firstIndex)
            if let firstDiagonal = diagonals.first,
               let lastDiagonal = diagonals.last {
                let diagonalPiecesValues = [chess.pieces[firstDiagonal].value, chess.pieces[lastDiagonal].value]
                if let mostValuableIndex = diagonalPiecesValues.firstIndex(where: { $0 == diagonalPiecesValues.max() }) {
                    let diagonal = mostValuableIndex == 0 ? firstDiagonal : lastDiagonal
                    if isOurSide(chess.pieces[diagonal]) {
                        chess.pieces[diagonal] = chess.pieces[firstIndex]
                        chess.pieces[firstIndex] = Piece.empty
                    }
                }
            }
        }
    }
    
    func moveAIPawn() {
        guard let randomPawnIndex = AIPawnIndices.randomElement() else { return }
        let pawnStartIndices = rowsIndices[1]
        let isOnStartRow = pawnStartIndices.contains(where: AIPawnIndices.contains)
        
        let one = pawnMoveOneIndex(piece: chess.pieces[randomPawnIndex], index: randomPawnIndex)
        let two = pawnMoveTwoIndex(piece: chess.pieces[randomPawnIndex], index: randomPawnIndex)
        
        AIPawnEat()
        chess.pieces[one] = chess.pieces[randomPawnIndex]
        chess.pieces[randomPawnIndex] = Piece.empty
        
    }
    var indicesOfPawnsWhoCanEat: [Int] {
        var pawnsIndices = [Int]()
        for pawnIndex in AIPawnIndices {
            for index in pawnMoveDiagonals(piece: chess.pieces[pawnIndex], index: pawnIndex) {
                if isOurSide(chess.pieces[index]) { pawnsIndices.append(pawnIndex) }
            }
        }
        return Array(Set(pawnsIndices))
    }
    func isAnyPawnCanEat() -> Bool {
        var diagonals = [[Int]](repeating: [], count: AIPawnIndices.count)
        for pawnIndex in AIPawnIndices {
            diagonals.append(pawnMoveDiagonals(piece: chess.pieces[pawnIndex], index: pawnIndex))
        }
        return !diagonals.isEmpty ? true : false
    }
    
    init() {
        chess.pieces = startingBoard
    }
}
