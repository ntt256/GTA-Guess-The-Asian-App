//
//  ViewController.swift
//  NT-GTA APP
//
//  Created by Nhut Tran on 10/30/25.
//

import UIKit
import CoreImage
import Vision
import CoreML

class ViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var userImage: UIImage?
    var imageAnalysisFirstResult: VNClassificationObservation?
    var imageAnalysisSecondResult: VNClassificationObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }


    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func uploadPhotoButtonPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    //machine learning classif.
    func analyzeImage(_ image: CIImage){
        //load our model
        guard let model = try? VNCoreMLModel(for: GTAImageClassifier().model) else{
            fatalError("Failed to load the ML Model")
        }
        let request = VNCoreMLRequest(model: model) { req, err in
            if err != nil{
                print(err!)
                return
            }
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError("Failed to get results from the VN request")
            }
            self.imageAnalysisFirstResult = results[0]
            self.imageAnalysisSecondResult = results[1]
        }
        let handler = VNImageRequestHandler(ciImage: image)
        try? handler.perform([request])
    }
}
//MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            guard let ciImage = CIImage(image: userPickedImage) else{
                fatalError("Could not convert user's picked image into a CIImage")
            }
            userImage = userPickedImage
            analyzeImage(ciImage)
            performSegue(withIdentifier: "goToResults", sender: self)
            imagePicker.dismiss(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! ResultsViewController
        destinationVc.imageAnalysisFirstResult = imageAnalysisFirstResult
        destinationVc.imageAnalysisSecondResult = imageAnalysisSecondResult
        destinationVc.userImage = userImage
    }
}
