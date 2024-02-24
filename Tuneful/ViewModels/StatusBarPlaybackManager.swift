//
//  StatusBarPlaybackManager.swift
//  Tuneful
//
//  Created by Martin Fekete on 24/02/2024.
//

import SwiftUI

class StatusBarPlaybackManager: ObservableObject {
    
    @AppStorage("showMenuBarPlaybackControls") var showMenuBarPlaybackControls: Bool = true
    
    private var playerManager: PlayerManager
    private var statusBarItem: NSStatusItem
    
    init(playerManager: PlayerManager) {
        self.playerManager = playerManager
        
        // Playback buttons in meu bar
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusBarItem.isVisible = self.showMenuBarPlaybackControls
        self.updateStatusBarPlaybackItem()
    }

    func toggleStatusBarVisibility() {
        statusBarItem.isVisible = self.showMenuBarPlaybackControls
    }
    
    @objc func updateStatusBarPlaybackItem() {
        let menuBarView = HStack {
            Button(action: playerManager.previousTrack){
                Image(systemName: "backward.end.fill")
                    .resizable()
                    .frame(width: 11, height: 11)
                    .animation(.easeInOut(duration: 2.0), value: 1)
            }
            .pressButtonStyle()
            
            PlayPauseButton(buttonSize: 14)
                .environmentObject(playerManager)
            
            Button(action: playerManager.nextTrack) {
                Image(systemName: "forward.end.fill")
                    .resizable()
                    .frame(width: 11, height: 11)
                    .animation(.easeInOut(duration: 2.0), value: 1)
            }
            .pressButtonStyle()
        }
        
        let iconView = NSHostingView(rootView: menuBarView)
        iconView.frame = NSRect(x: 0, y: 1, width: 70, height: 20)
        
        if let button = self.statusBarItem.button {
            button.subviews.forEach { $0.removeFromSuperview() }
            button.addSubview(iconView)
            button.frame = iconView.frame
        }
    }
}

