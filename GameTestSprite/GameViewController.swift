//
//  GameViewController.swift
//  GameTestSprite
//
//  Created by Janak Malla on 6/14/16.
//  Copyright (c) 2016 Janak Malla. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameKit

class GameViewController: UIViewController, EGCDelegate {
    
    let defaults = UserDefaults.standard
    var backgroundMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GAME CENTER STUFF
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            }
                
            else {
             //   println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
        //automatically get the name of the game center authenticated player and set as player name
        let player = EGC.localPlayer
        if player.isAuthenticated {
            
            defaults.set(player.alias, forKey: "nameOne")
        }

        EGC.sharedInstance(self)
        
        if let scene = MenuScene(fileNamed:"MenuScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
            

        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let backgroundMusicURL = Bundle.main.url(forResource: "bg.wav", withExtension: nil)
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL!)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
            
        } catch let error as NSError {
            print(error.description)
        }
        
        EGC.delegate = self
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
