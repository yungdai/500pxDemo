//
//  500pxClient.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

class APIClient {

    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
	
	/// Fetch a Response object from the server
	func fetchResponse(page: Int, completion: @escaping (Result<PagedPhotoReponse, HTTPResponseError>) -> Void) {

        
        let urlString = "https://api.500px.com/v1/photos?feature=editors&page=\(page)&consumer_key=\(APIKey)/"
        let url = URL(string: urlString)!
        
        print("fetching page: \(page)")
        
        let urlRequest = URLRequest(url: url)

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
			let totalPages = jsonData["total_pages"] as? Int,
			let totalItems = jsonData["total_items"] as? Int,
			let photosArray = jsonData["photos"] as? Payload {
				
				var photos = [Photo]()
				
				// process each photo
				photosArray.forEach { objects in
                    
                    let name = objects["name"] as? String ?? ""
                    
                    var images = [Image]()
                    
                    if let imagesData = objects["images"] as? Payload {
            
                        images = parseImageData(imageData: imagesData)
                    }
                    
                    photos.append(Photo(image: images, name: name))
				}

				// TODO: Figure out hasMore pages
				response = PagedPhotoReponse(currentPage: currentPage, totalPages: totalPages, totalItems: totalItems, photos: photos, hasMore: false)
			}
		} catch let error {
			print("Error: \(error.localizedDescription)")
		}
		
		return response
	}
    
    
    private func parseImageData(imageData: Payload) -> [Image] {
        
        var images = [Image]()
        
        imageData.forEach { object in

            let format = object["format"] as? String ?? ""
            let size = object["size"] as? Int ?? 1
            let httpsURL = object["https_url"] as? String ?? ""
            let url = object["url"] as? String ?? ""
            
            images.append(Image(format: format, size: size, httpsUrl: URL(string: httpsURL), url: URL(string: url)))
        }
        return images
    }
}

