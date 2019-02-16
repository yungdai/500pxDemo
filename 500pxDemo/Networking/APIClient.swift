//
//  500pxClient.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

typealias Payload = [[String: Any]]

final class APIClient {

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
        
        do {
            
            let jsonDecoder = JSONDecoder()
            let pagedPhotoReponse = try jsonDecoder.decode(PagedPhotoReponse.self, from: data)
            
            return pagedPhotoReponse
            
        } catch let error {
            print(error)
        }
        
        return nil
    }
}

