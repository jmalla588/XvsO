//
//  ThemeScene.swift
//  X vs O
//
//  Created by Janak Malla on 7/25/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import SpriteKit

class ThemeScene: SKScene {
    
    let defaults = UserDefaults.standard
    var backButton = SKSpriteNode(imageNamed: "arrow")
    
    override func didMove(to view: SKView) {
        
        let Title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
        Title.fontSize = 200; Title.alpha = 0; Title.fontColor = UIColor.darkGray();
        Title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        Title.text = "Themes"
        
        let unlock = self.childNode(withName: "unlock") as? SKLabelNode
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        self.addChild(Title)
        Title.run(fadeIn)
        
        backButton.xScale = 1.0; backButton.yScale = 1.0; backButton.alpha = 0;
        backButton.position = CGPoint(x: self.frame.midX - 275, y: self.frame.midY - 550)
        self.addChild(backButton)
        backButton.run(fadeIn)
        
        let hsEasy = defaults.integer(forKey: "hsEasy")
        let hsMedium = defaults.integer(forKey: "hsMedium")
        let hsHard = defaults.integer(forKey: "hsHard")
        
        let displayString = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 50, weight: UIFontWeightLight).fontName)
        displayString.position = CGPoint(x:self.frame.midX, y: self.frame.midY); displayString.alpha = 0;
        displayString.text = "\(hsEasy)    \(hsMedium)    \(hsHard)"
        self.addChild(displayString)
        displayString.run(fadeIn)
        
        unlock?.run(fadeIn)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == backButton {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                if let view = view {
                    let scene = SettingsScene(fileNamed: "SettingsScene")
                    let transition = SKTransition.fade(with: SKColor.lightGray(), duration: 0.75)
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
            
        }
        
    }
    
    
    
    
}
