//
//  OptionsViewExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

extension OptionsView {
    var Background: some View {
        Color.theme.background.ignoresSafeArea()
    }
    var Title: some View {
        Text("OPTIONS")
            .fontWeight(.heavy)
            .font(.system(.largeTitle, design: .rounded))
    }
    var Sides: some View {
        VStack {
            Text("Side")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
            HStack {
                ForEach(Side.allCases, id: \.self) { side in
                    SidesView(chess: $vm.chess, side: side)
                        .onTapGesture {
                            if vm.chess?.pieces != vm.startingBoard {
                                isAlertOn.toggle()
                            } else {
                                vm.chess?.side = side
                                vm.reset()
                            }
                        }
                        .padding()
                }
            }
            .background(
                Color.theme.accent
                    .cornerRadius(15)
                    .shadow(radius: 5)
            )
        }
        .padding()
    }
    
    var Themes: some View {
        VStack {
            Text("Themes")
                .fontWeight(.heavy)
                .font(.system(.title, design: .rounded))
            TabView(selection: $vm.themeIndex) {
                ForEach(Theme.allThemes, id: \.self) { theme in
                    ThemeView(chess: vm.chess, theme: theme)
                        .tag(theme.name)
                        .onTapGesture {
                            vm.chess?.theme = theme
                            vm.themeIndex = theme.name
                        }
                }
            }
            .frame(maxHeight: 180)
            .background(
                Color.theme.accent
                    .cornerRadius(15)
                    .shadow(radius: 5)
            )
            .padding(.horizontal)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    var OptionAlert: some View {
        CustomAlertView(alert: AlertModel(title: "Warning!", message: "You have a game in progress, this action will restart a new one, are you sure?", primaryAction: AlertAction(actionLabel: "Nope", action: nil), secondaryAction: AlertAction(actionLabel: "Sure", action: vm.reset)), isAlertOn: $isAlertOn)
    }
}
