//
//  GameView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var vm : ChessViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                BackButtonView()
                ZStack {
                    Group {
                        Board
                        Pieces
                    }
                    PromotionAlert
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .preferredColorScheme(.dark)
            .environmentObject(ChessViewModel())
    }
}
