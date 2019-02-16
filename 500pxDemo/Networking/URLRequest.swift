//
//  URLRequest.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

extension URLRequest {
    
    /// Use to encode a URL with Parameters returned from the API
    func encode(with parameters: Parameters?) -> URLRequest {
    
        guard let parameters = parameters else { return self }
        
        var encodedURLRequest = self
        
        if let url = self.url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
            
            var newURLComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            
            newURLComponents.queryItems = queryItems
            encodedURLRequest.url = newURLComponents.url
            return encodedURLRequest
        } else {
            
            return self
        }
    }

}
