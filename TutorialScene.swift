//
//  TutorialScene.swift
//  X vs O
//
//  Created by Janak Malla on 6/18/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

var firstTime = Bool()
var step1Complete = false;

class TutorialScene: SKScene {
    
    var backButton = SKSpriteNode(imageNamed: "arrow")
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
        
        step1Complete = false;
        
        //REAL BACKGROUND
        let bg = SKSpriteNode(imageNamed: "bg")
        bg.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        bg.size = CGSize(width:self.frame.width, height: self.frame.height)
        self.addChild(bg)
        bg.zPosition = -2
        
        firstTime = true;
        
        let Title = SKSpriteNode(imageNamed: "tutorialTitle")
        Title.xScale = 3.0; Title.yScale = 3.0; Title.run(SKAction.colorize(with: SKColor.green, colorBlendFactor: 0.5, duration: 0))
        Title.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 500)
        
        //Title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightLight).familyName)
        //Title.fontSize = 200; Title.alpha = 0; Title.fontColor = UIColor.darkGray;
        //Title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        //Title.text = "Tutorial"
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        self.addChild(Title)
        Title.run(fadeIn)
        
        backButton.xScale = 1.0; backButton.yScale = 1.0; backButton.alpha = 0;
        backButton.position = CGPoint(x: self.frame.midX - 275, y: self.frame.midY - 550)
        
        self.addChild(backButton)
        backButton.run(SKAction.fadeAlpha(to: 1, duration: 3))
        
        tut1 = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFont.Weight.light).familyName)
        tut1.fontSize = 48; tut1.alpha = 0; tut1.fontColor = UIColor.darkGray;
        tut1.position = CGPoint(x:self.frame.midX, y: self.frame.midY - 450)
        tut1.text = "Tap to place your piece on the board."
        
        tut2 = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFont.Weight.light).familyName)
        tut2.fontSize = 48; tut2.alpha = 0; tut2.fontColor = UIColor.darkGray;
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
        
        //arrow = SKSpriteNode(imageNamed: "arrow"); arrow.alpha = 0;
        //arrow.position = CGPoint(x: self.frame.midX - 110, y: self.frame.midY - 570)
        
        fadeTut1(self, tut: tut1, img: map, piece1: x, piece2: o)
        
        simple = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFont.Weight.regular).familyName)
        simple.fontSize = 48; simple.alpha = 0; simple.fontColor = UIColor.darkGray;
        simple.position = CGPoint(x:self.frame.midX, y: self.frame.midY + 200)
        simple.text = "Good job! Simple enough, right?"
        
        shot = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFont.Weight.regular).familyName)
        shot.fontSize = 48; shot.alpha = 0; shot.fontColor = UIColor.darkGray;
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
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                if let view = view {
                    let scene = MenuScene(fileNamed: "MenuScene")
                    //let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                    let transition = SKTransition.push(with: SKTransitionDirection.right, duration: 0.80)
                    scene?.scaleMode = SKSceneScaleMode.fill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
            if node == x && firstTime == true {
                run(SKAction.playSoundFileNamed("X.wav", waitForCompletion: false))
                x.removeAction(forKey: "stopKey")
                fadeTut2(self, outTut: tut1, tut: tut2, img: map, piece1: x, piece2: x2, piece3: x3)
            }
            
            else if node == x && firstTime == false && step1Complete == true {
                
                step1Complete = false;
                
                self.x.run(fadeIn)
                run(SKAction.playSoundFileNamed("X.wav", waitForCompletion: false))
                
                let delayTime = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    
                    self.x.run(fadeOut)
                    self.map.run(fadeOut)
                    self.Title.run(fadeOut)
                    self.x2.run(fadeOut);
                    self.x3.run(fadeOut)
                    self.tut2.run(fadeOut)
                    
                    DispatchQueue.main.asyncAfter(deadline: delayTime + 1.0) {
                        
                        self.x.removeFromParent()
                        self.x2.removeFromParent()
                        self.x3.removeFromParent()
                        self.map.removeFromParent()
                        self.tut2.removeFromParent()
                        self.removeAllActions()
                        
                        self.addChild(self.simple)
                        self.addChild(self.shot)
                        
                        self.simple.run(SKAction.sequence([wait, fadeIn]))
                        self.shot.run(SKAction.sequence([wait, wait, fadeIn]))
                        self.backButton.run(SKAction.sequence([wait, wait, wait, SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut]))]))
                        defaults.set(false, forKey: "babyLock")
                        let babytheme = GKAchievement.init(identifier: "XvsOThemeUnlockbaby")
                        babytheme.showsCompletionBanner = true;
                        babytheme.percentComplete = 100.0
                        GKAchievement.report([babytheme], withCompletionHandler: nil)
                    }
                    
                }

            }
        }
    }
    
}

func fadeTut1(_ self: TutorialScene, tut: SKLabelNode, img: SKSpriteNode, piece1: SKSpriteNode, piece2: SKSpriteNode) {
    
    let fadeSpriteIn = SKAction.fadeAlpha(by: 0.3, duration: 1)
    let fadeSpriteOut = SKAction.fadeAlpha(by: -0.3, duration: 1)
    
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    let wait = SKAction.wait(forDuration: 1)
    
    tut.run(fadeIn);
    img.run(fadeIn);
    piece1.run(SKAction.sequence([wait, SKAction.repeatForever(SKAction.sequence([fadeSpriteIn, fadeSpriteOut]))]), withKey: "stopKey");
    

}

func fadeTut2(_ self: TutorialScene, outTut: SKLabelNode, tut: SKLabelNode, img: SKSpriteNode, piece1: SKSpriteNode, piece2: SKSpriteNode, piece3: SKSpriteNode) {
    
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
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
        step1Complete = true;
    }

}

