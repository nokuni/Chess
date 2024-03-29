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
    
    static let grid = [GridItem](repeating: GridItem(.flexible(), spacing: 0), count: 8)
    
    // MARK: - Pawn Promotion related
    func choosePromotionPiece(piece: Piece) {
        if let promotionIndex = chess.promotion.selectedPieceIndex {
            chess.pieces[promotionIndex] = piece
            chess.promotion.isAlertActive = false
        }
    }
    
    // MARK: - Conditions
    func checkPieceMovement(piece: Piece, pieceIndex: Int) {
        if let match = chess.premoves.coloredOverlayMatchIndex {
            if allowedTappedMoves(piece: chess.pieces[pieceIndex], index: pieceIndex).contains(match) {
                movePiece(match: match, pieceIndex: pieceIndex)
                if chess.pieces[match].name == "Pawn" { promote }
                chess.premoves.resetOverlay()
            } else {
                chess.premoves.resetOverlay()
            }
        }
    }
    
    // MARK: - Piece selection and actions
    func movePiece(match: Int, pieceIndex: Int) {
        chess.pieces[match] = chess.pieces[pieceIndex]
        chess.pieces[pieceIndex] = Piece.empty
    }
    
    // via Drag Gesture
    func pieceHolded(location: CGPoint, index: Int, piece: Piece) {
        chess.premoves.setOverlayPieceSquare(at: index)
        if let match = chess.frames.firstIndex(where: { $0.contains(location) }) {
            chess.premoves.setOverlayMatchingSquare(at: match)
            chess.premoves.addPremoves(from: allowedTappedMoves, piece: piece, index: index)
        }
    }
    func pieceDropped(location: CGPoint, index: Int, piece: Piece, match: Int) {
        chess.pieces[index] = chess.pieces[match]
        chess.pieces[match] = piece
        chess.pieces[index] = Piece.empty
        chess.isYourTurn.toggle()
        chess.hasGameStarted = true
    }
    
    // via Tap Gesture
    func selectPiece(index: Int, piece: Piece) {
        chess.premoves.emptyOverlay()
        if !piece.isSquareEmpty && chess.isOurSide(piece) {
            chess.premoves.setOverlayPieceSquare(at: index)
            chess.premoves.addPremoves(from: allowedTappedMoves, piece: piece, index: index)
        }
    }
    func selectDestination(index: Int, piece: Piece) {
        guard let pieceIndex = chess.premoves.coloredOverlayPieceIndex else { return }
        if piece.isSquareEmpty || !chess.isOurSide(piece) {
            chess.premoves.setOverlayMatchingSquare(at: index)
            checkPieceMovement(piece: piece, pieceIndex: pieceIndex)
            chess.hasGameStarted = true
            //turn = .AI
        }
    }
    
    // MARK: - Pawn related
    func pawnMoveOneIndex(piece: Piece, index: Int) -> Int {
        let isPawn = piece.name == "Pawn"
        let playerIndex = index - 8
        let aiIndex = index + 8
        return isPawn && chess.isOurSide(piece) && chess.isYourTurn ? playerIndex : aiIndex
    }
    func pawnMoveTwoIndex(piece: Piece, index: Int) -> Int {
        let isPawn = piece.name == "Pawn"
        let playerIndex = index - 16
        let aiIndex = index + 16
        
        return isPawn && chess.isOurSide(piece) && chess.isYourTurn ? playerIndex : aiIndex
    }
    func pawnMoveDiagonals(piece: Piece, index: Int) -> [Int] {
        let isPawn = piece.name == "Pawn"
        let board = Chess.boardIndices
        
        guard let leftBorder = chess.board.getColumnsIndices(number: 8).first else { return [] }
        guard let rightBorder = chess.board.getColumnsIndices(number: 8).last else { return [] }
        
        let playerRightDiagonal = rightBorder.contains(index) ? -1 : index - 7
        let playerLeftDiagonal = leftBorder.contains(index) ? -1 : index - 9
        
        let playerDiagonals = [playerRightDiagonal, playerLeftDiagonal].filter { $0 != -1 }
        
        let AIRightDiagonal = rightBorder.contains(index) ? -1 : index + 9
        let AILeftDiagonal = leftBorder.contains(index) ? -1 : index + 7
        
        let AIDiagonals = [AIRightDiagonal, AILeftDiagonal].filter { $0 != -1 }
        
        return !board.contains(where: playerDiagonals.contains) || !board.contains(where: AIDiagonals.contains) ? [] : isPawn && chess.isOurSide(piece) && chess.isYourTurn ? playerDiagonals : AIDiagonals
    }
    var promote: Void {
        guard let match = chess.premoves.coloredOverlayMatchIndex else { return }
        let lastRow = chess.rowsIndices[0]
        let isOnLastRow = lastRow.contains(match)
        
        if isOnLastRow {
            chess.promotion.isAlertActive = true
            chess.promotion.selectedPieceIndex = match
            print("Promoted!")
        }
    }
    
    // MARK: - Chess pieces behaviors (via Tap Gesture)
    func tappedRookMoves(index: Int) -> [Int] {
        var result = [Int]()
        chess.getAxisScope(at: index).forEach {
            if !chess.isOurSide(chess.pieces[$0]) { result.append($0) }
        }
        return result
    }
    func tappedKnightMoves(index: Int) -> [Int] {
        var result = [Int]()
        let moves = Piece.knightMoves(chess: chess, index: index)
        for move in moves {
            if !chess.isOurSide(chess.pieces[move]) { result.append(move) }
        }
        return result
    }
    func tappedBishopMoves(index: Int) -> [Int] {
        var result = [Int]()
        chess.getDiagonalScope(at: index).forEach {
            if !chess.isOurSide(chess.pieces[$0]) { result.append($0) }
        }
        return result
    }
    func tappedQueenMoves(index: Int) -> [Int] {
        var result = [Int]()
        let scope = chess.getAxisScope(at: index) + chess.getDiagonalScope(at: index)
        scope.forEach {
            if !chess.isOurSide(chess.pieces[$0]) { result.append($0) }
        }
        return result
    }
    func tappedKingMoves(index: Int) -> [Int] {
        var result = [Int]()
        let moves = [index - 8, index - 7, index + 1, index + 9, index + 8, index + 7, index - 1, index - 9].filter { Chess.boardIndices.contains($0) }
        for move in moves {
            if !chess.isOurSide(chess.pieces[move]) {
                result.append(move)
            }
        }
        return result
    }
    func tappedPawnMoves(piece: Piece, index: Int) -> [Int] {
        var result = [Int]()
        
        let pawnStartIndices = chess.rowsIndices[6]
        let isOnStartRow = pawnStartIndices.contains(index)
        
        let one = pawnMoveOneIndex(piece: piece, index: index)
        let two = pawnMoveTwoIndex(piece: piece, index: index)
        let diagonals = pawnMoveDiagonals(piece: piece, index: index)
        
        let isMovingOne = chess.pieces[one].isSquareEmpty
        let isMovingTwo = isOnStartRow && chess.pieces[two].isSquareEmpty && chess.pieces[one].isSquareEmpty
        
        if isMovingOne { result.append(one) }
        if isMovingTwo { result.append(two) }
        
        for moveIndex in diagonals {
            if !chess.isOurSide(chess.pieces[moveIndex]) && !chess.pieces[moveIndex].isSquareEmpty { result.append(moveIndex) }
        }
        return result
    }
    
    // MARK: - Chess pieces behaviors (via Drag Gesture)
    func draggedPawnMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        
        let pawnStartIndices = chess.rowsIndices[6]
        let isOnStartRow = pawnStartIndices.contains(index)
        let lastRow = chess.rowsIndices[0]
        let isOnLastRow = lastRow.contains(match)
        
        let one = pawnMoveOneIndex(piece: piece, index: index)
        let two = pawnMoveTwoIndex(piece: piece, index: index)
        let diagonals = pawnMoveDiagonals(piece: piece, index: index)
        
        let checkDiagonals = pawnMoveDiagonals(piece: piece, index: match)
        
        var check: Void {
            for number in checkDiagonals {
                if chess.pieces[number].name.contains("King") && !chess.isOurSide(chess.pieces[number]) {
                    print("Check")
                    break
                }
            }
        }
        var promote: Void {
            if isOnLastRow {
                chess.promotion.isAlertActive = true
                chess.promotion.selectedPieceIndex = match
            }
        }
        
        let isMovingOneForward = match == one
        let isMovingTwoForWard = isOnStartRow && match == two && chess.pieces[index - 8].image == "empty"
        
        if !chess.pieces[match].isSquareEmpty {
            for number in diagonals {
                if match == number && !chess.isOurSide(chess.pieces[number]) {
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
        let pawnScope = pawnCheckScope.filter { !chess.isOurSide(chess.pieces[$0]) && chess.pieces[$0].name.contains("Pawn") }
        let knightScope = Piece.knightMoves(chess: chess, index: match).filter { !chess.isOurSide(chess.pieces[$0]) && chess.pieces[$0].name.contains("Knight") }
        let kingScope = Piece.kingMoves(index: match).filter { !chess.isOurSide(chess.pieces[$0]) && chess.pieces[$0].name.contains("King") }
        let bishopScope = chess.getDiagonalScope(at: match).filter { !chess.isOurSide(chess.pieces[$0]) && (chess.pieces[$0].name.contains("Bishop") || chess.pieces[$0].name.contains("Queen")) }
        let rookScope = chess.getAxisScope(at: match).filter { !chess.isOurSide(chess.pieces[$0]) && (chess.pieces[$0].name.contains("Rook") || chess.pieces[$0].name.contains("Queen")) }
        
        let resultScope = pawnScope + knightScope + kingScope + bishopScope + rookScope
        
        if !chess.isOurSide(chess.pieces[match]) && resultScope.isEmpty {
            print("Passed")
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
            for index in chess.getAxisScope(at: match) {
                if chess.pieces[index].name == "King" {
                    print("Check")
                    break
                }
            }
        } // WIP
        var isPossibleMove: Bool { return chess.getAxisScope(at: index).contains(match) }
        if chess.isOurSide(chess.pieces[index]), isPossibleMove {
            pieceDropped(location: location, index: index, piece: piece, match: match)
            check
        }
    }
    func draggedKnightMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        let scope = Piece.knightMoves(chess: chess, index: index)
        let checkScope = Piece.knightMoves(chess: chess, index: match)
        var check: Void {
            for index in checkScope {
                if chess.pieces[index].name.contains("King") && !chess.isOurSide(chess.pieces[index]) {
                    print("Check")
                    break
                }
            }
        }
        if !chess.isOurSide(chess.pieces[match]) {
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
            for index in chess.getDiagonalScope(at: match) {
                if chess.pieces[index].name == "King" {
                    print("Check")
                    break
                }
            }
        }
        var isPossibleToMove: Bool { return chess.getDiagonalScope(at: index).contains(match) }
        if chess.isOurSide(chess.pieces[index]), isPossibleToMove {
            pieceDropped(location: location, index: index, piece: piece, match: match)
            check
        }
    }
    func draggedQueenMoves(location: CGPoint, index: Int, piece: Piece) {
        guard let match = chess.frames.firstIndex(where: { $0.contains(location) }) else { return }
        var moves: [Int] { chess.getAxisScope(at: index) + chess.getDiagonalScope(at: index) }
        var checkMoves: [Int] { chess.getAxisScope(at: match) + chess.getDiagonalScope(at: match) }
        var check: Void {
            for index in checkMoves {
                if chess.pieces[index].name == "King" {
                    print("Check")
                    break
                }
            }
        }
        var isPossibleToMove: Bool { return moves.contains(match) }
        if chess.isOurSide(chess.pieces[index]), isPossibleToMove {
            pieceDropped(location: location, index: index, piece: piece, match: match)
            check
        }
    }
    
    func allowedTappedMoves(piece: Piece, index: Int) -> [Int] {
        switch piece.name {
        case "Rook":
            return tappedRookMoves(index: index)
        case "Knight":
            return tappedKnightMoves(index: index)
        case "Bishop":
            return tappedBishopMoves(index: index)
        case "Queen":
            return tappedQueenMoves(index: index)
        case "King":
            return tappedKingMoves(index: index)
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
        chess.premoves.resetOverlay()
        if !chess.isYourTurn {
            moveAIKnight()
            moveAIPawn()
        }
    }
    
    var startingBoard: [Piece] {
        let blackPieces = chess.theme.pieces.filter { $0.color.contains("Black") }
        let whitePieces = chess.theme.pieces.filter { $0.color.contains("White") }
        
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
            chess.pieces.replaceSubrange(0..<8, with: blackBackRow)
            chess.pieces.replaceSubrange(8..<16, with: blackFrontRow)
            chess.pieces.replaceSubrange(48..<56, with: whiteFrontRow)
            chess.pieces.replaceSubrange(56..<64, with: whiteBackRow)
        } else {
            chess.pieces.replaceSubrange(0..<8, with: whiteBackRow)
            chess.pieces.replaceSubrange(8..<16, with: whiteFrontRow)
            chess.pieces.replaceSubrange(48..<56, with: blackFrontRow)
            chess.pieces.replaceSubrange(56..<64, with: blackBackRow)
        }
        
        return chess.pieces
    }
    
    func reset() {
        chess.premoves.emptyOverlay()
        chess.premoves.resetOverlay()
        chess.pieces = [Piece](repeating: Piece.empty, count: 64)
        chess.pieces = startingBoard
        chess.hasGameStarted = false
    }
    func switchSide(side: Side) {
        chess.side = side
        reset()
    }
    
    // MARK: - AI
    
    // Pawn AI
    var AIPawnIndices: [Int] {
        let piecesIndices = Chess.boardIndices.filter { !chess.isOurSide(chess.pieces[$0]) }
        return piecesIndices.filter { chess.pieces[$0].name == "Pawn" }
    }
    var indicesOfPawnsWhoCanEat: [Int] {
        var pawnsIndices = [Int]()
        for pawnIndex in AIPawnIndices {
            for index in pawnMoveDiagonals(piece: chess.pieces[pawnIndex], index: pawnIndex) {
                if chess.isOurSide(chess.pieces[index]) { pawnsIndices.append(pawnIndex) }
            }
        }
        return Array((pawnsIndices))
    }
    func getAIPawnThreatenMoves(on number: Int) -> [Int] {
        var pawnsIndices = [Int]()
        let nextIndices = AIPawnIndices.map { $0 + number }
        for pawnIndex in nextIndices {
            let diagonals = pawnMoveDiagonals(piece: chess.pieces[pawnIndex], index: pawnIndex).filter { Chess.boardIndices.contains($0) }
            for index in diagonals {
                if chess.isOurSide(chess.pieces[index]) { pawnsIndices.append(pawnIndex) }
            }
        }
        return Array(Set(pawnsIndices))
    }
    func getAIPawnGuardMoves(on number: Int) -> [Int] {
        var pawnsIndices = [Int]()
        let nextIndices = AIPawnIndices.map { $0 + number }
        for pawnIndex in nextIndices {
            for index in pawnMoveDiagonals(piece: chess.pieces[pawnIndex], index: pawnIndex) {
                if !chess.isOurSide(chess.pieces[index]) { pawnsIndices.append(pawnIndex) }
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
    func AIPawnEat() {
        if !chess.isYourTurn {
            if let firstIndex = indicesOfPawnsWhoCanEat.first {
                let diagonals = pawnMoveDiagonals(piece: chess.pieces[firstIndex], index: firstIndex)
                if let firstDiagonal = diagonals.first,
                   let lastDiagonal = diagonals.last {
                    let diagonalPiecesValues = [chess.pieces[firstDiagonal].value, chess.pieces[lastDiagonal].value]
                    if let mostValuableIndex = diagonalPiecesValues.firstIndex(where: { $0 == diagonalPiecesValues.max() }) {
                        let diagonal = mostValuableIndex == 0 ? firstDiagonal : lastDiagonal
                        if chess.isOurSide(chess.pieces[diagonal]) {
                            chess.pieces[diagonal] = chess.pieces[firstIndex]
                            chess.pieces[firstIndex] = Piece.empty
                            chess.isYourTurn.toggle()
                        }
                    }
                }
            }
        }
    }
    func AIPawnThreatenMoveTwo() {
        guard let firstIndex = getAIPawnThreatenMoves(on: 16).first else { return }
        AIPawnMoveTwo(at: firstIndex - 16)
    }
    func AIPawnThreatenMoveOne() {
        guard let firstIndex = getAIPawnThreatenMoves(on: 8).first else { return }
        AIPawnMoveOne(at: firstIndex - 8)
    }
    func AIPawnMoveOne(at index: Int) {
        if !chess.isYourTurn {
            let one = pawnMoveOneIndex(piece: chess.pieces[index], index: index)
            let isMovingOneForward = chess.pieces[one].image == "empty"
            guard Chess.boardIndices.contains(one) else { return }
            if isMovingOneForward {
                chess.pieces[one] = chess.pieces[index]
                chess.pieces[index] = Piece.empty
                chess.isYourTurn.toggle()
            }
        }
    }
    func AIPawnMoveTwo(at index: Int) {
        if !chess.isYourTurn {
            let pawnStartIndices = chess.rowsIndices[1]
            let isOnStartRow = pawnStartIndices.contains(index)
            let two = pawnMoveTwoIndex(piece: chess.pieces[index], index: index)
            let isMovingTwoForWard = isOnStartRow && chess.pieces[two].image == "empty"
            guard Chess.boardIndices.contains(two) else { return }
            if isMovingTwoForWard {
                chess.pieces[two] = chess.pieces[index]
                chess.pieces[index] = Piece.empty
                chess.isYourTurn.toggle()
            }
        }
    }
    func moveAIPawn() {
        guard let firstPawnIndex = AIPawnIndices.first else { return }
        AIPawnEat()
        AIPawnThreatenMoveTwo()
        AIPawnThreatenMoveOne()
        AIPawnMoveTwo(at: firstPawnIndex)
        AIPawnMoveOne(at: firstPawnIndex)
    }
    
    // Knight AI
    var AIKnightIndices: [Int] {
        let piecesIndices = Chess.boardIndices.filter { !chess.isOurSide(chess.pieces[$0]) }
        return piecesIndices.filter { chess.pieces[$0].name == "Knight" }
    }
    var AIKnightEatingIndices: [Int] {
        var knightsIndices = [Int]()
        for knightIndex in AIKnightIndices {
            for index in Piece.knightMoves(chess: chess, index: knightIndex) {
                if chess.isOurSide(chess.pieces[index]) { knightsIndices.append(knightIndex) }
            }
        }
        return Array(knightsIndices)
    }
    func AIKnightEat() {
        if !chess.isYourTurn {
            if let firstIndex = AIKnightEatingIndices.first {
                let eatingIndices = Piece.knightMoves(chess: chess, index: firstIndex).filter { chess.isOurSide(chess.pieces[$0]) }
                if let firstEatingIndex = eatingIndices.first {
                    chess.pieces[firstEatingIndex] = chess.pieces[firstIndex]
                    chess.pieces[firstIndex] = Piece.empty
                    chess.isYourTurn.toggle()
                }
            }
        }
    }
    func getAIKnightThreatenMoves(knightIndex: Int) -> [Int] {
        var threatenIndices = [Int]()
        let moves = Piece.knightMoves(chess: chess, index: knightIndex)
        for move in moves {
            for threat in Piece.knightMoves(chess: chess, index: move) {
                if chess.isOurSide(chess.pieces[threat]) {
                    threatenIndices.append(threat)
                }
            }
//            if Piece.knightMoves(chess: chess, index: move).contains(where: { chess.isOurSide(chess.pieces[$0]) }) {
//                threatenIndices.append(move)
//            }
        }
        return threatenIndices
    }
    func AIKnightThreatenMove() {
        
        if let firstKnightIndex = AIKnightIndices.first {
            print(getAIPawnThreatenMoves(on: firstKnightIndex))
            if let firstIndex = getAIPawnThreatenMoves(on: firstKnightIndex).first {
                AIKnightMove(at: firstIndex)
            }
        }
        if let secondKnightIndex = AIKnightIndices.last {
            print(getAIPawnThreatenMoves(on: secondKnightIndex))
            if let firstIndex = getAIPawnThreatenMoves(on: secondKnightIndex).first {
                AIKnightMove(at: firstIndex)
            }
        }
    }
    func AIKnightMove(at index: Int) {
        if !chess.isYourTurn {
            let moves = Piece.knightMoves(chess: chess, index: index).filter { chess.isOurSide(chess.pieces[$0]) || chess.pieces[$0].isSquareEmpty }
            if let firstMoveIndex = moves.first {
                chess.pieces[firstMoveIndex] = chess.pieces[index]
                chess.pieces[index] = Piece.empty
                chess.isYourTurn.toggle()
            }
        }
    }
    func moveAIKnight() {
        guard let firstKnightIndex = AIKnightIndices.first else { return }
        AIKnightEat()
        AIKnightThreatenMove()
        AIKnightMove(at: firstKnightIndex)
    }
    
    init() {
        chess.pieces = startingBoard
    }
}
