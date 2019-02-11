//
//  MainResponseObject.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct Response {
    
    let currentPage: Int
    let totalPages: Int
    let totalItems: Int
    let photos: [Photo]?
	
	public init(currentPage: Int = 0, totalPages: Int = 0, totalItems: Int = 0, photos: [Photo]? = nil) {
		
		self.currentPage = currentPage
		self.totalPages = totalPages
		self.totalItems = totalItems
		self.photos = photos
	}
}
