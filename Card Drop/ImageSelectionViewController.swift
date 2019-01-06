//
//  ImageSelectionViewController.swift
//  Card Drop
//
//  Created by Charles Martin Reed on 1/5/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class ImageSelectionViewController: UIViewController {

    //MARK: Properties
    var image: UIImage?
    var category: Category?
    
    //pulling data from our plist file
    let imageDataRequest = DataRequest<Image>(dataSource: "images")
    var imageData = [Image]()
    
    //MARK:- @IBOutlets
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = image, let availableCategory = category {
            initialImageView.image = availableImage
            categoryLabel.text = availableCategory.categoryName
        }
    }
    
    //load the data after the view loads
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func loadData() {
        imageDataRequest.getData { [weak self] dataResult in
            switch dataResult {
            case .failure:
                print("could not load images")
            case .success(let images):
                self?.imageData = images
                //if we have the image data, we can continue setting up the UI on the main thread
                DispatchQueue.main.async {
                    self?.setupUI()
                }
            }
        }
    }
    
    func setupUI() {
        //get a photo view from the xib file - returns an arry of objects, we only need the first
        guard let photoView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as? PhotoView else { return }
    }
    
    //MARK:- @IBActions
    @IBAction func goBackButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

  //both the from and to VCs have to conform to scaling, but so does the Image View itself
extension ImageSelectionViewController : Scaling {
    func scaling(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return initialImageView
    }
    
    
}
