//
//  ResultsViewController.swift
//  NT-GTA App
//
//  Created by Nhut Tran on 10/31/25.
//

import UIKit
import Vision

class ResultsViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var resultTextLabel: UILabel!
    
    @IBOutlet weak var userImageImageView: UIImageView!
    
    var userImage: UIImage?
    var imageAnalysisFirstResult: VNClassificationObservation?
    var imageAnalysisSecondResult: VNClassificationObservation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Back"
        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.prefersLargeTitles = true
        loadResults()
    }
 
    func loadResults(){
        //display user's image to the screen
        userImageImageView.image = userImage
        
        if imageAnalysisFirstResult!.confidence > 75{
            resultTextLabel.text = "I am confident that you're \(imageAnalysisFirstResult!.identifier)!😎"
        } else{
            resultTextLabel.text = "I think that you're \(imageAnalysisFirstResult!.identifier) 🤔, but my 2nd guess is also \(imageAnalysisSecondResult!.identifier)."
        }
    }
}
