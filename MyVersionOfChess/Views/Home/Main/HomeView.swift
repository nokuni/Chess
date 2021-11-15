//
//  HomeView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: ChessViewModel
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    NavigationLink(destination: GameView()) {
                        HomeButtonView(name: "New Game", color: .theme.newGame, width: geometry.size.width, height: geometry.size.height * 0.35)
                    }
                    NavigationLink(destination: OptionsView()) {
                        HomeButtonView(name: "Options", color: .theme.options, width: geometry.size.width, height: geometry.size.height * 0.15)
                    }
                }
            }
        }
        .navigationTitle("Chess")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .preferredColorScheme(.light)
        .environmentObject(ChessViewModel())
    }
}

//HomeButtonView(name: "Restart", color: vm.chess?.pieces != vm.startingBoard ? .theme.restart : .gray, width: geometry.size.width, height: geometry.size.height)
//    .onTapGesture {
//        if vm.chess?.pieces != vm.startingBoard { isAlertOn.toggle() }
//    }
