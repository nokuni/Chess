//
//  ResetButtonView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 15/11/2021.
//

import SwiftUI

struct ResetButtonView: View {
    @Binding var isAlerting: Bool
    var isCurrentGameExisting: Bool
    var reset: (() -> Void)?
    var body: some View {
        Section {
            HStack {
                Spacer()
                Button("Reset Game", role: .destructive) {
                    if isCurrentGameExisting { isAlerting.toggle() }
                }
                Spacer()
            }
        }
        .disabled(!isCurrentGameExisting)
        .confirmationDialog("Warning", isPresented: $isAlerting) {
            Button("Reset", role: .destructive) { reset?() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("There is a game in progress, do you want to reset it?")
        }
    }
}

struct ResetButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ResetButtonView(isAlerting: .constant(false), isCurrentGameExisting: false)
    }
}
