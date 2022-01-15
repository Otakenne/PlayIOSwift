//
//  ViewController.swift
//  PlayIO
//
//  Created by Otakenne on 08/01/2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(didTapSettings))
        
        fetchData()
    }
    
    private func fetchData() {
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let seed = genres.randomElement() {
                        seeds.insert(seed)
                    }
                }
                
                APICaller.shared.getRecommendation(genres: seeds) { _ in
                    
                }
                break
            case .failure(let _):
                break
            }
        }
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

