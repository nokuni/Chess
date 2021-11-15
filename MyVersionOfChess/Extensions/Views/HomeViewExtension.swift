//
//  HomeViewExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

extension HomeView {
    
    var Background: some View {
        Color.theme.background.ignoresSafeArea()
    }
    var Title: some View {
        Text("CHESS")
            .fontWeight(.heavy)
            .font(.system(.largeTitle, design: .rounded))
    }
//    var NewGameButton: some View {
//        NavigationLink(destination: GameView()) {
//            HomeButtonView(name: "New Game", color: .theme.newGame)
//        }
//    }
    
//    var RestartButton: some View {
//        HomeButtonView(name: "Restart", color: vm.chess?.pieces != vm.startingBoard ? .theme.restart : .gray)
//            .onTapGesture {
//                if vm.chess?.pieces != vm.startingBoard { isAlertOn.toggle() }
//            }
//    }
//
//    var OptionButton: some View {
//        NavigationLink(destination: OptionsView(isAlertOn: $isAlertOn)) {
//            HomeButtonView(name: "Options", color: .theme.options)
//        }
//    }
    
    var Options: some View {
        OptionsView()
    }
}
