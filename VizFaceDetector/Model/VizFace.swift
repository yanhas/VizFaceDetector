//
//  VizFace.swift
//  VizFaceDetector
//
//  Created by Yaniv Hasbani on 15/07/2019.
//  Copyright © 2019 Yaniv Hasbani. All rights reserved.
//

import Foundation
import SwiftyJSON

enum VizFaceEmotion: String, CaseIterable {
  case disgust
  case anger
  case surprise
  case fear
  case contempt
  case sadness
  case happiness
  case neutral
  
  func emojiForEmotion() -> String {
    switch self {
    case .disgust:
      return "🤮"
    case .anger:
      return "🤬"
    case .surprise:
      return "😱"
    case .fear:
      return "😨"
    case .contempt:
      return "🤨"
    case .sadness:
      return "😢"
    case .happiness:
      return "😄"
    case .neutral:
      return "😐"
    }
  }
}

struct VizFace {
  private let faceId: String?
  
  let emotion: VizFaceEmotion?
  let image: UIImage?
  
  init(image: UIImage, json: JSON?) {
    let image = image
    self.faceId = json?["faceId"].string
    
    guard let emotions = json?["faceAttributes"]["emotion"].dictionaryObject as? [String: Double] else {
      print("Could not find emotions in JSON")
      
      self.emotion = nil
      self.image = nil
      return
    }
    
    // Get the emotion with max P
    let emotion = emotions.max { a, b in
      a.value < b.value
    }
    
    if let emotion = emotion {
      self.emotion = VizFaceEmotion(rawValue: emotion.key)
    } else {
      self.emotion = nil
    }
    
    if let faceRect = json?["faceRectangle"].dictionary,
      let x = faceRect["left"]?.float,
      let y = faceRect["top"]?.float,
      let width = faceRect["width"]?.float,
      let height = faceRect["height"]?.float {
      let imageRect = CGRect(x: CGFloat(x),
                             y: CGFloat(y),
                             width: CGFloat(width),
                             height: CGFloat(height))
      guard let cgImage = image.cgImage?.cropping(to: imageRect) else {
        self.image = nil
        return
      }
      self.image = UIImage(cgImage: cgImage)
    } else {
      self.image = nil
    }
  }
}
