//
//  NewReleasesResponse.swift
//  PlayIO
//
//  Created by Otakenne on 15/01/2022.
//

import Foundation

struct NewReleaseResponse: Codable {
    let albums: AlbumsRsponse
}

struct AlbumsRsponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let date: String?
    let total_tracks: Int
    let artists: [Artist]
}
