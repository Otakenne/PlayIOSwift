//
//  LibraryViewController.swift
//  PlayIO
//
//  Created by Otakenne on 10/01/2022.
//

import UIKit

class LibraryViewController: UIViewController {
    
    let libraryPlaylistsViewController = LibraryPlaylistsViewController()
    let libraryAlbumsViewController = LibraryAlbumsViewController()
    private let toggleView = LibraryToggleView()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        toggleView.delegate = self
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)
        addChildren()
        updateBarButtons()
    }
    
    private func addChildren() {
        addChild(libraryPlaylistsViewController)
        scrollView.addSubview(libraryPlaylistsViewController.view)
        libraryPlaylistsViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: scrollView.width,
            height: scrollView.width
        )
        libraryPlaylistsViewController.didMove(toParent: self)
                                               
        addChild(libraryAlbumsViewController)
        scrollView.addSubview(libraryAlbumsViewController.view)
        libraryAlbumsViewController.view.frame = CGRect(
            x: view.width,
            y: 0,
            width: scrollView.width,
            height: scrollView.width
        )
        libraryAlbumsViewController.didMove(toParent: self)
    }
    
    private func updateBarButtons() {
        switch toggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(didTapAdd)
            )
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func didTapAdd() {
        libraryPlaylistsViewController.showCreatePlaylistButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top + 55,
            width: view.width,
            height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55
        )
        
        toggleView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: 200,
            height: 55
        )
    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateBarButtons()
        if scrollView.contentOffset.x >= view.width - 100 {
            toggleView.update(for: .album)
        } else {
            toggleView.update(for: .playlist)
        }
    }
}

extension LibraryViewController: LibraryToggleViewDelegate {
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
}
