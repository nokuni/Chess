//
//  HomeButtonView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct HomeButtonView: View {
    var name: String
    var color: Color
    var body: some View {
        Text(name)
            .font(.system(size: 30, weight: .heavy, design: .rounded))
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .padding()
            .background(
                color
                    .cornerRadius(15)
            )
            .padding(.horizontal)
    }
}

struct HomeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HomeButtonView(name: "Home", color: .accentColor)
    }
}
