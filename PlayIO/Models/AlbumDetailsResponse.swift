//
//  AlbumDetailsResponse.swift
//  PlayIO
//
//  Created by Otakenne on 17/01/2022.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_market: [String]?
    let external_urls: [ String : String ]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
