//
//  SideView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 15/11/2021.
//

import SwiftUI

struct SideView: View {
    @Binding var side: Side
    @Binding var isAlertOn: Bool
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
            .pickerStyle(.segmented)
            .onChange(of: side) { side in
                if isCurrentGameExisting {
                    isAlertOn.toggle()
                } else { switchSide?(side) }
            }
        } header: {
            Text("Side")
        }
    }
}

struct SideView_Previews: PreviewProvider {
    static var previews: some View {
        SideView(side: .constant(.white), isAlertOn: .constant(false), isCurrentGameExisting: false)
    }
}
