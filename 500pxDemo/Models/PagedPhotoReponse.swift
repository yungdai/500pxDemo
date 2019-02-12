//
//  MainResponseObject.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

struct PagedPhotoReponse {
    
    let page: Int
    let totalPages: Int
    let totalItems: Int
	let hasMore: Bool
    let photos: [Photo]
	
	public init(currentPage: Int = 0, totalPages: Int = 0, totalItems: Int = 0, photos: [Photo] = [], hasMore: Bool = true) {
		
		self.page = currentPage
		self.totalPages = totalPages
		self.totalItems = totalItems
		self.photos = photos
		self.hasMore = hasMore
	}
}
