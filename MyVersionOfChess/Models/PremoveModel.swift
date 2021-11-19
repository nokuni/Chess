//
//  PremoveModel.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 18/11/2021.
//

import SwiftUI

struct Premove {
    var coloredOverlayMatchIndex: Int? = nil
    var coloredOverlayPieceIndex: Int? = nil
    var coloredOverlay: [Int] = []
    
    mutating func emptyOverlay() { coloredOverlay.removeAll() }
    mutating func addPremoves(from movements: ((Piece, Int) -> [Int]), piece: Piece, index: Int) {
        for moveIndex in movements(piece, index) { coloredOverlay.append(moveIndex) }
    }
    mutating func setOverlayPieceSquare(at index: Int) { coloredOverlayPieceIndex = index }
    mutating func setOverlayMatchingSquare(at index: Int) { coloredOverlayMatchIndex = index }
    mutating func resetOverlay() {
        coloredOverlayPieceIndex = nil
        coloredOverlayMatchIndex = nil
    }
}
