//
//  ShowCaseCollectionDataSource.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-11.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

class ShowcaseCollectionDataSource: NSObject {
	
	private enum CellIdentifiers {
		static let showCaseCell = "showCaseCell"
	}

	var photosViewModel: PhotosViewModel!
	
	override init() {
		super.init()
		
		let request = ResponseRequest.from(site: site)
		photosViewModel = PhotosViewModel(request: request, delegate: self)
		
		site = ""
	}
	
	weak var sourceVC: UIViewController?
	weak var collectionView: UICollectionView?
	var site: String!
}

extension ShowcaseCollectionDataSource: UICollectionViewDelegate {}

extension ShowcaseCollectionDataSource: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		guard let totalCount = photosViewModel?.totalCount else { return 0 }
		
		return totalCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.showCaseCell, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
		
		// if no photos is received for the current cell, configure for empty cell
		if isLoadingCell(for: indexPath) {
			cell.configure(with: .none)
		} else {
			
			// pass the photo to be configured at the cell to be processed
			cell.configure(with: photosViewModel.photo(at: indexPath.item))
		}

		return cell
	}
}

extension ShowcaseCollectionDataSource: PhotosViewModelDelegate {
	
	func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
		
		guard let newIndexPathsToReload = newIndexPathsToReload else {
			
			self.collectionView?.reloadData()
			
			// TODO:
			// if the indexPath is hidden need to find a way to handle an empty collecdtion
			return
		}
		
		// find visible cells that need reloading and tell the collectionView ONLY reload those items
		let indexPathsToReload = visibleIndexPathToReload(intersecting: newIndexPathsToReload)
		
		self.collectionView?.reloadItems(at: indexPathsToReload)
	}
	
	func onFetchFailed(with reason: String) {
		
		// Show a complete alert for now on an error
		// TODO: Might want to make it more generic later
		let title = "Warning"
		let action = UIAlertAction(title: "OK", style: .default)
		
		let alertController = UIAlertController(title: title, message: reason, preferredStyle: .alert)
		
		alertController.addAction(action)
		self.sourceVC?.present(alertController, animated: true, completion: nil)
	}
}

private extension ShowcaseCollectionDataSource {
	
	/// Use to determine if the cell at the indexPath is beyond the count of photos you have recieved so far.
	func isLoadingCell(for indexPath: IndexPath) -> Bool {
		
		return indexPath.row >= photosViewModel.currentCount
	}
	
	/// Use to calculate the intersection of the indexPaths pass in with the current visible ones.  Use to avoid refreshing cells that are not currently visible on the screen
	func visibleIndexPathToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
		
		let indexPathsForVisibleRows = self.collectionView?.indexPathsForVisibleItems ?? []
		
		// create an Set of indexPaths by intersecting the indexPaths
		let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
		
		return Array(indexPathsIntersection)
	}
}
