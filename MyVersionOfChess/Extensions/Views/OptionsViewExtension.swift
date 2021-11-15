//
//  OptionsViewExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

extension OptionsView {
    var Background: some View {
        Color.theme.background.ignoresSafeArea()
    }
    var Title: some View {
        Text("OPTIONS")
            .fontWeight(.heavy)
            .font(.system(.largeTitle, design: .rounded))
    }
}
