//
//  WelcomeViewController+RemoteParticipantDelegate.swift
//  BoardBlog
//
//  Created by Leticia Rodriguez on 19/5/22.
//

import UIKit
import TwilioVideo

// MARK:- RemoteParticipantDelegate
extension WhiteboardViewController: RemoteParticipantDelegate {
    func didSubscribeToDataTrack(dataTrack: RemoteDataTrack,
                                 publication: RemoteDataTrackPublication,
                                 participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's data Track. We will start receiving the
        // remote Participant's data messages now.
        
        dataTrack.delegate = self
        
        print("Subscribed to data track for Participant \(participant.identity)")
    }
}
