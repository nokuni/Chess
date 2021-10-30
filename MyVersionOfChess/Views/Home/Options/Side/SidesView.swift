//
//  SidesView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct SidesView: View {
    @Binding var chess: Chess?
    var side: Side
    var body: some View {
        if let chess = self.chess {
            Text("\(side.rawValue) side")
                .fontWeight(.heavy)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.theme.accent)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(chess.side == side ? .theme.newGame : .gray)
                )
        }
    }
}

struct SidesView_Previews: PreviewProvider {
    static var previews: some View {
        SidesView(chess: .constant(Chess.defaultGame), side: .white)
    }
}
