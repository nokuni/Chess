//
//  SquareView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct SquareView: View {
    var theme: Theme
    var color: Color?
    var number: Int?
    var letter: String?
    var index: Int
    var width, height: CGFloat
    var body: some View {
        ZStack {
            if let color = color {
                Rectangle()
                    .frame(width: width, height: height)
                    .foregroundColor(color)
            }
            if let number = number {
                Text(number != 0 ? "\(number)" : "")
                    .bold()
                    .font(.footnote)
                    .foregroundColor(index % 16 == 0 ? theme.secondaryColor : theme.primaryColor)
                    .frame(width: UIScreen.main.bounds.width/8 - 5, height: UIScreen.main.bounds.width/8 - 5, alignment: .topLeading)
            }
            if let letter = letter {
                Text(letter)
                    .bold()
                    .font(.caption)
                    .foregroundColor(index % 2 == 0 ? theme.primaryColor : theme.secondaryColor)
                    .frame(width: UIScreen.main.bounds.width/8 - 5, height: UIScreen.main.bounds.width/8 - 5, alignment: .bottomTrailing)
            }
        }
    }
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
        SquareView(theme: .basic, index: 0, width: 100, height: 100)
    }
}
