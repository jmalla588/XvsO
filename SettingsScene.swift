//
//  SettingsScene.swift
//  X vs O
//
//  Created by Janak Malla on 6/18/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {
    
    var backButton = SKSpriteNode(imageNamed: "back")
    var themes = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var pNames = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var diff = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    
    override func didMove(to view: SKView) {
        let Title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
        Title.fontSize = 200; Title.alpha = 0; Title.fontColor = UIColor.darkGray();
        Title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        Title.text = "Settings"
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        self.addChild(Title)
        Title.run(fadeIn)
        
        backButton.xScale = 0.5; backButton.yScale = 0.5; backButton.alpha = 0;
        backButton.position = CGPoint(x: self.frame.midX - 275, y: self.frame.midY - 550)
        
        self.addChild(backButton)
        backButton.run(SKAction.fadeAlpha(to: 1, duration: 3))
        
        themes.text = "Themes"; pNames.text = "Player Names"; diff.text = "CPU Difficulty";
        themes.fontSize = 100; pNames.fontSize = 100; diff.fontSize = 100;
        themes.fontColor = UIColor.darkGray(); pNames.fontColor = UIColor.darkGray(); diff.fontColor = UIColor.darkGray();
        diff.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        pNames.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)-150)
        themes.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)-300)
        themes.name = "themes"; pNames.name = "players"; diff.name = "diff";
        themes.alpha = 0; pNames.alpha = 0; diff.alpha = 0;
        
        self.addChild(themes); self.addChild(pNames); self.addChild(diff);

        themes.run(fadeIn); pNames.run(fadeIn); diff.run(fadeIn);
        
        let gear = SKSpriteNode(imageNamed: "gear")
        gear.xScale = 0.25; gear.yScale = 0.25; gear.alpha = 0;
        gear.position = CGPoint(x: self.frame.midX, y: (self.frame.midY) + 240)
        
        self.addChild(gear)
        
        let spin = SKAction.repeatForever(SKAction.rotate(byAngle: 6.2831853, duration: 4.0))
        gear.run(spin)
        gear.run(SKAction.fadeAlpha(to: 1, duration: 3))
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == backButton {
                
                if let view = view {
                    
                    let scene = MenuScene(fileNamed: "MenuScene")
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
                
            }
            
            if node == themes {
                themes.fontColor = UIColor.white()
            }
            
            if node == pNames {
                pNames.fontColor = UIColor.white()
            }
            
            if node == diff {
                diff.fontColor = UIColor.white()
            }
            
        }
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in:self)
            let node = self.atPoint(pos)
            
            if node == themes {
                themes.fontColor = UIColor.darkGray()
            }
        
            if node == pNames {
                pNames.fontColor = UIColor.darkGray()
            }
            
            if node == diff {
                diff.fontColor = UIColor.darkGray()
            }
            
        }

    }
    
    
    
    
    
    
    
    
    
    
    
}
