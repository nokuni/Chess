//
//  AlertModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 17/09/2021.
//

import SwiftUI

struct AlertModel {
    var title: String?
    var message: String?
    var primaryAction: AlertAction
    var secondaryAction: AlertAction
}

struct AlertAction {
    var actionLabel: String
    var action: (() -> Void)?
}
