//
//  ViewController.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-10.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

class ShowcaseViewController: UIViewController {

	// MARK: - Properties
	fileprivate var showcaseCollectionVC: MasterCollectionViewController?
	
	var showcaseCollectionDataSource: ShowcaseCollectionDataSource!
	var photosViewModel: PhotosViewModel!

	override func viewDidLoad() {
        super.viewDidLoad()

		setupDataSource()
    }
	
	private func setupDataSource() {
		
		showcaseCollectionDataSource.collectionView = showcaseCollectionVC?.collectionView
		showcaseCollectionDataSource.sourceVC = self
	}

	// MARK: Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		// Init the containerView with the showCaseCollectionVC
		if segue.identifier == "photoShowCase" {
			
			showcaseCollectionVC = segue.destination as? MasterCollectionViewController
			
			showcaseCollectionVC?.collectionView.delegate = showcaseCollectionDataSource
			showcaseCollectionVC?.collectionView.dataSource = showcaseCollectionDataSource
			
		}
	}
}



