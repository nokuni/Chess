//
//  SquareCustimizationView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 15/11/2021.
//

import SwiftUI

struct SquareCustimizationView: View {
    @Binding var theme: Theme
    var body: some View {
        Section {
            ColorPicker("Even Squares", selection: $theme.primaryColor)
            ColorPicker("Odd Squares", selection: $theme.secondaryColor)
        } header: {
            Text("Board Customization")
        }
    }
}

struct SquareCustimizationView_Previews: PreviewProvider {
    static var previews: some View {
        SquareCustimizationView(theme: .constant(.basic))
    }
}
