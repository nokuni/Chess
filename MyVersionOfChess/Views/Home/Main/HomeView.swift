//
//  HomeView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: ChessViewModel
    @State var isAlertOn = false
    var body: some View {
        ZStack {
            Background
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    Title
                    NewGameButton
                    RestartButton
                    OptionButton
                }
            }
            HomeAlert
        }
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
