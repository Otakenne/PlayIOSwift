//
//  LibraryToggleView.swift
//  PlayIO
//
//  Created by Otakenne on 20/01/2022.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    weak var delegate: LibraryToggleViewDelegate?
    var state: State = .playlist
    
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.getColor(colorHex: "#E2374D")
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistsButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumsButton.frame = CGRect(x: playlistsButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
    }
    
    @objc func didTapPlaylist() {
        state = .playlist
        animate()
        delegate?.libraryToggleViewDidTapPlaylist(self)
    }
    
    @objc func didTapAlbums() {
        state = .album
        animate()
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 10, y: playlistsButton.bottom, width: 80, height: 2)
        case .album:
            indicatorView.frame = CGRect(x: playlistsButton.right + 10, y: playlistsButton.bottom, width: 80, height: 2)
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    
    func update(for state: State) {
        self.state = state
        animate()
    }
}
