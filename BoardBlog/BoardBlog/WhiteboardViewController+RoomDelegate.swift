//
//  WelcomeViewControllerRoomDelegateExtension.swift
//  BoardBlog
//
//  Created by Leticia Rodriguez on 19/5/22.
//

import UIKit
import TwilioVideo

// MARK:- RoomDelegate
extension WhiteboardViewController: RoomDelegate {
    func roomDidConnect(room: Room) {
        self.localParticipant = room.localParticipant!
        
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = self
        }
        print("Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity))")
    }
    
    func roomDidDisconnect(room: Room,
                           error: Error?) {
        print("Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.localParticipant = nil
        self.room = nil
    }
    
    func roomDidFailToConnect(room: Room,
                              error: Error) {
        print("Failed to connect to room with error: \(error.localizedDescription)")
        self.room = nil
    }
    
    func participantDidConnect(room: Room,
                               participant: RemoteParticipant) {
        participant.delegate = self
        
        print("Participant \(participant.identity) connected with \(participant.remoteDataTracks.count) data, \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
}
