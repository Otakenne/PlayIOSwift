//
//  Playlist.swift
//  PlayIO
//
//  Created by Otakenne on 10/01/2022.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_url: [String : String]?
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
