//
//  OptionsView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var vm: ChessViewModel
    @Binding var isAlertOn: Bool
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                List {
                    SideView(side: $vm.chess.side, isAlertOn: $isAlertOn, isCurrentGameExisting: vm.isCurrentGameExisting, switchSide: vm.switchSide)
                    SquareCustimizationView(theme: $vm.chess.theme)
                }
            }
            .alert("", isPresented: $isAlertOn) {
                Button("Switch") {
                    vm.reset()
                }
            } message: {
                Text("Switching side will result in a reset of your current game")
            }

        }
        .navigationTitle("Options")
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(isAlertOn: .constant(false))
            .environmentObject(ChessViewModel())
    }
}
