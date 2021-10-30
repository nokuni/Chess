//
//  IntExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import Foundation

extension Int {
    var isEven: Bool {
        self.isMultiple(of: 2)
    }
    var isOdd: Bool {
        !self.isMultiple(of: 2)
    }
}
