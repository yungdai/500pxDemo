//
//  MainResponseObject.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct PagedPhotoReponse: Decodable {
    
    let currentPage: Int
    let totalPages: Int
    let totalItems: Int
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case totalItems = "total_items"
        case photos
    }
}
