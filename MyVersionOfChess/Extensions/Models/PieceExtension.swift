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
        return Bundle.main.decode("BasicChessPieces")
    }
    
    var isSquareEmpty: Bool { self.color == "empty" }
    var isOurSide: Bool { self.color == ChessViewModel.instance.chess.side.rawValue && !self.name.isEmpty }
}

extension Bundle {
    func decode<T: Decodable>(_ resource: String) -> [T] {
        if let url = url(forResource: resource, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode([T].self, from: data) {
            return decodedData
        }
        return []
    }
}
