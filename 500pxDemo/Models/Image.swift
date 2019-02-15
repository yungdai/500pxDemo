//
//  Images.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-12.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct Image: Decodable {
    
    let format: String
    let size: Int
    let urlString: String
    let httpsURLString: String
    
    enum CodingKeys: String, CodingKey {
        
        case format, size
        case urlString = "url"
        case httpsURLString = "https_url"
    }
}
