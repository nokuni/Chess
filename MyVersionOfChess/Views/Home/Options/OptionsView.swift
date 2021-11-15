//
//  OptionsView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var vm: ChessViewModel
    @State var isAlerting = false
    var body: some View {
            List {
                SideView(side: $vm.chess.side, isCurrentGameExisting: vm.isCurrentGameExisting, switchSide: vm.switchSide)
                SquareCustimizationView(theme: $vm.chess.theme)
                ResetButtonView(isAlerting: $isAlerting, isCurrentGameExisting: vm.isCurrentGameExisting, reset: vm.reset)
            }
            .navigationTitle("Options")
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
            .environmentObject(ChessViewModel())
    }
}
