//
//  ThemeExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import Foundation

extension Theme {
    static let basic = Theme(name: "Basic", primaryColor: .chessGreenWhite, secondaryColor: .chessGreen, pieces: Piece.basic)
    static let wood = Theme(name: "Wood", primaryColor: .chessDarkWoodWhite, secondaryColor: .chessDarkWood, pieces: Piece.basic)
    static let deepGreen = Theme(name: "Deep Green", primaryColor: .chessBlueGreenWhite, secondaryColor: .chessBlueGreen, pieces: Piece.basic)
    static let blackNWhite = Theme(name: "Black & White", primaryColor: .white, secondaryColor: .chessBlack, pieces: Piece.basic)
    
    static let allThemes = [basic, wood, deepGreen, blackNWhite]
}
