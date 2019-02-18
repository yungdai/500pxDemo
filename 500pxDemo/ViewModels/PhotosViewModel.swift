//
//  PhotosViewModel.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-11.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

protocol PhotosViewModelDelegate: class {
    var collectionView: UICollectionView? { get set }
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
    private var previousCount: Int?
	
	let apiClient = APIClient()
	
	init(delegate: PhotosViewModelDelegate) {
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
		
		apiClient.fetchResponse(page: currentPage) { result in
			
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
                    
                    // capture the total count on the first get of data
                    if self.previousCount == nil {
                        self.previousCount = self.totalCount
                    }
                    
                    // TODO:? wind out what is done first or last when calculating the szing.
					self.photos.append(contentsOf: response.photos)

					if response.currentPage > 1 {
                        
                        // if the data size changes we should adjust the colllectionView data source size accordingly
                        if let previousCount = self.previousCount,
                            previousCount != self.totalCount {
                            
                            print("totalCount: \(self.totalCount), previousCount:\(previousCount)")
                            self.adjustDataSourceSize(response: response)
                            self.reloadNewIndexPathsFrom(response: response)
                        } else {
                            
                            self.reloadNewIndexPathsFrom(response: response)                        }
					} else {
                        self.delegate?.onFetchCompleted(with: .none)
					}
				}
			}
		}
	}
    
    private func reloadNewIndexPathsFrom(response: PagedPhotoReponse) {

        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.photos)
        self.delegate?.onFetchCompleted(with: indexPathsToReload)
    }
	
	/// Calculate the indexPaths for the last page of the photos recieved by the API.  Use to refresh only the changed content, instead of reloading the show collection.
	private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
		
		let startIndex = photos.count - newPhotos.count
		let endIndex = startIndex + newPhotos.count
		
		return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
	}
    
    private func adjustDataSourceSize(response: PagedPhotoReponse) {

        guard let previousCount = previousCount else { return }
        (previousCount > totalCount) ? removeIndexPaths(response: response) : insertIndexPaths(response: response)
        
        print("adjusted sizing")
    }
    
    private func removeIndexPaths(response: PagedPhotoReponse) {
        
        guard let collectionView = self.delegate?.collectionView else {
            print("can't delete no collectionView")
            return
        }
        
        guard let previousCount = previousCount else { return }

        // if there are less objects we need to remove them by starting at the how much less we need to
        let startIndex = previousCount - (previousCount - totalCount)
        let endIndex = previousCount - 1
        let indexRange = Range(startIndex...endIndex)
        
        let indexPaths = indexRange.map { IndexPath(item: $0, section: 0) }
        
        self.previousCount = self.totalCount
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: indexPaths)
        }) { _ in

            self.reloadNewIndexPathsFrom(response: response)
        }
    }
    
    private func insertIndexPaths(response: PagedPhotoReponse) {
        
        guard let collectionView = self.delegate?.collectionView else {
            
            print("can't insert no collectionView")
            return
        }
        
        guard let previousCount = previousCount else { return }
        
        // if there are more we need to add more indexPaths to the data source
        let startIndex = collectionView.numberOfItems(inSection: 0)
        
        // get the difference
        let difference = (totalCount - previousCount) - 1
        // create the endIndexfrom the differenece
        let endIndex = startIndex + difference
        let indexRange = Range(startIndex...endIndex)
        let indexPaths = indexRange.map { IndexPath(item: $0, section: 0) }

        self.previousCount = self.totalCount
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
        }, completion: nil)
    }
}
