//
//  PromotionAlertView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import SwiftUI

struct PromotionAlertView: View {
    var promotionsPieces: [Piece]
    var choosePromotionPiece: ((Piece) -> Void)?
    var isPromotionAlertActive: Bool
    var body: some View {
        if isPromotionAlertActive {
            ZStack {
                Color.white.opacity(0.01).ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .padding(.horizontal)
                VStack {
                    Text("Choose your promotion piece")
                        .font(.system(size: 25, weight: .heavy, design: .rounded))
                        .foregroundColor(.black)
                    HStack(spacing: 40) {
                        ForEach(promotionsPieces, id: \.self) { piece in
                            if let image = piece.image {
                                Button(action: {
                                    choosePromotionPiece?(piece)
                                }) {
                                    Image(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct PromotionAlertView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionAlertView(promotionsPieces: [], isPromotionAlertActive: false)
    }
}
