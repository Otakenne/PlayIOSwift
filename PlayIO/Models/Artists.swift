//
//  Artists.swift
//  PlayIO
//
//  Created by Otakenne on 10/01/2022.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String : String]
}
