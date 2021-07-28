//
//  photoStruct.swift
//  getPhotosApp
//
//  Created by Кирилл Любарских  on 25.07.2021.
//

import Foundation

struct photoStruct: Decodable {
    var response: photoInfo?
    
}
struct photoInfo: Decodable {
    var count: Int
    var items: [Items]
}

struct Items: Decodable {
    var date: Int
    var sizes: [Sizes]
    
}
struct Sizes: Decodable {
    var url: String
    var type: String
}
