//
//  MainVC.swift
//  VizFaceDetector
//
//  Created by Yaniv Hasbani on 12/07/2019.
//  Copyright © 2019 Yaniv Hasbani. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var imageLabel: UILabel!
  @IBOutlet weak var imageTitle: UILabel!
  @IBOutlet weak var takeAnImageButton: UIButton!
  
  private var imagePicker: ImagePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addGradientToView()
    // Do any additional setup after loading the view.
    
    imagePicker = ImagePicker(presentationController: self, delegate: self)
  }


  @IBAction func takeAnImageTapped(_ sender: UIButton) {
    imagePicker.present(from: view)
  }
}

extension MainVC: ImagePickerDelegate {
  func didSelect(image: UIImage?) {
    guard let image = image else {
      return
    }
    
    let spinner = UIActivityIndicatorView(frame: UIScreen.main.bounds)
    view.addSubview(spinner)
    spinner.style = .whiteLarge
    spinner.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    spinner.startAnimating()
    
    VizNetworkManager.shared.detectFaceEmotion(image: image) { [weak self] image, json in
      guard let image = image, let faces = json?.array else {
        return
      }
      
      guard faces.count > 0 else {
        print("No face detection on image")
        DispatchQueue.main.async {
          spinner.stopAnimating()
          spinner.removeFromSuperview()
          let alert = UIAlertController(title: "Error in face detection",
                                        message: "Could not find any face on image",
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK",
                                        style: UIAlertAction.Style.default,
                                        handler: nil))
          self?.present(alert, animated: true)
        }
        return
      }
      
      let faceModel = VizFace(image: image, json: faces.first)
      DispatchQueue.main.async { [weak self] in
        self?.imageView.image = faceModel.image!
        self?.imageLabel.text = faceModel.emotion?.emojiForEmotion()
        self?.imageTitle.text = faceModel.emotion?.rawValue

        spinner.stopAnimating()
        spinner.removeFromSuperview()
      }
    }
  }
}


