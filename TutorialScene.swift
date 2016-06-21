//
//  TutorialScene.swift
//  X vs O
//
//  Created by Janak Malla on 6/18/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import Foundation
import SpriteKit

var firstTime = Bool()

class TutorialScene: SKScene {
    
    var backButton = SKSpriteNode(imageNamed: "back")
    var x = SKSpriteNode();
    var map = SKSpriteNode();
    var o = SKSpriteNode();
    var tut2 = SKLabelNode();
    var tut1 = SKLabelNode();
    var simple = SKLabelNode();
    var shot = SKLabelNode();
    var Title = SKLabelNode();
    var x2 = SKSpriteNode();
    var x3 = SKSpriteNode();
    var arrow = SKSpriteNode();
    
    override func didMove(to view: SKView) {
        
        firstTime = true;
        
        Title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
        Title.fontSize = 200; Title.alpha = 0; Title.fontColor = UIColor.darkGray();
        Title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        Title.text = "Tutorial"
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        self.addChild(Title)
        Title.run(fadeIn)
        
        backButton.xScale = 0.5; backButton.yScale = 0.5; backButton.alpha = 0;
        backButton.position = CGPoint(x: self.frame.midX - 275, y: self.frame.midY - 550)
        
        self.addChild(backButton)
        backButton.run(SKAction.fadeAlpha(to: 1, duration: 3))
        
        tut1 = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
        tut1.fontSize = 48; tut1.alpha = 0; tut1.fontColor = UIColor.darkGray();
        tut1.position = CGPoint(x:self.frame.midX, y: self.frame.midY - 450)
        tut1.text = "Tap to place your piece on the board."
        
        tut2 = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
        tut2.fontSize = 48; tut2.alpha = 0; tut2.fontColor = UIColor.darkGray();
        tut2.position = CGPoint(x:self.frame.midX, y: self.frame.midY - 450)
        tut2.text = "Get 3 in a row to win!"
        
        map = SKSpriteNode(imageNamed: "Hash"); //map.xScale = 0.55; map.yScale = 0.55
        map.alpha = 0; map.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        x = SKSpriteNode(imageNamed: "X"); o = SKSpriteNode(imageNamed: "O")
        x.xScale = 0.9; x.yScale = 0.9; o.xScale = 0.9; o.yScale = 0.9; x.alpha = 0;
        
        x2 = SKSpriteNode(imageNamed: "X"); x2.xScale = 0.9; x2.yScale = 0.9; x2.alpha = 0;
        x3 = SKSpriteNode(imageNamed: "X"); x3.xScale = 0.9; x3.yScale = 0.9; x3.alpha = 0;
        
        self.addChild(tut1)
        self.addChild(tut2)
        self.addChild(map);
        self.addChild(x);
        
        arrow = SKSpriteNode(imageNamed: "arrow"); arrow.alpha = 0;
        arrow.position = CGPoint(x: self.frame.midX - 110, y: self.frame.midY - 570)
        
        fadeTut1(self: self, tut: tut1, img: map, piece1: x, piece2: o)
        
        simple = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightLight).fontName)
        simple.fontSize = 48; simple.alpha = 0; simple.fontColor = UIColor.darkGray();
        simple.position = CGPoint(x:self.frame.midX, y: self.frame.midY + 200)
        simple.text = "Good job! Simple enough, right?"
        
        shot = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightLight).fontName)
        shot.fontSize = 48; shot.alpha = 0; shot.fontColor = UIColor.darkGray();
        shot.position = CGPoint(x:self.frame.midX, y: self.frame.midY - 100)
        shot.text = "Go ahead and give it a shot!"

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            let fadeIn = SKAction.fadeIn(withDuration: 1)
            let wait = SKAction.wait(forDuration: 1)
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            
            if node == backButton {
                if let view = view {
                    let scene = MenuScene(fileNamed: "MenuScene")
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
            if node == x && firstTime == true {
                x.removeAction(forKey: "stopKey")
                fadeTut2(self: self, outTut: tut1, tut: tut2, img: map, piece1: x, piece2: x2, piece3: x3)
            }
            
            else if node == x && firstTime == false {
                
                self.x.run(fadeIn)
                
                let delayTime = DispatchTime.now() + 1.0
                DispatchQueue.main.after(when: delayTime) {
                    
                    self.x.run(fadeOut)
                    self.map.run(fadeOut)
                    self.Title.run(fadeOut)
                    self.x2.run(fadeOut);
                    self.x3.run(fadeOut)
                    
                    DispatchQueue.main.after(when: delayTime + 1.0) {
                        
                        self.x.removeFromParent()
                        self.x2.removeFromParent()
                        self.x3.removeFromParent()
                        self.map.removeFromParent()
                        self.tut2.removeFromParent()
                        self.removeAllActions()
                        
                        self.addChild(self.simple)
                        self.addChild(self.shot)
                        self.addChild(self.arrow)
                        
                        self.simple.run(SKAction.sequence([wait, fadeIn]))
                        self.shot.run(SKAction.sequence([wait, wait, fadeIn]))
                        self.arrow.run(SKAction.sequence([wait, wait, wait, SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut]))]))
                    }
                    
                }

                
                
                
            }
        }
    }
    
}

func fadeTut1(self: TutorialScene, tut: SKLabelNode, img: SKSpriteNode, piece1: SKSpriteNode, piece2: SKSpriteNode) {
    
    let fadeSpriteIn = SKAction.fadeAlpha(by: 0.3, duration: 1)
    let fadeSpriteOut = SKAction.fadeAlpha(by: -0.3, duration: 1)
    
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    let wait = SKAction.wait(forDuration: 1)
    
    tut.run(fadeIn);
    img.run(fadeIn);
    piece1.run(SKAction.sequence([wait, SKAction.repeatForever(SKAction.sequence([fadeSpriteIn, fadeSpriteOut]))]), withKey: "stopKey");
    

}

func fadeTut2(self: TutorialScene, outTut: SKLabelNode, tut: SKLabelNode, img: SKSpriteNode, piece1: SKSpriteNode, piece2: SKSpriteNode, piece3: SKSpriteNode) {
    
    firstTime = false;
    
    let fadeSpriteIn = SKAction.fadeAlpha(by: 0.3, duration: 1)
    let fadeSpriteOut = SKAction.fadeAlpha(by: -0.3, duration: 1)
    
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    let fadeOut = SKAction.fadeOut(withDuration: 1)
    let wait1 = SKAction.wait(forDuration: 1)
    let wait2 = SKAction.wait(forDuration: 2)
    let wait4 = SKAction.wait(forDuration: 4)
    let flashSeq = SKAction.sequence([wait1, SKAction.repeatForever(SKAction.sequence([fadeSpriteIn, fadeSpriteOut]))])
    let alpha0 = SKAction.fadeAlpha(to: 0, duration: 0)
    
    piece1.run(SKAction.sequence([fadeIn, wait1, fadeOut, wait2, flashSeq]), withKey: "bananaKey");
    
    outTut.run(SKAction.sequence([wait2, fadeOut]))
    img.run(SKAction.sequence([wait2, fadeOut, wait1, fadeIn]))
    
    tut.run(SKAction.sequence([wait4, fadeIn]))
    
    piece2.removeAction(forKey: "bananaKey")
    piece3.removeAction(forKey: "bananaKey")
    
    piece2.position = CGPoint(x: self.frame.midX, y: self.frame.midY+245)
    piece3.position = CGPoint(x: self.frame.midX, y: self.frame.midY-245)
    piece2.alpha = 0; piece3.alpha = 0;

    self.addChild(piece2); self.addChild(piece3)
    

    piece2.run(SKAction.sequence([alpha0, wait4, fadeIn]))
    piece3.run(SKAction.sequence([alpha0, wait4, fadeIn]))
    
}

