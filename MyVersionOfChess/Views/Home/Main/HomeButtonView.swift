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
    var width, height: CGFloat
    var body: some View {
        ZStack {
            Color.theme.accent
                .cornerRadius(15)
                .shadow(radius: 5)
            Text(name)
                .foregroundColor(.black)
        }
        .padding()
        .frame(width: width, height: height)
//        Text(name)
//            .font(.system(size: 30, weight: .heavy, design: .rounded))
//            .foregroundColor(.theme.accent)
//            .frame(maxWidth: .infinity, maxHeight: 50)
//            .padding()
//            .background(color.cornerRadius(15))
//            .padding()
    }
}

struct HomeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HomeButtonView(name: "Home", color: .accentColor, width: 100, height: 100)
    }
}
