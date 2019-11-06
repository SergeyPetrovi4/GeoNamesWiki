//
//  WikiSearchViewController.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import UIKit
import CoreData

class WikiSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params: [String: String] = [
            "q": "Tel Aviv",
            "username": "tingz"
        ]
        
        WebServiceManager.shared.fetch(fromWebService: .geoNames, withParameters: params) { (keyword) in
            
            if keyword == nil {
                return
            }
            
            self.fetchData(byKey: keyword!)
        }
        
    }
    
    func fetchData(byKey: String) {
        if let requestKeyword = CoreDataManager.shared.isContextExists(by: "Tel Aviv") as? Keyword, let geonames = requestKeyword.geonames {
            print(Array(geonames))
        }
    }
}

