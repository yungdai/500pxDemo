//
//  HTTPErrorResponse.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

enum HTTPResponseError: Error {
    
    case network
    case decoding
    
    var reason: String {
        
        switch self {
            
        case .network:
            return "There was an error while fetching data"
            
        case .decoding:
            return "There was an error while decoding the data"
        }
    }
}
