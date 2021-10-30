//
//  ThemeModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct Theme: Hashable {
    let name: String
    let primaryColor: Color
    let secondaryColor: Color
    var pieces: [Piece]
}
