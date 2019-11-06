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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params: [String: String] = [
            "q": "Tel Aviv",
            "username": "tingz"
        ]
        
        if !self.fetchData(byKey: params["q"]!) {
            self.requestData(withParams: params)
        }
    }
    
    // MARK: - Private
    
    // Fetch local data if exist
    private func fetchData(byKey key: String) -> Bool {
        
        if let requestKeyword = CoreDataManager.shared.isContextExists(by: key) as? Keyword, let geonames = requestKeyword.geonames {

            self.geonames = Array(geonames)
            self.tableView.reloadData()
            return true
        }
        
        return false
    }
    
    // Fetch remote data if local does not exist
    private func requestData(withParams params: [String : String]) {
        
        WebServiceManager.shared.fetch(fromWebService: .geoNames, withParameters: params) { (keyword) in
            
            DispatchQueue.main.async {
                
                if keyword == nil {
                    
                    print("Error saving data to DB")
                    return
                }
                
                self.fetchData(byKey: keyword!)
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

