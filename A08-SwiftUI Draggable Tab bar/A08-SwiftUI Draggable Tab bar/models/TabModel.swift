//
//  TabModel.swift
//  A08-SwiftUI Draggable Tab bar
//
//  Created by Kan Tao on 2024/9/22.
//

import Foundation

struct TabModel : Identifiable {
    var id: Int
    var symbolimage: String
    var rect: CGRect = .zero
}


let defaultOrderTabs:[TabModel] = [
    .init(id: 0, symbolimage: "house.fill"),
    .init(id: 1, symbolimage: "magnifyingglass"),
    .init(id: 2, symbolimage: "bell.fill"),
    .init(id: 3, symbolimage: "person.2.fill"),
    .init(id: 4, symbolimage: "gearshape.fill")
]
