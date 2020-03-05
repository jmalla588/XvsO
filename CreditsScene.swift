//
//  CreditsScene.swift
//  X vs O
//
//  Created by Janak Malla on 6/18/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import Foundation
import SpriteKit

class CreditsScene: SKScene {
    
    var backButton = SKSpriteNode(imageNamed: "arrow")
    
    override func didMove(to view: SKView) {
        
        //REAL BACKGROUND
        let bg = SKSpriteNode(imageNamed: "bg")
        bg.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        bg.size = CGSize(width:self.frame.width, height: self.frame.height)
        self.addChild(bg)
        bg.zPosition = -2
        
        let Title = SKSpriteNode(imageNamed: "creditsTitle")
        Title.xScale = 3.0; Title.yScale = 3.0; Title.run(SKAction.colorize(with: SKColor.green, colorBlendFactor: 0.5, duration: 0))
        Title.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 500)
        
        //let Title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightLight).familyName)
        //Title.fontSize = 200; Title.alpha = 0; Title.fontColor = UIColor.darkGray;
        //Title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        //Title.text = "Credits"
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        self.addChild(Title)
        Title.run(fadeIn)
        
        backButton.xScale = 1.0; backButton.yScale = 1.0; backButton.alpha = 0;
        backButton.position = CGPoint(x: self.frame.midX - 275, y: self.frame.midY - 550)
        
        self.addChild(backButton)
        backButton.run(SKAction.fadeAlpha(to: 1, duration: 3))
        
        let aCredits = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFont.Weight.light).familyName)
        aCredits.fontSize = 60; aCredits.alpha = 0; aCredits.fontColor = UIColor.darkGray;
        aCredits.position = CGPoint(x:self.frame.midX, y: self.frame.midY - 450)
        aCredits.text = "Developed by: Janak Malla"
        
        let bCredits = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFont.Weight.light).familyName)
        bCredits.fontSize = 60; bCredits.alpha = 0; bCredits.fontColor = UIColor.darkGray;
        bCredits.position = CGPoint(x:self.frame.midX, y: self.frame.midY - 450)
        bCredits.text = "Artwork by: Janak Malla"

        
        let cCredits = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFont.Weight.light).familyName)
        cCredits.fontSize = 60; cCredits.alpha = 0; cCredits.fontColor = UIColor.darkGray;
        cCredits.position = CGPoint(x:self.frame.midX, y: self.frame.midY - 450)
        cCredits.text = "Idea by: Romans, probably?"

        
        self.addChild(aCredits)
        self.addChild(bCredits)
        self.addChild(cCredits)
    
        scrollThis(self, sCredits: aCredits)
        
        let delayTime = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
            scrollThis(self, sCredits: bCredits)
        })

        let delayTime2 = DispatchTime.now() + 3.5
        DispatchQueue.main.asyncAfter(deadline: delayTime2, execute: {
            scrollThis(self, sCredits: cCredits)
        })

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == backButton {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                if let view = view {
                    let scene = MenuScene(fileNamed: "MenuScene")
                    //let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                    let transition = SKTransition.push(with: SKTransitionDirection.right, duration: 0.80)
                    scene?.scaleMode = SKSceneScaleMode.fill
                    view.presentScene(scene!, transition: transition)
                }
            }
        }
    }
    
    
}

func scrollThis(_ self: CreditsScene, sCredits: SKLabelNode) {
    
    let fadeIn3 = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
    let scrollUp = SKAction.move(by: CGVector(dx:0, dy: 650), duration: 5)
    let fadeOut = SKAction.fadeOut(withDuration: 0.5)
    let wait = SKAction.wait(forDuration: 3.5)
    let scrollDown = SKAction.move(by: CGVector(dx:0, dy: -650), duration: 0)
    
    sCredits.run(SKAction.repeatForever(SKAction.sequence([fadeIn3, scrollUp, fadeOut, scrollDown, wait])))

}










