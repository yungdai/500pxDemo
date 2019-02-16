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
	
	var showcaseCollectionDataSource: ShowcaseCollectionDataSource?

    
    // TODO: Possibly remove it the viewDidLoad() Delegate function recompletely
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        showcaseCollectionVC?.collectionView.delegate = showcaseCollectionDataSource
////        showcaseCollectionVC?.collectionView.dataSource = showcaseCollectionDataSource
////        showcaseCollectionVC?.collectionView.prefetchDataSource = showcaseCollectionDataSource
//
//    }

	// MARK: Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		// Init the containerView with the showCaseCollectionVC
		if segue.identifier == "photoShowCase" {
			
			showcaseCollectionVC = segue.destination as? MasterCollectionViewController

            guard let collectionView = showcaseCollectionVC?.collectionView else {
                print("Nope not collection view yet")
                return
            }

			showcaseCollectionDataSource = ShowcaseCollectionDataSource(sourceVC: self, collectionView: collectionView)
            showcaseCollectionVC?.collectionView.delegate = showcaseCollectionDataSource
            showcaseCollectionVC?.collectionView.dataSource = showcaseCollectionDataSource
            showcaseCollectionVC?.collectionView.prefetchDataSource = showcaseCollectionDataSource
		}
	}
}
