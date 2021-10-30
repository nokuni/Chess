//
//  PieceExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import Foundation

extension Piece {
    static let empty = Piece(name: "", image: "empty", value: "", color: "empty")
    static var basic: [Piece] {
        if let url = Bundle.main.url(forResource: "BasicChessPieces", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode([Piece].self, from: data) {
            return decodedData
        }
        return []
    }
}
