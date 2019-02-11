//
//  500pxClient.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

class APIClient {
    
    private lazy var baseURL: URL = {
        return URL(string: "https://api.500px.com/v1/photos?feature=editors&page=2&consumer_key=")!
    }()
    
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
	
	/// Fetch a Response object from the server
	func fetchResponse(with request: ResponseRequest, page: Int, completion: @escaping (Result<PagedPhotoReponse, HTTPResponseError>) -> Void) {
		
		// create the url request
		let urlRequest = URLRequest(url: baseURL.appendingPathComponent(APIKey))
		
		// TODO: Add parameters in case we want to pagenate
		
		session.dataTask(with: urlRequest) { data, response, error in
			
			// validate response
			guard let httpResponse = response as? HTTPURLResponse, httpResponse.isSuccessfullStatusCode, let data = data else {
				completion(Result.error(HTTPResponseError.decoding))
				return
			}
			
			// validate the JSON
			guard let jsonResponse = self.parseResponseJSON(data: data) else {
				completion(Result.error(HTTPResponseError.decoding))
				return
			}
			
			completion(Result.success(jsonResponse))

		}.resume()
	}
	
	private func parseResponseJSON(data: Data) -> PagedPhotoReponse? {
		
		var response = PagedPhotoReponse()
		
		do {
			if let jsonData = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers]) as? [String: Any],
			let currentPage = jsonData["current_page"] as? Int,
			let totalPages = jsonData["total_pagess"] as? Int,
			let totalItems = jsonData["total_items"] as? Int,
			let photosArray = jsonData["photos"] as? Payload {
				
				var photos = [Photo]()
				
				// process each photo
				photosArray.forEach { objects in
					
					if let imageURLArray = objects["image_url"] as? String {
						let urlArray = imageURLArray.compactMap {
							URL(string: String(describing: $0))
						}
						
						photos.append(Photo(imageURL: urlArray))
					}
				}

				// TODO: Figure out hasMore pages
				response = PagedPhotoReponse(currentPage: currentPage, totalPages: totalPages, totalItems: totalItems, photos: photos, hasMore: false)
			}
		} catch let error {
			print("Error: \(error.localizedDescription)")
		}
		
		return response
	}
}


//let parameterArray = [String(format: "%@=%@", "x_auth_mode", "client_auth"), String(format: "%@=%@", "x_auth_password", )]
