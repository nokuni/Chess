//
//  SideView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 15/11/2021.
//

import SwiftUI

struct SideView: View {
    @Binding var side: Side
    var isCurrentGameExisting: Bool
    var switchSide: ((Side) -> Void)?
    var body: some View {
        Section {
            Picker("", selection: $side) {
                ForEach(Side.allCases, id: \.self) {
                    Text($0.rawValue.capitalized)
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                }
            }
            .disabled(isCurrentGameExisting)
            .pickerStyle(.segmented)
            .onChange(of: side) { side in
                switchSide?(side)
            }
        } header: {
            Text("Side")
        } footer: {
            Text("\(isCurrentGameExisting ? "Game in progress ..." : "")")
        }
    }
}

struct SideView_Previews: PreviewProvider {
    static var previews: some View {
        SideView(side: .constant(.white), isCurrentGameExisting: false)
    }
}
