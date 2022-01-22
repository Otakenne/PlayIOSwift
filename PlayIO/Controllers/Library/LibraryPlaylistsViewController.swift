//
//  LibraryPlaylistsViewController.swift
//  PlayIO
//
//  Created by Otakenne on 20/01/2022.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    var playlists: [Playlist] = []
    private let noPlaylistView = ActionLabelView()
    
    var selectionHandler: ((Playlist) -> ())?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
             forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier
        )
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(noPlaylistView)
        view.addSubview(tableView)
        noPlaylistView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        setupNoPlaylistView()
        fetchData()
        
        guard selectionHandler == nil else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(didTapClose)
            )
            return
        }
    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistView.frame = CGRect(x: 0, y: 0, width: view.width - 60, height: 150)
        noPlaylistView.center = view.center
        tableView.frame = view.bounds
    }
    
    func setupNoPlaylistView() {
        noPlaylistView.configure(
            with: ActionLabelViewViewModel(
                text: "You haven't created any playlists yet. Click the Create button to create one",
                actionTitle: "Create"
            )
        )
    }
    
    func fetchData() {
        APICaller.shared.getCurrentUserPlaylist { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func updateUI() {
        if playlists.isEmpty {
            noPlaylistView.isHidden = false
            tableView.isHidden = true
        } else {
            noPlaylistView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    func showCreatePlaylistButton() {
        let alert = UIAlertController(
            title: "New Playlists",
            message: "Enter playlist name.",
            preferredStyle: .alert
        )
        
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default) { _ in
            guard let field = alert.textFields?.first,
            let text = field.text,
            !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            
            APICaller.shared.createPlaylist(with: text) { [ weak self ] success in
                if success {
                    self?.fetchData()
                } else {
                    DispatchQueue.main.async {
                        let newAlert = UIAlertController(
                            title: "Error creating playlist",
                            message: "Insufficient client scope",
                            preferredStyle: .alert
                        )
                        
                        newAlert.addAction(
                            UIAlertAction(
                                title: "OK",
                                style: .cancel
                            )
                        )
                        
                        self?.present(
                            newAlert,
                            animated: true,
                            completion: nil
                        )
                    }
                }
            }
        })
        
        present(alert, animated: true)
    }
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionLabelView: ActionLabelView) {
        showCreatePlaylistButton()
    }
}

extension LibraryPlaylistsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier,
            for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        
        cell.configure(
            with: SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? "")
            )
        )
        
        return cell
    }
}

extension LibraryPlaylistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let playlistViewController = PlaylistViewController(playlist: playlist)
        playlistViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(playlistViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
