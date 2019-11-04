//
//  Keyword.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import UIKit
import CoreData

class Keyword: NSManagedObject {

    @NSManaged var keyword: String?
    @NSManaged var geonames: [GeoName]?
}
