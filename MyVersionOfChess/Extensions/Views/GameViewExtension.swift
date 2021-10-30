//
//  GameViewExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

extension GameView {
    var Board: some View {
        SquareBoardView(chess: $vm.chess, coloredOverlayMatchIndex: $vm.coloredOverlayMatchIndex, coloredOverlayPieceIndex: $vm.coloredOverlayPieceIndex, coloredOverlayPreMoves: $vm.coloredOverlayPreMoves, squareColors: vm.getSquareColor, squareNumbers: vm.getSquareNumbers, squareLetters: vm.getSquareLetters)
    }
    
    var Pieces: some View {
        BoardPieceView(chess: vm.chess ?? Chess.defaultGame, coloredOverlayMatchIndex: $vm.coloredOverlayMatchIndex, coloredOverlayPieceIndex: $vm.coloredOverlayPieceIndex, coloredOverlayPreMoves: $vm.coloredOverlayPreMoves, selectPiece: vm.selectPiece, selectDestination: vm.selectDestination, onChanged: vm.pieceHolded, onEnded: vm.allowedDraggedMoved)
    }
    
    var PromotionAlert: some View {
        PromotionAlertView(promotionsPieces: vm.promotionsPieces, choosePromotionPiece: vm.choosePromotionPiece, isPromotionAlertActive: vm.isPromotionAlertActive)
    }
}
