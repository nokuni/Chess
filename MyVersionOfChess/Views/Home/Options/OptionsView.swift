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
                SideView(vm: vm)
                SquareCustimizationView(theme: $vm.chess.theme)
                ResetButtonView(vm: vm, isAlerting: $isAlerting)
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
