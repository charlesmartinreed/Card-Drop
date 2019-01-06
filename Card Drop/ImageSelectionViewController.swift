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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
