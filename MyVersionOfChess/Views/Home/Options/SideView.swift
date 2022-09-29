//
//  SideView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 15/11/2021.
//

import SwiftUI

struct SideView: View {
    @ObservedObject var vm: ChessViewModel
    var body: some View {
        Section {
            Picker("", selection: $vm.chess.side) {
                ForEach(Side.allCases, id: \.self) {
                    Text($0.rawValue.capitalized)
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                }
            }
            .disabled(vm.chess.hasGameStarted)
            .pickerStyle(.segmented)
            .onChange(of: vm.chess.side) { side in
                vm.switchSide(side: side)
            }
        } header: {
            Text("Side")
        } footer: {
            Text("\(vm.chess.hasGameStarted ? "Game in progress ..." : "")")
        }
    }
}

struct SideView_Previews: PreviewProvider {
    static var previews: some View {
        SideView(vm: ChessViewModel())
    }
}
