//
//  ChessModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct Chess {
    var board: [Color]
    var pieces: [Piece]
    var frames: [CGRect]
    var theme: Theme
    var side: Side
}
