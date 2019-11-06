//
//  WikiSearchViewController.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import UIKit
import RappleProgressHUD
import SafariServices

class WikiSearchViewController: UITableViewController {
    
    private var geonames = [GeoName]()
    private var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        
        self.searchController.searchBar.placeholder = "City name"
        self.searchController.searchBar.clipsToBounds = true
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
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
    
    // Fetch remote data if local search key does not exist
    private func requestData(withParams params: [String : String]) {
        
        RappleActivityIndicatorView.startAnimating()
        WebServiceManager.shared.fetch(fromWebService: .geoNames, withParameters: params) { (keyword) in
            
            DispatchQueue.main.async {
                RappleActivityIndicatorView.stopAnimation()
                
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
            
            
            guard let geoname = self.geonames.filter({ $0.geoNameId == geonameId }).first,
                let url = geoname.wikipediaUrl else {
                print("Can`t fint Geoname with more info")
                return
            }
            
            let svc = SFSafariViewController(url: URL(string: "https://" + url)!)
            svc.modalPresentationStyle = .pageSheet
            self.navigationController?.present(svc, animated: true, completion: nil)
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
        
        // Checking cache by search key.
        // Parameter 'maxRows' = 10 by default
        
        if !self.fetchData(byKey: key.lowercased()) {
            
            let params: [String: String] = [
                "q": key.lowercased(),
                "username": "tingz"
            ]
                
            self.requestData(withParams: params)
        }
    }
}

