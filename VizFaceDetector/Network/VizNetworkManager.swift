//
//  VizNetworkManager.swift
//  VizFaceDetector
//
//  Created by Yaniv Hasbani on 12/07/2019.
//  Copyright © 2019 Yaniv Hasbani. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VizNetworkManager {
  static let shared = VizNetworkManager()
  // TODO: When server created, remove these to the server
  private let apiKey = ""
  private let endpointUrl = "https://vizfaceapi.cognitiveservices.azure.com/face/v1.0/detect"
  
  private var detectQuery: String {
    get {
      return endpointUrl + "?returnFaceId=true&returnFaceAttributes=emotion"
    }
  }
  
  private let faceDetectionQueue = DispatchQueue(label: "VizFaceDetectionQueue",
                                                 qos: .background,
                                                 attributes: DispatchQueue.Attributes.init(),
                                                 autoreleaseFrequency: .workItem,
                                                 target: nil)
  
  private init() { }
  
  func detectFaceEmotion(image: UIImage?,
                         completion: @escaping (_ image: UIImage?, _ json: JSON?) -> ()) {
    guard let image = image else {
      print("Did not receive image")
      completion(nil, nil)
      return
    }
    
    guard let imageData = image.pngData() else {
      print("Could not create data from image")
      completion(image, nil)
      return
    }
    
    let headers = ["Content-Type": "application/octet-stream",
                   "Ocp-Apim-Subscription-Key": apiKey]
    
    do {
      var urlRequest = try URLRequest(url: detectQuery, method: .post).asURLRequest()
      urlRequest.httpBody = imageData
      for header in headers {
        urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
      }
      
      
      let request = Alamofire.request(urlRequest)
      
      request.response(queue: faceDetectionQueue,
                       completionHandler: { (response) in
        if let error = response.error {
          print("Error in preforming request. error = \(error)")
          completion(image, nil)
          return
        }
        
        guard let data = response.data else {
          print("No data received for request")
          completion(image, nil)
          return
        }
        
        do {
          let json = try JSON(data: data)
          print("JSON = \(json)")
          completion(image, json)
        } catch {
          print("Error in encoding JSON")
          completion(image, nil)
        }
      })
    } catch {
      print("Error creating url request. error = \(error)")
      completion(image, nil)
    }
  }
}

