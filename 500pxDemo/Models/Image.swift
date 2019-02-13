//
//  Images.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-12.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct Image {
    
    let format: String
    let size: Int
    let httpsUrl: URL?
    let url: URL?
    
    // Not sure if format will change from jpeg but it's a possibility
    public init(format: String = "jpeg", size: Int = 2, httpsUrl: URL? = nil, url: URL? = nil) {
        
        self.format = format
        self.size = size
        self.httpsUrl = httpsUrl
        self.url = url
    }
}
