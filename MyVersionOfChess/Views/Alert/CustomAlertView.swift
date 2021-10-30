//
//  CustomAlertView.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 17/09/2021.
//

import SwiftUI

struct CustomAlertView: View {
    var alert: AlertModel
    @Binding var isAlertOn: Bool
    var body: some View {
        if isAlertOn {
            ZStack {
                Color.primary.opacity(0.3).ignoresSafeArea()
                VStack(spacing: 20) {
                    
                    if let title = alert.title {
                        Text(title)
                            .fontWeight(.heavy)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(.primary)
                            .padding()
                    }
                    
                    if let message = alert.message {
                        Text(message)
                            .fontWeight(.bold)
                            .font(.system(.title2, design: .rounded))
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                    }
                    
                    HStack {
                        
                        MessageView(message: alert.primaryAction.actionLabel, color: .theme.background)
                            .padding()
                            .background(Color.theme.restart.cornerRadius(15))
                            .onTapGesture {
                                isAlertOn.toggle()
                            }
                        
                        MessageView(message: alert.secondaryAction.actionLabel, color: .theme.background)
                            .padding()
                            .background(Color.theme.newGame.cornerRadius(15))
                            .onTapGesture {
                                alert.secondaryAction.action?()
                                isAlertOn.toggle()
                            }
                        
                    }
                    .padding()
                    
                }
                .background(
                    Color.theme.background
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity)
                )
                .padding(.horizontal)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
        }
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(alert: AlertModel.defaultAlert, isAlertOn: .constant(false))
    }
}

extension AlertModel {
    static let defaultAlert = AlertModel(title: "Title", message: "Message", primaryAction: AlertAction(actionLabel: "Cancel", action: nil), secondaryAction: AlertAction(actionLabel: "Action", action: nil))
    static let warningAlert = AlertModel(title: "Warning!", message: "You have a game in progress, do you really want to start a new one?", primaryAction: AlertAction(actionLabel: "Cancel", action: nil), secondaryAction: AlertAction(actionLabel: "Action", action: nil))
}
