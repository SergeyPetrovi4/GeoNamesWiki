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
            
            guard let data = data, let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode, error == nil else {
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            let geoNamesResponseModel = try? decoder.decode(GeoNameResponseModel.self, from: data)
                        
            completion(components.queryItems?.first?.value)

        }
        
        session.resume()
    }
}
