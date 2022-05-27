//
//  ViewController.swift
//  BoardBlog
//
//  Created by Leticia Rodriguez on 18/5/22.
//

import UIKit
import PencilKit
import TwilioVideo

class WhiteboardViewController: UIViewController {
    
    @IBOutlet weak var canvasView: PKCanvasView!
    
    // Configure access token manually for testing, if desired! Create one manually in the console
    // at https://www.twilio.com/console/video/runtime/testing-tools
    private var accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2Q5MWZlM2Y4N2RlZWQ1NzI0MmJjMGE4MDc2ZTBhZGRkLTE2NTMwNTUxMzEiLCJpc3MiOiJTS2Q5MWZlM2Y4N2RlZWQ1NzI0MmJjMGE4MDc2ZTBhZGRkIiwic3ViIjoiQUNmNTk5YmIzOWJlZjk2NWVhZmNiNTlkOTEyODdiODY0OSIsImV4cCI6MTY1MzA1ODczMSwiZ3JhbnRzIjp7ImlkZW50aXR5IjoibGV0aWxldGkiLCJ2aWRlbyI6eyJyb29tIjoiY29vbFJvb20ifX19.ZVaLeawHeQ1qaKumuqe-8zHPuDvgzhY7YAmcnUGvFlI"

    // PencilKit
    private var toolPicker: PKToolPicker!
    
    // TwilioVideo SDK components variables
    private var localDataTrack: LocalDataTrack!
    
    var room: Room?
    var localParticipant: LocalParticipant?

    // Generic
    var needToStoreOnDB = false

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectToARoom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpPencilKit()
    }
    
    // MARK: Private Methods
    
    private func connectToARoom() {
        let dataTrackOptions = DataTrackOptions() { (builder) in
            builder.isOrdered = true
            builder.name = "Draw"
        }
        
        self.localDataTrack = LocalDataTrack(options: dataTrackOptions)
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: accessToken) { builder in
            
            builder.dataTracks = [self.localDataTrack]

            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room
            builder.roomName = "coolRoom"
        }

        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions,
                                      delegate: self)
    }
    
    private func setUpPencilKit() {
        // Add toolpicker
        // Create a PencilKit ToolPicker
        toolPicker = PKToolPicker()
        
        // Sets the visibility for the tool picker, based on when the specified responder object becomes active which is our canvasView.
        toolPicker?.setVisible(true,
                               forFirstResponder: canvasView)
        // set our toolPicker observer which is our canvasView.
        toolPicker?.addObserver(canvasView)
        toolPicker?.addObserver(self)
        
        canvasView?.delegate = self
        canvasView?.drawingPolicy = .anyInput
        // Make our inputCanvasView firstResponder.
        canvasView.becomeFirstResponder()
    }
    
    // MARK: Public Methods
    
    func set(localdatatrack: LocalDataTrack) {
        self.localDataTrack = localdatatrack
    }
    
    // MARK: Helpers
    
    /// Sends the drawig information as a jsonString using Twilio Data Track
    func send(_ dictionary: Dictionary<String, Any>,
                             _ localDrawingsDataTrack: LocalDataTrack?) {
        let tmp = dictionary.description.replacingOccurrences(of: "[", with: "{")
        let jsonString = tmp.replacingOccurrences(of: "]", with: "}")
        localDrawingsDataTrack?.send(jsonString)
    }
}

extension WhiteboardViewController: PKCanvasViewDelegate, PKToolPickerObserver {
    /// Delegate method: Note that the drawing has changed.
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guard !canvasView.drawing.bounds.isEmpty else { return }
                
        if needToStoreOnDB {
            var dictionary = [String: Any]()
            dictionary["drawing"] = canvasView.drawing.base64EncodedString()
            send(dictionary, localDataTrack)
        }
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        needToStoreOnDB = true
    }
}
