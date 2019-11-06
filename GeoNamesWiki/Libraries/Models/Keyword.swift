//
//  Keyword.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import UIKit
import CoreData

@objc(Keyword)
public class Keyword: NSManagedObject, Decodable {

    @NSManaged var key: String?
    @NSManaged var geonames: Set<GeoName>?
    
    enum apiKey: String, CodingKey {
        case key
        case geonames
    }
    
    @nonobjc public class func request() -> NSFetchRequest<Keyword> {
        return NSFetchRequest<Keyword>(entityName: "Keyword")
    }
    
    // MARK: - Decodable
    
    public required convenience init(from decoder: Decoder) throws {
        
        guard let codableContext = CodingUserInfoKey.context,
            let manageObjContext = decoder.userInfo[codableContext] as? NSManagedObjectContext,
            let manageObjKeyword = NSEntityDescription.entity(forEntityName: "Keyword", in: manageObjContext) else {
                fatalError("failed")
        }
        
        self.init(entity: manageObjKeyword, insertInto: manageObjContext)
        
        let container = try decoder.container(keyedBy: apiKey.self)
        self.key = try container.decode(String.self, forKey: .key)
        self.geonames = try container.decode(Set<GeoName>.self, forKey: .geonames)
        
    }    
}

// MARK: Generated accessors for geonames
extension Keyword {

    @objc(addGeonamesObject:)
    @NSManaged func addToGeonames(_ value: GeoName)
    
    @objc(setKeyObject:)
    @NSManaged func setKeyObject(_ value: String)
}
