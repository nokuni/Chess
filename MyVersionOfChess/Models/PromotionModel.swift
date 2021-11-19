//
//  PromotionModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 18/11/2021.
//

import Foundation

struct Promotion {
    var isAlertActive: Bool = false
    var selectedPieceIndex: Int? = nil
    
    func getPieces(from side: Side) -> [Piece] {
        let sidePieces = Piece.basic.filter { $0.color == side.rawValue }
        let promotionPiecesName = ["Queen", "Knight", "Rook", "Bishop"]
        let result = sidePieces.filter { promotionPiecesName.contains($0.name) }
        return result
    }
}
