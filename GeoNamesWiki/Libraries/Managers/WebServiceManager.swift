//
//  WebServiceManager.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 04/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import Foundation

class WebServiceManager {
    
    enum WikiWebServiceAPI: String {
        case geoNames = "http://api.geonames.org/wikipediaSearchJSON"
    }
    
    static let shared = WebServiceManager()
    private init() {}
    
    func fetch(fromWebService service: WikiWebServiceAPI, withParameters parameters: [String: String], completion: @escaping ((String?) -> Void)) {
        
        guard var components = URLComponents(string: service.rawValue) else {
            return
        }
        
        components.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: " ", with: "%20")
        
        let request = URLRequest(url: components.url!)
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let responseData = data, let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode, error == nil else {
                completion(nil)
                return
            }
            
            do {
                
                var json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any]
                json?["key"] = parameters["q"]
                
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = CoreDataManager.shared.context
                let keyword = try decoder.decode(Keyword.self, withJSONObject: json as Any)
                CoreDataManager.shared.saveContext()
                completion(parameters["q"])
                
                
            } catch let error {
                print(error.localizedDescription)
            }
            
//            let decoder = JSONDecoder()
//            decoder.userInfo[CodingUserInfoKey.context!] = CoreDataManager.shared.context
//
//            do {
//                let keyword = try? decoder.decode(Keyword.self, from: responseData)
//                CoreDataManager.shared.saveContext()
//                completion(parameters["q"])
//            }
        }
        
        session.resume()
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}
