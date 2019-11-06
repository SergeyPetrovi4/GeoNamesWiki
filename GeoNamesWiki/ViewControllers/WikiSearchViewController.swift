//
//  WikiSearchViewController.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import UIKit

class WikiSearchViewController: UITableViewController {
    
    private var geonames = [GeoName]()
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchActivityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        
        self.searchController.searchBar.placeholder = "City name"
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
        
        self.searchActivityIndicator.center = self.view.center
        self.searchActivityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.searchActivityIndicator)
    }
    
    // Fetch local data if exist
    private func fetchData(byKey key: String) -> Bool {
        
        if let requestKeyword = CoreDataManager.shared.isContextExists(by: key) as? Keyword, let geonames = requestKeyword.geonames {

            self.geonames = Array(geonames).sorted(by: { $0.rank < $1.rank })
            self.tableView.reloadData()
            return true
        }
        
        return false
    }
    
    // Fetch remote data if local does not exist
    private func requestData(withParams params: [String : String]) {
        
        self.searchActivityIndicator.startAnimating()
        WebServiceManager.shared.fetch(fromWebService: .geoNames, withParameters: params) { (keyword) in
            
            DispatchQueue.main.async {
                
                self.searchActivityIndicator.stopAnimating()
                if keyword == nil {
                    
                    print("Error saving data to DB")
                    return
                }
                
                _ = self.fetchData(byKey: keyword!)
            }
            
        }
    }
}

extension WikiSearchViewController {
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.geonames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GeonameTableViewCell.self), for: indexPath) as! GeonameTableViewCell
        cell.configure(withGeoname: self.geonames[indexPath.row]) { (geonameId) in
            print(geonameId)
        }
        
        return cell
    }
}

extension WikiSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let key = searchBar.text, !key.isEmpty else {
            return
        }
        
        self.searchController.isActive = false
        
        // Checking cache by search key
        if !self.fetchData(byKey: key) {
            
            let params: [String: String] = [
                "q": key,
                "username": "tingz"
            ]
                
            self.requestData(withParams: params)
        }
    }
}

