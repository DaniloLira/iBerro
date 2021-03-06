//
//  GameCenterHelper.swift
//  iBerroApp
//
//  Created by Danilo Araújo on 08/07/21.
//

import GameKit

protocol GameCenterHelperDelegate: AnyObject {
    func didChangeAuthStatus(isAuthenticated: Bool)
    func presentGameCenterAuth(viewController: UIViewController?)
    func presentMatchmaking(viewController: UIViewController?)
    func presentGame(match: GKMatch)
}

final class GameCenterHelper: NSObject, GKLocalPlayerListener {
    weak var delegate: GameCenterHelperDelegate?
    static let helper = GameCenterHelper()
    var match: GKMatch?
    
    var isHost: Bool = false
    var musicGenre: String = ""
    var highScore: Int = 0
    
    private let minPlayers: Int = 2
    private let maxPlayers: Int = 2
    private let inviteMessage = "Let's play together".localized()
    
    var currentVC: LobbyViewController?
    
    var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { (gameCenterAuthViewController, error) in
            self.delegate?.didChangeAuthStatus(isAuthenticated: self.isAuthenticated)
            
            guard GKLocalPlayer.local.isAuthenticated else {
                self.delegate?.presentGameCenterAuth(viewController: gameCenterAuthViewController)
                return
            }

            GKLocalPlayer.local.register(self)
        }
    }
    
    func presentMatchmaker(withInvite invite: GKInvite? = nil) {
        guard GKLocalPlayer.local.isAuthenticated,
              let vc = createMatchmaker(withInvite: invite) else {
            return
        }
        
        currentVC = vc
        vc.matchmakerDelegate = self
        delegate?.presentMatchmaking(viewController: vc)
    }
    
    private func createMatchmaker(withInvite invite: GKInvite? = nil) -> LobbyViewController? {
        if let invite = invite {
            return LobbyViewController(invite: invite)
        }
        
        return LobbyViewController(matchRequest: createRequest())
    }
    
    private func createRequest() -> GKMatchRequest {
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        request.inviteMessage = inviteMessage
        return request
    }
}


extension GameCenterHelper: GKMatchmakerViewControllerDelegate {
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        GameCenterHelper.helper.match = match
        viewController.dismiss(animated: false)
        delegate?.presentGame(match: match)
    }
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        GameCenterHelper.helper.match = match
        let viewController = LobbyViewController(invite: invite)
        viewController?.matchmakerDelegate = self
        let rootViewController = UIApplication.shared.windows.first!.rootViewController
        rootViewController?.present(viewController!, animated: true, completion: nil)
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
}
