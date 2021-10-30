//
//  ColorExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

extension Color {
    static let chessGreen = Color(red: 120/255, green: 148/255, blue: 84/255)
    static let chessGreenWhite = Color(red: 240/255, green: 236/255, blue: 212/255)
    
    static let chessDarkWood = Color(red: 162/255, green: 95/255, blue: 29/255)
    static let chessDarkWoodWhite = Color(red: 251/255, green: 205/255, blue: 149/255)
    
    static let chessBlueGreen = Color(red: 3/255, green: 74/255, blue: 60/255)
    static let chessBlueGreenWhite = Color(red: 228/255, green: 224/255, blue: 213/255)
    
    static let chessBlack = Color(red: 0.130, green: 0.130, blue: 0.130)
    static let chessBlackWhite = Color.white
    
    static let customYellow = Color(red: 255/255, green: 255/255, blue: 0/255)
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let newGame = Color("NewGameColor")
    let restart = Color("RestartColor")
    let options = Color("OptionsColor")
    let background = Color("BackgroundColor")
    
    let classicWhite = Color("ClassicWhite")
    let classicBlack = Color("ClassicBlack")
    let premove = Color("PremoveColor")
}
