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
    var NewGameButton: some View {
        NavigationLink(destination: GameView()) {
            HomeButtonView(name: "New Game", color: .theme.newGame)
        }
    }
    
    var RestartButton: some View {
        HomeButtonView(name: "Restart", color: vm.chess?.pieces != vm.startingBoard ? .theme.restart : .gray)
            .onTapGesture {
                if vm.chess?.pieces != vm.startingBoard { isAlertOn.toggle() }
            }
    }
    
    var OptionButton: some View {
        NavigationLink(destination: OptionsView(isAlertOn: $isAlertOn)) {
            HomeButtonView(name: "Options", color: .theme.options)
        }
    }
    
    var Options: some View {
        OptionsView(isAlertOn: $isAlertOn)
    }
    
    var HomeAlert: some View {
        CustomAlertView(alert: AlertModel(title: "Warning!", message: "You have a game in progress, do you really want to start a new one?", primaryAction: AlertAction(actionLabel: "Nope", action: nil), secondaryAction: AlertAction(actionLabel: "Sure", action: vm.reset)), isAlertOn: $isAlertOn)
    }
}
