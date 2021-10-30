//
//  ThemeView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct ThemeView: View {
    private let grid = [GridItem](repeating: GridItem(.fixed(22)), count: 2)
    var chess: Chess?
    var theme: Theme
    var body: some View {
        VStack {
            if let chess = self.chess {
                Text(theme.name)
                    .fontWeight(.heavy)
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(chess.theme == theme ? .primary : Color(UIColor.systemGray2))
                ZStack {
                    HStack(spacing: 0) {
                        theme.primaryColor
                        theme.secondaryColor
                    }
                }
                .overlay(
                    chess.theme == theme ? Color.clear : .gray
                        .opacity(0.5)
                )
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .cornerRadius(15)
            }
        }
        .padding()
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(chess: Chess.defaultGame, theme: .basic)
    }
}
