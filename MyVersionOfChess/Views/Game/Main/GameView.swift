//
//  GameView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var vm : ChessViewModel
    var body: some View {
        ZStack {
            Board
            Pieces
            PromotionAlert
        }
        .padding(.horizontal)
        .navigationTitle("\(vm.chess.side.rawValue)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(ChessViewModel())
    }
}
