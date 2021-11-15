//
//  ThemeModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct Theme: Hashable {
    var primaryColor: Color
    var secondaryColor: Color
    var pieces: [Piece]
}
