//
//  ViewController.swift
//  QuNews
//
//  Created by Никита Ничепорук on 9/28/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import UIKit
import SafariServices

final class MainViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var searchController = UISearchController(searchResultsController: nil)
    private var articles = [Article]()
    private var newsSource = [NewsCellSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatedCell()
    }
   
    @IBAction private func refresh(_ sender: Any) {
        fetchData()
    }
    
    private func animatedCell() {
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.width
        var delay: Double = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableViewHeight, y: 0)
            UIView.animate(withDuration: 2.0,
                           delay: delay * 0.2,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delay += 1
        }
    }
    
    private func fetchData() {
        NetworkManager.shared.getNews { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                self.articles = articles
                self.newsSource = articles.compactMap({
                    NewsCellSource(title: $0.title,
                                   description: $0.description ?? "",
                                   author: $0.author ?? "",
                                   imageURL: URL(string: $0.urlToImage ?? " "))
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        cell.showMoreClicked = { [weak self] in
            guard let self = self else { return }
            let article = self.articles[indexPath.row]
            
            guard let url = URL(string: article.url ?? " ") else { return }
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true, completion: nil)
        }
        cell.setup(with: newsSource[indexPath.row])
        return cell
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        NetworkManager.shared.search(with: text) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                self.articles = articles
                self.newsSource = articles.compactMap({
                    NewsCellSource(title: $0.title,
                                   description: $0.description ?? "No description",
                                   author: $0.author ?? "No author",
                                   imageURL: URL(string: $0.urlToImage ?? " "))
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchController.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

