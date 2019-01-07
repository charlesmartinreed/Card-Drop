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
    let imageDataRequest = DataRequest<Image>(dataSource: "Images")
    var imageData = [Image]()
    
    //MARK:- @IBOutlets
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var initialDimView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //fading in the dim view
        initialDimView.alpha = 0
        backButton.alpha = 0
        
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
        UIView.animate(withDuration: 0.25) {
            self.initialDimView.alpha = 1
            self.backButton.alpha = 1
        }
        
        //adjusting the scroll view - scrolling from leading to trailing
        //total width is equal to the base frame * the number of images, INCLUDING THE INITIAL IMAGE
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(imageData.count + 1)
        
        for (i, image) in imageData.enumerated() {
            //create frame for photo view - second item in the list needs to be offset by the width of the frame, + 1 because i begins at 0
            let frame = CGRect(x: self.scrollView.frame.width * CGFloat(i + 1), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            //get a photo view from the xib file - returns an arry of objects, we only need the first
            guard let photoView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as? PhotoView else { return }
            
            //configure the photoview and add it to the scrollView
            photoView.frame = frame
            photoView.imageView.image = UIImage(named: image.imageName)!
            
            photoView.descriptionLabel.text = image.description
            photoView.photographerLabel.text = image.photographer
            
            scrollView.addSubview(photoView)
        }
        
    }
    
    //MARK:- @IBActions
    @IBAction func goBackButtonTapped(_ sender: UIButton) {
        
        //scroll back to the start state of ths scroll view - we need to know when animation is finished in order to trigger the pop to the view controller
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
        }) { (_) in
            //fade out the dim view and the back button
            UIView.animate(withDuration: 0.25, animations: {
                self.initialDimView.alpha = 0
                sender.alpha = 0 //because the sender itself is a UIButton, our back button
            }, completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
}

  //both the from and to VCs have to conform to scaling, but so does the Image View itself
extension ImageSelectionViewController : Scaling {
    func scaling(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return initialImageView
    }
    
    
}
