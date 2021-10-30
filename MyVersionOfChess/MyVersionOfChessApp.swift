//
//  MyVersionOfChessApp.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

@main
struct MyVersionOfChessApp: App {
    @StateObject var viewModel = ChessViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .environmentObject(viewModel)
        }
    }
}
