//
//  LobbyViewController.swift
//  iBerro
//
//  Created by Danilo Araújo on 14/07/21.
//

import Foundation
import GameKit
import SwiftUI

class LobbyViewController: GKMatchmakerViewController {
    var gameView: UIHostingController<LoadingView>?
    
    override init?(invite: GKInvite) {
        super.init(invite: invite)
    }

    override init?(matchRequest request: GKMatchRequest) {
        super.init(matchRequest: request)
        self.setupGameView()
        
    }
        
        required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGameView() {
        gameView = UIHostingController(rootView: LoadingView())
        
        self.addChild(gameView!)
        self.view.addSubview(gameView!.view)
        
        if let gameUIHosting = gameView {
            gameUIHosting.view.translatesAutoresizingMaskIntoConstraints = false
            gameUIHosting.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            gameUIHosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            gameUIHosting.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            gameUIHosting.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
    }
}
