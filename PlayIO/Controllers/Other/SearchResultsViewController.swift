//
//  SearchResultsViewController.swift
//  PlayIO
//
//  Created by Otakenne on 10/01/2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    private var sections: [SearchSection] = []
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier
        )
        tableView.register(
            SearchResultDefaultTableViewCell.self,
            forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]) {
        self.sections.removeAll()
        let albums = results.filter {
            switch $0 {
            case .album: return true
            default: return false
            }
        }
        
        self.sections.append(SearchSection(
            title: "Albums",
            results: albums)
        )
        
        let artists = results.filter {
            switch $0 {
            case .artist: return true
            default: return false
            }
        }
        
        self.sections.append(SearchSection(
            title: "Artists",
            results: artists)
        )
    
        let playlists = results.filter {
            switch $0 {
            case .playlist: return true
            default: return false
            }
        }
        
        self.sections.append(SearchSection(
            title: "Playlists",
            results: playlists)
        )
    
        let tracks = results.filter {
            switch $0 {
            case .track: return true
            default: return false
            }
        }
        
        self.sections.append(SearchSection(
            title: "Tracks",
            results: tracks)
        )
        
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        switch result {
        case .album(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(
                with: SearchResultSubtitleTableViewCellViewModel(
                    title: model.name,
                    subtitle: model.artists.first?.name ?? "",
                    imageURL: URL(string: model.images.first?.url ?? "")
                )
            )
            
            return cell
        case .artist(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(
                with: SearchResultDefaultTableViewCellViewModel(
                    title: model.name,
                    imageURL: URL(string: model.images?.first?.url ?? "")
                )
            )
            
            return cell
        case .playlist(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(
                with: SearchResultSubtitleTableViewCellViewModel(
                    title: model.name,
                    subtitle: model.owner.display_name,
                    imageURL: URL(string: model.images.first?.url ?? "")
                )
            )
            
            return cell
        case .track(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(
                with: SearchResultSubtitleTableViewCellViewModel(
                    title: model.name,
                    subtitle: model.artists.first?.name ?? "",
                    imageURL: URL(string: model.album?.images.first?.url ?? "")
                )
            )
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
