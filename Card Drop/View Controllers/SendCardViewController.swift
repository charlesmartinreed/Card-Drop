//
//  SendCardViewController.swift
//  Card Drop
//
//  Created by Charles Martin Reed on 1/6/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class SendCardViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    //MARK: Properties
    var backgroundImage: UIImage?
    let quoteDataRequest = DataRequest<Quote>(dataSource: "Quotes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = backgroundImage else { return }
        backgroundImageView.image = image
        
        loadData()

    }
    
    func loadData() {
        quoteDataRequest.getData { [weak self] dataResult in
            switch dataResult {
            case .failure:
                print("Could not load images")
            case .success(let quotes):
                let randomNumber = Int.random(in: 0 ..< quotes.count)
                DispatchQueue.main.async {
                    self?.authorLabel.text = quotes[randomNumber].author
                    self?.quoteLabel.text = quotes[randomNumber].quote
                }
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareCard(_ sender: UIButton) {
        
        //filter the subviews in the container view to remove the buttons
        _ = textContainerView.subviews.filter({$0 is UIButton}).map({$0.isHidden = true})
        
        //1. take a screenshot of the view
        let image = self.view.screenshot()
        
        
        //unhide the buttons
        _ = textContainerView.subviews.filter({$0 is UIButton}).map({$0.isHidden = false})
        
        //2. present the activity view controller
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
}

//MARK:- Extension for taking a screenshot
extension UIView {
    func screenshot() -> UIImage {
        //afterScreenUpdate means we get the most recent representation of the views
        return UIGraphicsImageRenderer(size: bounds.size).image(actions: { (_) in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        })
    }
}
