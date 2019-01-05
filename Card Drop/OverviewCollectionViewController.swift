//
//  OverviewCollectionViewController.swift
//  Card Drop
//
//  Created by Charles Martin Reed on 1/4/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class OverviewCollectionViewController: UICollectionViewController {
    
    //MARK:- Properties
    //using the helper functions Brian created
    //generic dataRequest, takes the Category type and loades data from the dataSource, a plist named "Categories"
    let categoryDataRequest = DataRequest<Category>(dataSource: "Categories")
    var categoryData = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    
    func loadData() {
        categoryDataRequest.getData { [weak self] dataResult in
            //request is success or failure
            switch dataResult {
            case .failure:
                print("Could not load categories")
            case .success(let categories):
                self?.categoryData = categories
                self?.collectionView.reloadData() //using this for layout
            }
        }
    }
}

  

//MARK:- CollectionView Datasource methods
extension OverviewCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //configuring the cells - unwrapping because we need a non-optional value here
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CategoryCollectionViewCell else { fatalError("Could not create category cell for collection view") }
        
        let category = categoryData[indexPath.item]
        guard let image = UIImage(named: category.categoryImageName) else { fatalError("Could not load image for cell")}
        cell.backgroundImageView.image = image
        cell.categoryLabel.text = category.categoryName
        
        return cell
    }
}

//MARK:- CollectionView Delegate methods
extension OverviewCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //in this function, we can set the display properties for the custom cell
        cell.layer.cornerRadius = 14
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK:- CollectionView Layout Delegate
extension OverviewCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //fixing the spacing issues between the individual cells
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
    }
}


