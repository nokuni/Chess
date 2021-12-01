//
//  BundleExtension.swift
//  MyVersionOfChess
//
//  Created by Yann Christophe Maertens on 27/11/2021.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ resource: String) -> [T] {
        if let url = url(forResource: resource, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode([T].self, from: data) {
            return decodedData
        }
        return []
    }
}
