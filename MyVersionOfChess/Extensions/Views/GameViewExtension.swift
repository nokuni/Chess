//
//  GameViewExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

extension GameView {
    var Board: some View {
        SquareBoardView(chess: $vm.chess)
    }
    
    var Pieces: some View {
        BoardPieceView(chess: $vm.chess, selectPiece: vm.selectPiece, selectDestination: vm.selectDestination, onChanged: vm.pieceHolded, onEnded: vm.allowedDraggedMoved)
    }
    
    var PromotionAlert: some View {
        PromotionAlertView(promotionsPieces: vm.chess.promotion.getPieces(from: vm.chess.side), choosePromotionPiece: vm.choosePromotionPiece, isPromotionAlertActive: vm.chess.promotion.isAlertActive)
    }
}
