//
//  PieceModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import Foundation

struct Piece: Codable, Hashable {
    var name: String
    var image: String?
    var value: String
    var color: String
}
