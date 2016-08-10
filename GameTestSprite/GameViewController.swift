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

class GameViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var backgroundMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GAME CENTER STUFF
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            }
                
            else {
             //   println((GKLocalPlayer.localPlayer().authenticated))
            }
        }

        
        if let scene = MenuScene(fileNamed:"MenuScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            
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
