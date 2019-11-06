//
//  GeoName.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import UIKit
import CoreData

@objc(GeoName)
class GeoName: NSManagedObject, Codable {

    @NSManaged public var countryCode: String?
    @NSManaged public var elevation: Int
    @NSManaged public var feature: String?
    @NSManaged public var geoNameId: Int
    @NSManaged public var lang: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var rank: Int
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var wikipediaUrl: String?
    
    enum apiKey: String, CodingKey {
        case countryCode
        case elevation
        case feature
        case geoNameId
        case lang
        case lat
        case lng
        case rank
        case summary
        case title
        case wikipediaUrl
    }
    
    @nonobjc public class func request() -> NSFetchRequest<GeoName> {
        return NSFetchRequest<GeoName>(entityName: "GeoName")
    }
    
    // MARK: - Decodable
    
    public required convenience init(from decoder: Decoder) throws {
            
        guard let contextUserInfoKey = CodingUserInfoKey.context else {
            fatalError("cannot find context key")
        }
         
        guard let manageObjContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("Cannot Retrieve NSManagedObjectContext context")
        }
        
        guard let manageObjGeoname = NSEntityDescription.entity(forEntityName: "GeoName", in: manageObjContext) else {
            fatalError("Cannot Retrieve Entity")
        }
        
        self.init(entity: manageObjGeoname, insertInto: manageObjContext)
        
        let container = try decoder.container(keyedBy: apiKey.self)
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.elevation = try container.decodeIfPresent(Int.self, forKey: .elevation) ?? 0
        self.feature = try container.decodeIfPresent(String.self, forKey: .feature)
        self.geoNameId = try container.decodeIfPresent(Int.self, forKey: .geoNameId) ?? 0
        self.lang = try container.decodeIfPresent(String.self, forKey: .lang)
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0
        self.lng = try container.decodeIfPresent(Double.self, forKey: .lng) ?? 0
        self.rank = try container.decodeIfPresent(Int.self, forKey: .rank) ?? 0
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.wikipediaUrl = try container.decodeIfPresent(String.self, forKey: .wikipediaUrl)
    }
    
    public func encode(to encoder: Encoder) throws {
        print()
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
