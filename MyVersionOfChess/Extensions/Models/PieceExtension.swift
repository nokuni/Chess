//
//  PieceExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import Foundation

extension Piece {
    static let empty = Piece(name: "", image: "empty", value: 0, color: "empty")
    static var basic: [Piece] {
        return Bundle.main.decode("BasicChessPieces")
    }
    
    static func kingMoves(index: Int) -> [Int] {
        return [index - 8, index - 7, index + 1, index + 9, index + 8, index + 7, index - 1, index - 9]
    }
    
    var isSquareEmpty: Bool { self.color == "empty" }
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
