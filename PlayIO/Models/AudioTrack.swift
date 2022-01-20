//
//  AudioTrack.swift
//  PlayIO
//
//  Created by Otakenne on 10/01/2022.
//

import Foundation

struct AudioTrack: Codable {
    let album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disk_number: Int?
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String : String]
    let id: String
    let name: String
    let popularity: Int?
    let preview_url: String?
}
