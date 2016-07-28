//
//  MenuScene.swift
//  X vs O
//
//  Created by Janak Malla on 6/16/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import SpriteKit
import AVFoundation


class MenuScene: SKScene {
    
    var sPlayer = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightSemibold).fontName)
    var mPlayer = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightSemibold).fontName)
    var settings = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightBold).fontName)
    var credits = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightBold).fontName)
    var help = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightBold).fontName)
    var sPlayerShadow = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightSemibold).fontName)
    var mPlayerShadow = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightSemibold).fontName)
    var settingsShadow = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightBold).fontName)
    var creditsShadow = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightBold).fontName)
    var helpShadow = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightBold).fontName)
    var redfx = SKEmitterNode(fileNamed: "TestParticle.sks")
    let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
    var overlay1 = SKSpriteNode(imageNamed: "overlay")
    var overlay2 = SKSpriteNode(imageNamed: "overlay")
    var overlay3 = SKSpriteNode(imageNamed: "overlay")
    var overlay4 = SKSpriteNode(imageNamed: "overlay")
    var overlay5 = SKSpriteNode(imageNamed: "overlay")
    var gear = SKSpriteNode(imageNamed: "gear")
    var question = SKSpriteNode(imageNamed: "question")
    
    let backAndForth = SKAction.repeatForever(SKAction.sequence([SKAction.scaleX(to: -0.2, duration: 0.5),
                                                                 SKAction.moveBy(x: -330, y: 0, duration: 1.5),
                                                                 SKAction.scale(to: 0.3, duration: 0.5),
                                                                 SKAction.wait(forDuration: 0.5),
                                                                 SKAction.scale(to: 0.2, duration: 0.5),
                                                                 SKAction.wait(forDuration: 1.0),
                                                                 SKAction.animate(with: [SKTexture(imageNamed: "Xwarrior")], timePerFrame: 0.2),
                                                                 SKAction.moveBy(x: +330, y: 0, duration: 1.5),
                                                                 SKAction.wait(forDuration: 1.0),
                                                                 SKAction.moveBy(x: -280, y:0, duration: 2.0),
                                                                 SKAction.wait(forDuration: 0.5),
                                                                 SKAction.moveBy(x: 0, y:+320, duration: 2.8),
                                                                 SKAction.moveBy(x: +600, y:0, duration: 3.5),
                                                                 SKAction.scaleX(to: -0.2, duration: 0.3),
                                                                 SKAction.moveBy(x: 0, y:-320, duration: 2.0),
                                                                 SKAction.moveBy(x: -320, y:0, duration: 2.0),
                                                                 SKAction.scaleX(to: 0.2, duration: 0.3),
                                                                 SKAction.wait(forDuration: 4.0),
                                                                 SKAction.moveBy(x: -280, y:0, duration: 2.0),
                                                                 SKAction.wait(forDuration: 0.5),
                                                                 SKAction.moveBy(x:+600, y:0, duration: 2.8),
                                                                 SKAction.scaleX(to: -0.2, duration: 0.3),
                                                                 SKAction.moveBy(x: 0, y:+320, duration: 2.0),
                                                                 SKAction.moveBy(x: -600, y:0, duration: 3.5),
                                                                 SKAction.scaleX(to: 0.2, duration: 0.3),
                                                                 SKAction.moveBy(x: 0, y:-320, duration: 2.0),
                                                                 SKAction.moveBy(x:+280, y:0, duration: 2.0),
                                                                 SKAction.scaleX(to: 0.2, duration: 0.3),
                                                                 SKAction.wait(forDuration: 2.0)]))
    
    let forthAndBack = SKAction.repeatForever(SKAction.sequence([SKAction.scaleX(to: -0.2, duration: 0.5),
                                                                 SKAction.moveBy(x: +330, y: 0, duration: 1.5),
                                                                 SKAction.scale(to: 0.3, duration: 0.5),
                                                                 SKAction.wait(forDuration: 0.5),
                                                                 SKAction.scale(to: 0.2, duration: 0.5),
                                                                 SKAction.wait(forDuration: 1.0),
                                                                 SKAction.animate(with: [SKTexture(imageNamed: "Owarrior")], timePerFrame: 0.2),
                                                                 SKAction.moveBy(x: -330, y: 0, duration: 1.5),
                                                                 SKAction.wait(forDuration: 1.0),
                                                                 SKAction.moveBy(x: +280, y:0, duration: 2.0),
                                                                 SKAction.wait(forDuration: 0.5),
                                                                 SKAction.moveBy(x:-600, y:0, duration: 2.8),
                                                                 SKAction.scaleX(to: -0.2, duration: 0.3),
                                                                 SKAction.moveBy(x:0, y:+320, duration: 2.0),
                                                                 SKAction.moveBy(x:+600, y:0, duration: 3.5),
                                                                 SKAction.scaleX(to: 0.2, duration: 0.3),
                                                                 SKAction.moveBy(x:0, y:-320, duration: 2.0),
                                                                 SKAction.moveBy(x:-280, y:0, duration: 2.0),
                                                                 SKAction.wait(forDuration: 2.0),
                                                                 SKAction.moveBy(x: +280, y:0, duration: 2.0),
                                                                 SKAction.wait(forDuration: 0.5),
                                                                 SKAction.moveBy(x: 0, y:+320, duration: 2.8),
                                                                 SKAction.moveBy(x: -600, y:0, duration: 3.5),
                                                                 SKAction.scaleX(to: -0.2, duration: 0.3),
                                                                 SKAction.moveBy(x: 0, y:-320, duration: 2.0),
                                                                 SKAction.moveBy(x: +320, y:0, duration: 2.0),
                                                                 SKAction.scaleX(to: 0.2, duration: 0.3),
                                                                 SKAction.wait(forDuration: 4.3)]))
    
    let wag = SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: 0.5, duration: 0.4),
                                                        SKAction.rotate(byAngle: -1.0, duration: 0.8),
                                                        SKAction.rotate(byAngle: 0.5, duration: 0.4)]))
    
    let bounce = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3.0),
                                                           SKAction.move(by: CGVector.init(dx: 0, dy: 10), duration: 0.8),
                                                           SKAction.move(by: CGVector.init(dx: 0, dy: -10), duration: 0.2),
                                                           SKAction.move(by: CGVector.init(dx: 0, dy: 5), duration: 0.15),
                                                           SKAction.move(by: CGVector.init(dx: 0, dy: -5), duration: 0.1),
                                                           SKAction.move(by: CGVector.init(dx: 0, dy: 2), duration: 0.15),
                                                           SKAction.move(by: CGVector.init(dx: 0, dy: -2), duration: 0.1)]))

    override func didMove(to view: SKView) {
        
        //ADDS AND ANIMATES BACKGROUND IMAGE
        let background = SKSpriteNode(imageNamed: "launchnocopy")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        addChild(background)
        background.zPosition = -1
        
        let slideOutBG = SKAction.move(by: CGVector(dx: 0, dy: 400), duration: 0.75)
        background.run(slideOutBG)
        
        
        
        
        //SETS UP ALL LABELS
        sPlayer = setUpLabel(labelName: sPlayer, nameOfLabel: "1", withText: "SINGLE PLAYER",
                             isShadow: false, location: CGPoint(x:self.frame.midX, y:self.frame.midY), sizeOfFont: 80)
        mPlayer = setUpLabel(labelName: mPlayer, nameOfLabel: "2", withText: "MULTIPLAYER",
                             isShadow: false, location: CGPoint(x:self.frame.midX, y:(self.frame.midY)-150), sizeOfFont: 80)
        settings = setUpLabel(labelName: settings, nameOfLabel: "settings", withText: "SETTINGS",
                              isShadow: false, location: CGPoint(x:self.frame.midX + 285, y:(self.frame.midY)-637), sizeOfFont: 30)
        help = setUpLabel(labelName: help, nameOfLabel: "help", withText: "TUTORIAL",
                          isShadow: false, location: CGPoint(x:self.frame.midX - 285, y:(self.frame.midY)-637), sizeOfFont: 30)
        credits = setUpLabel(labelName: credits, nameOfLabel: "credits", withText: "CREDITS",
                             isShadow: false, location: CGPoint(x:self.frame.midX, y:(self.frame.midY)-637), sizeOfFont: 30)
        
        
        
        
        //SETS UP ALL LABEL SHADOWS
        sPlayerShadow = setUpLabel(labelName: sPlayerShadow, nameOfLabel: "1shadow", withText: "SINGLE PLAYER",
                                   isShadow: true, location: CGPoint(x: self.frame.midX+2, y: self.frame.midY-2), sizeOfFont: 80)
        mPlayerShadow = setUpLabel(labelName: mPlayerShadow, nameOfLabel: "2shadow", withText: "MULTIPLAYER",
                                   isShadow: true, location: CGPoint(x: self.frame.midX+2, y: self.frame.midY-152), sizeOfFont: 80)
        settingsShadow = setUpLabel(labelName: settingsShadow, nameOfLabel: "settingsshadow", withText: "SETTINGS",
                                    isShadow: true, location: CGPoint(x:self.frame.midX + 286, y:(self.frame.midY)-638), sizeOfFont: 30)
        helpShadow = setUpLabel(labelName: helpShadow, nameOfLabel: "helpshadow", withText: "TUTORIAL",
                                isShadow: true, location: CGPoint(x:self.frame.midX - 284, y:(self.frame.midY)-638), sizeOfFont: 30)
        creditsShadow = setUpLabel(labelName: creditsShadow, nameOfLabel: "creditsshadow", withText: "CREDITS", isShadow: true, location: CGPoint(x:self.frame.midX + 1, y:(self.frame.midY)-638), sizeOfFont: 30)
        
        
        
        
        //SETS UP ALL OVERLAYS
        overlay1.position = CGPoint(x:self.frame.midX, y:self.frame.midY+20); overlay1.zPosition = 0.5;
        overlay1.xScale = 1.35; overlay1.yScale = 0.45; overlay1.alpha = 0;
        self.addChild(overlay1); overlay1.run(SKAction.fadeAlpha(to: 0.2, duration: 1.0))
        
        overlay2.position = CGPoint(x:self.frame.midX, y:self.frame.midY-130); overlay2.zPosition = 0.5;
        overlay2.xScale = 1.35; overlay2.yScale = 0.45; overlay2.alpha = 0;
        self.addChild(overlay2); overlay2.run(SKAction.fadeAlpha(to: 0.2, duration: 1.0))
        
        overlay3.position = CGPoint(x:self.frame.midX+285, y: self.frame.midY - 570); overlay3.zPosition = 0.5;
        overlay3.xScale = 0.37; overlay3.yScale = 0.65; overlay3.alpha = 0;
        self.addChild(overlay3); overlay3.run(SKAction.fadeAlpha(to: 0.2, duration: 1.0))
        
        overlay4.position = CGPoint(x:self.frame.midX-285, y: self.frame.midY - 570); overlay4.zPosition = 0.5;
        overlay4.xScale = 0.37; overlay4.yScale = 0.65; overlay4.alpha = 0;
        self.addChild(overlay4); overlay4.run(SKAction.fadeAlpha(to: 0.2, duration: 1.0))
        
        overlay5.position = CGPoint(x:self.frame.midX, y: self.frame.midY - 627); overlay5.zPosition = 0.5;
        overlay5.xScale = 0.37; overlay5.yScale = 0.15; overlay5.alpha = 0;
        self.addChild(overlay5); overlay5.run(SKAction.fadeAlpha(to: 0.2, duration: 1.0))
        
        
        //ADDS ANIMATED MENU SPRITES
        gear.position = CGPoint(x:self.frame.midX + 285, y: self.frame.midY-560);
        gear.alpha = 0; gear.xScale = 0.15; gear.yScale = 0.15; gear.zPosition = 1;
        self.addChild(gear); gear.run(fadeIn); delay (1.0) {self.gear.run(self.wag)}
        
        question.position = CGPoint(x:self.frame.midX - 285, y: self.frame.midY-560)
        question.alpha = 0; question.xScale = 0.15; question.yScale = 0.15; question.zPosition = 1
        self.addChild(question); question.run(fadeIn); delay (1.0) {self.question.run(self.bounce)}
        
        let testPlayerX = SKSpriteNode(imageNamed: "Xeyes"); testPlayerX.xScale = 0.2; testPlayerX.yScale = 0.2;
        let testPlayerO = SKSpriteNode(imageNamed: "Oeyes"); testPlayerO.xScale = 0.2; testPlayerO.yScale = 0.2;
        testPlayerX.position = CGPoint(x:self.frame.midX-20, y: self.frame.midY-215);
        testPlayerO.position = CGPoint(x:self.frame.midX+20, y: self.frame.midY-215);
        self.addChild(testPlayerX); testPlayerX.run(wag); self.addChild(testPlayerO);
        testPlayerX.run(fadeIn); testPlayerO.run(fadeIn)
        delay(0.4) {testPlayerO.run(self.wag)}
        delay(2.0) {testPlayerX.run(self.backAndForth); testPlayerO.run(self.forthAndBack)}
        
        
        
        
        //ADDS PARTICLE EMITTER
        redfx?.position = CGPoint(x: self.frame.midX, y: self.frame.midY+400)
        redfx?.particleAlpha = 0; delay(1.0){self.addChild(self.redfx!); self.redfx?.run(self.fadeIn)}; redfx?.particleZPosition = 1
        
    }
        
    
    //SYSTEM FUNCTION CALLED WHEN A TOUCH EVENT OCCURS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == sPlayer  {
                sPlayer.fontColor  = UIColor.lightGray()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set(1, forKey: "gametype")
                overlay1.run(SKAction.scaleX(to: 1.45, duration: 0.3))
                overlay1.run(SKAction.scaleY(to: 0.55, duration: 0.3))
            }
            if node == mPlayer  {
                mPlayer.fontColor  = UIColor.lightGray()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set(2, forKey: "gametype")
                overlay2.run(SKAction.scaleX(to: 1.45, duration: 0.3))
                overlay2.run(SKAction.scaleY(to: 0.55, duration: 0.3))
                }
            if node == settings {
                settings.fontColor = UIColor.lightGray()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                overlay3.run(SKAction.scaleX(to: 0.4, duration: 0.3))
                overlay3.run(SKAction.scaleY(to: 0.7, duration: 0.3))
                }
            if node == gear {
                settings.fontColor = UIColor.lightGray()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                overlay3.run(SKAction.scaleX(to: 0.4, duration: 0.3))
                overlay3.run(SKAction.scaleY(to: 0.7, duration: 0.3))
            }
            if node == credits  {
                credits.fontColor  = UIColor.lightGray()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                overlay5.run(SKAction.scaleX(to: 0.4, duration: 0.3))
                overlay5.run(SKAction.scaleY(to: 0.2, duration: 0.3))
                }
            if node == help     {
                help.fontColor     = UIColor.lightGray()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                overlay4.run(SKAction.scaleX(to: 0.4, duration: 0.3))
                overlay4.run(SKAction.scaleY(to: 0.7, duration: 0.3))
                }
            if node == question {
                help.fontColor = UIColor.lightGray()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                overlay4.run(SKAction.scaleX(to: 0.4, duration: 0.3))
                overlay4.run(SKAction.scaleY(to: 0.7, duration: 0.3))
            }
        }

    }
    
    //SIMPLE FUNCTION TO CREATE AND ADD AN SKLABELNODE WITH THE DESIRED CHARACTERISTICS
    func setUpLabel(labelName: SKLabelNode, nameOfLabel: String, withText: String, isShadow: Bool, location: CGPoint, sizeOfFont: CGFloat) -> SKLabelNode {
        labelName.text = withText;
        labelName.fontColor = SKColor.darkGray()
        labelName.zPosition = 1
        labelName.fontSize = sizeOfFont;
        if isShadow {
            labelName.fontColor = SKColor.white()
            labelName.zPosition = 0;
        }
        labelName.position = location;
        labelName.alpha = 0;
        self.addChild(labelName); labelName.run(fadeIn)
        
        return labelName;
    }
    
    
    
    //SIMPLE DELAY FUNCTION
    func delay(_ delay:Double, closure:()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.after(when: when, execute: closure)
    }
    
    
    //CALLED WHEN A FINGER STOPS TOUCHING THE SCREEN
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in:self)
            let node = self.atPoint(pos)
            let transitionLeft = SKTransition.reveal(with: SKTransitionDirection.right, duration: 0.80)
            let transitionRight = SKTransition.push(with: SKTransitionDirection.left, duration: 0.80)
            
            if node == sPlayer {
                if let view = view {
                    let scene = GameScene(fileNamed:"GameScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transitionLeft)
                }
            }
        
            if node == mPlayer {
                if let view = view {
                    let scene = GameScene(fileNamed:"GameScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transitionLeft)
                }
            }
            
            if node == settings {
                if let view = view {
                    let scene = SettingsScene(fileNamed: "SettingsScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transitionRight)
                }
            }
            
            if node == gear {
                if let view = view {
                    let scene = SettingsScene(fileNamed: "SettingsScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transitionRight)
                }
            }
            
            
            if node == credits {
                if let view = view {
                    let scene = CreditsScene(fileNamed: "CreditsScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transitionRight)
                }
            }
            
            if node == help {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                if let view = view {
                    let scene = TutorialScene(fileNamed: "TutorialScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transitionRight)
                }
            }
            
            if node == question {
                if let view = view {
                    let scene = TutorialScene(fileNamed: "TutorialScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transitionRight)
                }
            }
            
            
            //RESETS ALL POTENTIALLY TOUCHED OVERLAYS AND LABELS
            overlay1.run(SKAction.scaleX(to: 1.35, duration: 0.3))
            overlay1.run(SKAction.scaleY(to: 0.45, duration: 0.3))
            overlay2.run(SKAction.scaleX(to: 1.35, duration: 0.3))
            overlay2.run(SKAction.scaleY(to: 0.45, duration: 0.3))
            overlay3.run(SKAction.scaleX(to: 0.37, duration: 0.3))
            overlay3.run(SKAction.scaleY(to: 0.65, duration: 0.3))
            overlay4.run(SKAction.scaleX(to: 0.37, duration: 0.3))
            overlay4.run(SKAction.scaleY(to: 0.65, duration: 0.3))
            overlay5.run(SKAction.scaleX(to: 0.37, duration: 0.3))
            overlay5.run(SKAction.scaleY(to: 0.15, duration: 0.3))
            sPlayer.fontColor = UIColor.darkGray()
            mPlayer.fontColor = UIColor.darkGray()
            settings.fontColor = UIColor.darkGray()
            credits.fontColor = UIColor.darkGray()
            help.fontColor = UIColor.darkGray()
            
        }
    }
    
    
    
}
