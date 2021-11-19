//
//  ArrayExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 16/09/2021.
//

import Foundation

extension Array {
    func separate(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    func getColumnsIndices(number: Int) -> [[Int]] {
        var result = [[Int]](repeating: [], count: number)
        for index in result.indices {
            for element in stride(from: index, to: count, by: number) {
                result[index].append(element)
            }
        }
        return result
    }
}
