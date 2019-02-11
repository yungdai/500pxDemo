//
//  PhotosViewModel.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-11.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import Foundation

protocol PhotosViewModelDelegate: class {
	func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
	func onFetchFailed(with reason: String)
}

final class PhotosViewModel {
	
	// MARK: - Properties
	private weak var delegate: PhotosViewModelDelegate?
	
	private var photos: [Photo] = []
	private(set) var currentPage = 1
	private(set) var totalCount = 0
	private var isFetchInProgress = false
	
	let apiClient = APIClient()
	let request: ResponseRequest
	
	init(request: ResponseRequest, delegate: PhotosViewModelDelegate) {
		
		self.request = request
		self.delegate = delegate
	}
	
	var currentCount: Int {
		return photos.count
	}
	
	// MARK: Helper Methods
	func photo(at index: Int) -> Photo {
		return photos[index]
	}

	func fetchPhotos() {
		
		// ensure that nothing is in progress
		guard !isFetchInProgress else { return }
		
		// we are now fetching
		isFetchInProgress = true
		
		apiClient.fetchResponse(with: request, page: currentPage) { result in
			
			switch result {
				
			case .error(let error):
				DispatchQueue.main.async {
					
					// stop fetching
					self.isFetchInProgress = false
					self.delegate?.onFetchFailed(with: error.reason)
				}
				print("Error: \(error.localizedDescription)")
				
			// append new items to the photos list and information the delegate that there's data available
			case .success(let response):
				
				DispatchQueue.main.async {
					
					// incriment page number to retrieve.  The retrieval mechanism will continue to until we've received the full list of photos
					self.currentPage += 1
					self.isFetchInProgress = false
					
					// store total count of photos available on the server.  This is used to determine if we need to request new pages, and store the newly returned photos
					self.totalCount = response.totalItems
					self.photos.append(contentsOf: response.photos)
					
					if response.page > 1 {
						
						let indexPathsToReload = self.calculateIndexPathsToReload(from: response.photos)
						self.delegate?.onFetchCompleted(with: indexPathsToReload)
					} else {
						self.delegate?.onFetchCompleted(with: .none)
					}
					
				}
			}
		}
	}
	
	/// Calculate the indexPaths for the last page of the photos recieved by the API.  Use to refresh only the changed content, instead of reloading the show collection.
	private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
		
		let startIndex = photos.count - newPhotos.count
		let endIndex = startIndex + newPhotos.count
		
		return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
	}
}
