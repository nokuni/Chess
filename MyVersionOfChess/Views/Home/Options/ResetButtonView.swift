//
//  ResetButtonView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 15/11/2021.
//

import SwiftUI

struct ResetButtonView: View {
    @ObservedObject var vm: ChessViewModel
    @Binding var isAlerting: Bool
    var body: some View {
        Section {
            HStack {
                Spacer()
                Button("Reset Game", role: .destructive) {
                    if vm.chess.hasGameStarted { isAlerting.toggle()
                    }
                }
                Spacer()
            }
        }
        .disabled(!vm.chess.hasGameStarted)
        .confirmationDialog("Warning", isPresented: $isAlerting) {
            Button("Reset", role: .destructive) { vm.reset() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("There is a game in progress, do you want to reset it?")
        }
    }
}

struct ResetButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ResetButtonView(vm: ChessViewModel(), isAlerting: .constant(false))
    }
}
