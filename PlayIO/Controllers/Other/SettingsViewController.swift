//
//  SettingsViewController.swift
//  PlayIO
//
//  Created by Otakenne on 10/01/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var sections = [Section]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureModels()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        sections.append(Section(title: "Profile", options: [Options(title: "View Your Profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Options(title: "Sign Out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }

    private func viewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutTapped() {
        let alert = UIAlertController(
            title: "Sign out",
            message: "Are you sure you wish to sign out?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign out", style: .destructive) { _ in
            AuthManager.shared.signOut { [weak self] signedOut in
                DispatchQueue.main.async {
                    let navVC = UINavigationController(rootViewController: WelcomeViewController())
                    navVC.navigationBar.prefersLargeTitles = true
                    navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true, completion: {
                        self?.navigationController?.popToRootViewController(animated: false)
                    })
                }
            }
        })
        
        present(alert, animated: false, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let option = sections[indexPath.section].options[indexPath.row]
        cell.textLabel?.text = option.title
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let option = sections[indexPath.section].options[indexPath.row]
        option.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.title
    }
}
