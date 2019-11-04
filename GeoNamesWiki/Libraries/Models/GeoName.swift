//
//  GeoName.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import UIKit
import CoreData

class GeoName: NSManagedObject, Codable {

    var summary: String
    var wikipediaUrl: String
    var lang: String
    var elevation: Int
    var title: String
    var countryCode: String
    var rank: Int
    var geoNameId: Int
    var lng: Double
    var lat: Double
    var feature: String
}
