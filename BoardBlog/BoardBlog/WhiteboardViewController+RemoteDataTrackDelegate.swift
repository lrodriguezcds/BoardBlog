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
        
        needToStoreOnDB = false
        
        do {
            // Generate the data from the message string (which is the drawing)
            guard let markupData = Data(base64Encoded: message) else { return }
            // Generate the PKDrawing from the data previously created
            let pkDrawing = try PKDrawing(data: markupData)
            // Here we set the drawing on the canvas
            canvasView.drawing = pkDrawing
        } catch {
            print("Error: \(error)")
        }
    }
}
