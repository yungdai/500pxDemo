//
//  500pxClient.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

typealias Payload = [[String: Any]]

class APIClient {

    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
	
	/// Fetch a Response object from the server
	func fetchResponse(page: Int, completion: @escaping (Result<PagedPhotoReponse, HTTPResponseError>) -> Void) {
        
        let urlString = "https://api.500px.com/v1/photos?feature=populatar&image_size=4&editors&page=\(page)&consumer_key=\(APIKey)/"
        let url = URL(string: urlString)!

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

                print("Total item: \(totalItems)" )
                // Since we get 20 at a time if there's less we're probably near the end
                // TODO: See notes below this causes a crash right now and will need to be fix
                let hasMore = (currentPage < totalItems) ? true : false
				
                if hasMore == false {
                    print("No more!")
                }
				// process each photo
				photosArray.forEach { photoObject in
                    
                    let name = photoObject["name"] as? String ?? ""
                    
                    // Get user Object
                    var user: User?
                    
                    if let userData = photoObject["user"] as? [String: Any] {
                        
                        let parsedUser = parseUserDataHandler(userData: userData)
                        user = parsedUser
                    }
                    
                    // get the images urls
                    var images = [Image]()

                    if let imagesData = photoObject["images"] as? Payload {
            
                        images = parseImageDataHandler(imageData: imagesData)
                    }
                    
                    photos.append(Photo(image: images, name: name, user: user))
				}
                
                // TODO: Need to fix the hasMore bug, right now when there's no more it will crash, in the meantime it's manually set to true.
				response = PagedPhotoReponse(currentPage: currentPage, totalPages: totalPages, totalItems: totalItems, photos: photos, hasMore: true)
			}
		} catch let error {
			print("Error: \(error.localizedDescription)")
		}
		
		return response
	}
    
    /// Parse the Image Data from a Payload object
    private func parseImageDataHandler(imageData: Payload) -> [Image] {
        
        var images = [Image]()
        
        imageData.forEach { imageObject in

            let format = imageObject["format"] as? String ?? ""
            let size = imageObject["size"] as? Int ?? 1
            let httpsURL = imageObject["https_url"] as? String ?? ""
            let url = imageObject["url"] as? String ?? ""
            
            images.append(Image(format: format, size: size, httpsUrl: URL(string: httpsURL), url: URL(string: url)))
        }
        return images
    }
    
    private func parseUserDataHandler(userData: [String : Any]) -> User {
        
        let id = userData["id"] as? Int ?? 0
        let firstName = userData["firstname"] as? String ?? ""
        let lastName = userData["lastname"] as? String ?? ""
        let fullName = userData["fullname"] as? String ?? ""
        let userPicURL = URL(string: userData["userpic_url"] as? String ?? "")
        let coverURL = URL(string: userData["cover_url"] as? String ?? "")
    
        var avatars: Avatars?
        
        if let avatarsURLS = userData["avatars"] as? [String: Any] {
 
            let tinyData = avatarsURLS["tiny"] as? [String: String] ?? [:]
            let smallData = avatarsURLS["small"] as? [String: String] ?? [:]
            let largeData = avatarsURLS["large"] as? [String: String] ?? [:]
            let defaultData = avatarsURLS["default"] as? [String: String] ?? [:]
            
            let tiny = URL(string: tinyData["https"] ?? "")
            let small = URL(string: smallData["https"] ?? "")
            let large = URL(string: largeData["https"] ?? "")
            let defaultURL = URL(string: defaultData["https"] ?? "")
            
            avatars = Avatars(tiny: tiny, small: small, large: large, defaultURL: defaultURL)
        }
        
        return User(id: id, firstName: firstName, lastName: lastName, fullName: fullName, userPicURL: userPicURL, coverURL: coverURL, avatars: avatars)
    }
}

