//
//  SearchResult.swift
//  PlayIO
//
//  Created by Otakenne on 19/01/2022.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
}
