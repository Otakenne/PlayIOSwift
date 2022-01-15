//
//  FeaturedPlaylistResponse.swift
//  PlayIO
//
//  Created by Otakenne on 15/01/2022.
//

import Foundation

struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_url: [String : String]?
    let id: String
}
