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
        ZStack {
            Background
            VStack {
                BackButtonView()
                Title
                Sides
                Themes
                Spacer()
            }
            OptionAlert
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(isAlertOn: .constant(false))
            .environmentObject(ChessViewModel())
    }
}
