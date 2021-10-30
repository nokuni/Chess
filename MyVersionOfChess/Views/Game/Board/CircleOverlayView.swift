//
//  CircleOverlayView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct CircleOverlayView: View {
    var selectedIndex: Int?
    var index: Int
    var body: some View {
        if selectedIndex != nil && selectedIndex == index {
            Circle()
                .foregroundColor(.black)
                .frame(width: 100, height: 100)
                .opacity(0.1)
        }
    }
}

struct CircleOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        CircleOverlayView(index: 0)
    }
}
