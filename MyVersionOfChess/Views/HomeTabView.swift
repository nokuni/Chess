//
//  HomeTabView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 15/11/2021.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            GameView().tabItem {
                Label("Chess", systemImage: "checkerboard.rectangle")
            }
            OptionsView().tabItem {
                Label("Options", systemImage: "gear")
            }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
            .environmentObject(ChessViewModel())
    }
}
