//
//  PlaybackPresenter.swift
//  PlayIO
//
//  Created by Otakenne on 20/01/2022.
//

//import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
//    var player: AVPlayer?
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        
        return nil
    }
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
//        guard let url = URL(string: track.preview_url ?? "") else {
//            return
//        }
//        player = AVPlayer(url: url)
        
        self.track = track
        self.tracks = []
        let playerViewController = PlayerViewController()
        playerViewController.title = track.name
        playerViewController.dataSource = self
        viewController.present(
            UINavigationController(rootViewController: playerViewController),
            animated: true
        )
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        self.track = nil
        self.tracks = tracks
        let playerViewController = PlayerViewController()
        viewController.present(
            UINavigationController(rootViewController: playerViewController),
            animated: true,
            completion: nil
        )
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        currentTrack?.name
    }
    
    var subtitle: String? {
        currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
