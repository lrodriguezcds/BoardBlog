//
//  WelcomeViewController+RemoteDataTrackDelegate.swift
//  BoardBlog
//
//  Created by Leticia Rodriguez on 19/5/22.
//

import UIKit
import TwilioVideo
import PencilKit

// MARK:- RemoteDataTrackDelegate
extension WhiteboardViewController: RemoteDataTrackDelegate {
    func remoteDataTrackDidReceiveString(remoteDataTrack: RemoteDataTrack, message: String) {
        print("remoteDataTrack:didReceiveString: \(message)" )
        
        if let data = message.data(using: .utf8) {
            processJsonData(remoteDataTrack, message: data)
        }
    }
    
    func processJsonData(_ remoteDataTrack: RemoteDataTrack, message: Data) {
        needToStoreOnDB = false
        do {
            if let jsonDictionary = try JSONSerialization.jsonObject(with: message, options: []) as? [String: AnyObject] {
                print("processJsonData: \(jsonDictionary)" )
                
                if let drawing = jsonDictionary["drawing"] as? String {
                    print(drawing)
                    guard let markupData = Data(base64Encoded: drawing) else { return }
                    
                    // Here we set the drawing get from the data parameter
                    let pkDrawing = try PKDrawing(data: markupData)
                    canvasView.drawing = pkDrawing
                }
            }
        } catch {
            print("Error: processJsonData \(error)")
        }
    }
}
