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
    var curTheme: String?
    
    var lockTree = SKSpriteNode()
    
    let standardImg = SKSpriteNode(imageNamed: "X")
    let standardLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFontWeightLight).fontName)
    
    let warriorImg = SKSpriteNode(imageNamed: "Xwarrior")
    let warriorLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFontWeightLight).fontName)
    let lockWarrior = SKSpriteNode(imageNamed: "lockedItem")
    var lockedWarrior = Bool()
    
    let babyImg = SKSpriteNode(imageNamed: "Xbaby")
    let babyLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFontWeightLight).fontName)
    let lockBaby = SKSpriteNode(imageNamed: "lockedItem")
    var lockedBaby = Bool()
    
    let ballerImg = SKSpriteNode(imageNamed: "Xballer")
    let ballerLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFontWeightLight).fontName)
    let lockBaller = SKSpriteNode(imageNamed: "lockedItem")
    var lockedBaller = Bool()
    
    let greekImg = SKSpriteNode(imageNamed: "Xgreek")
    let greekLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFontWeightLight).fontName)
    let lockGreek = SKSpriteNode(imageNamed: "lockedItem")
    var lockedGreek = Bool()
    
    var unlock = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFontWeightBold).fontName)
    var Selected = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFontWeightUltraLight).fontName)
    
    let fadeInQuick = SKAction.fadeIn(withDuration: 0.5)
    
    override func didMove(to view: SKView) {
        
        let Title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
        Title.fontSize = 200; Title.alpha = 0; Title.fontColor = UIColor.darkGray();
        Title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        Title.text = "Themes"
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        self.addChild(Title);
        Title.run(fadeIn);
        
        unlock.position = CGPoint(x: self.frame.midX, y: self.frame.midX - 484)
        unlock.alpha = 0; unlock.fontSize = 40; unlock.fontColor = SKColor.darkGray();
        self.addChild(unlock)
        delay(2.0) {self.fadeInfadeOut(label: self.unlock, textBecomes: "Defeat X-O bot to unlock new themes!")}
        
        backButton.xScale = 1.0; backButton.yScale = 1.0; backButton.alpha = 0;
        backButton.position = CGPoint(x: self.frame.midX - 275, y: self.frame.midY - 550)
        self.addChild(backButton)
        backButton.run(fadeIn)
        
        standardLabel.position = CGPoint(x:self.frame.midX - 250, y: self.frame.midY+100); standardLabel.alpha = 0;
        babyLabel.position = CGPoint(x:self.frame.midX + 250, y: self.frame.midY+100); babyLabel.alpha = 0;
        warriorLabel.position = CGPoint(x:self.frame.midX, y: self.frame.midY+100); warriorLabel.alpha = 0;
        babyLabel.text = "Baby"; warriorLabel.text = "Warrior"; standardLabel.text = "Standard"
        ballerLabel.position = CGPoint(x:self.frame.midX - 250, y: self.frame.midY-250); ballerLabel.alpha = 0;
        greekLabel.position = CGPoint(x:self.frame.midX, y: self.frame.midY-250); greekLabel.alpha = 0;
        ballerLabel.text = "Baller"; greekLabel.text = "Greek";
        
        
        self.addChild(babyLabel); self.addChild(warriorLabel); self.addChild(standardLabel)
        self.addChild(ballerLabel); self.addChild(greekLabel);
        
        
        delay(1.0) {
            self.standardLabel.run(fadeIn)
            self.babyLabel.run(fadeIn)
            self.warriorLabel.run(fadeIn)
            self.ballerLabel.run(fadeIn)
            self.greekLabel.run(fadeIn)
        }
        
        
        warriorImg.xScale = 0.9; warriorImg.yScale = 0.9; warriorImg.alpha = 0;
        babyImg.xScale = 0.9; babyImg.yScale = 0.9; babyImg.alpha = 0;
        standardImg.xScale = 0.9; standardImg.yScale = 0.9; standardImg.alpha = 0;
        warriorImg.position = CGPoint(x: self.frame.midX, y:self.frame.midY+250);
        babyImg.position = CGPoint(x: self.frame.midX + 250, y:self.frame.midY+250);
        standardImg.position = CGPoint(x: self.frame.midX - 250, y:self.frame.midY+250);
        self.addChild(warriorImg); self.addChild(standardImg); self.addChild(babyImg);
        warriorImg.run(fadeIn); babyImg.run(fadeIn); standardImg.run(fadeIn)
        
        ballerImg.xScale = 0.9; ballerImg.yScale = 0.9; ballerImg.alpha = 0;
        greekImg.xScale = 0.9; greekImg.yScale = 0.9; greekImg.alpha = 0;
        ballerImg.position = CGPoint(x: self.frame.midX-250, y:self.frame.midY-100);
        greekImg.position = CGPoint(x: self.frame.midX, y:self.frame.midY-100);
        self.addChild(ballerImg); self.addChild(greekImg);
        ballerImg.run(fadeIn); greekImg.run(fadeIn)
        
        
        lockWarrior.xScale = 0.9; lockWarrior.yScale = 0.9; lockWarrior.alpha = 0;
        lockBaby.xScale = 0.9; lockBaby.yScale = 0.9; lockBaby.alpha = 0;
        lockWarrior.position = CGPoint(x: self.frame.midX, y:self.frame.midY+250);
        lockBaby.position = CGPoint(x: self.frame.midX+250, y:self.frame.midY+250);
        lockWarrior.zPosition = 2; lockBaby.zPosition = 2;
        lockBaller.xScale = 0.9; lockBaller.yScale = 0.9; lockBaller.alpha = 0;
        lockGreek.xScale = 0.9; lockGreek.yScale = 0.9; lockGreek.alpha = 0;
        lockBaller.position = CGPoint(x: self.frame.midX-250, y:self.frame.midY-100);
        lockGreek.position = CGPoint(x: self.frame.midX, y:self.frame.midY-100);
        lockBaller.zPosition = 2; lockGreek.zPosition = 2;
        
        
        Selected.fontSize = 70; Selected.alpha = 0; Selected.fontColor = UIColor.darkGray();
        Selected.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 400)
        Selected.text = "Select a Theme"
        updateSelected()
        
        self.addChild(Selected)
        Selected.run(fadeIn)
        
        lockedBaby = defaults.bool(forKey: "babyLock")
        checkIfLocked(lockedItem: lockBaby, lock: lockedBaby)
        
        lockedWarrior = defaults.bool(forKey: "warriorLock")
        checkIfLocked(lockedItem: lockWarrior, lock: lockedWarrior)

        lockedBaller = defaults.bool(forKey: "ballerLock")
        checkIfLocked(lockedItem: lockBaller, lock: lockedBaller)
        
        lockedGreek = defaults.bool(forKey: "greekLock")
        checkIfLocked(lockedItem: lockGreek, lock: lockedGreek)
        
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
            
            if node == warriorImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("warrior", forKey: "theme")
                warriorLabel.fontColor = SKColor.darkGray()
            }
            
            if node == standardImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("standard", forKey: "theme")
                standardLabel.fontColor = SKColor.darkGray()
            }
            
            if node == babyImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("baby", forKey: "theme")
                babyLabel.fontColor = SKColor.darkGray()
            }
            
            if node == ballerImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("baller", forKey: "theme")
                babyLabel.fontColor = SKColor.darkGray()
            }
            
            if node == greekImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("greek", forKey: "theme")
                babyLabel.fontColor = SKColor.darkGray()
            }
            
            if node == lockWarrior {
                fadeInfadeOut(label: unlock, textBecomes: "Req: High Score of 5 on \"Hard\"!")
            }
            
            if node == lockBaby {
                fadeInfadeOut(label: unlock, textBecomes: "Req: Complete the Tutorial!")
            }
            
            if node == lockBaller {
                fadeInfadeOut(label: unlock, textBecomes: "Req: High Score of 5 on \"Medium\"!")
            }
            
            if node == lockGreek {
                fadeInfadeOut(label: unlock, textBecomes: "Req: High Score of 5 on \"Easy\"!")
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in:self)
            let node = self.atPoint(pos)
            
            if node == warriorImg {
                warriorLabel.fontColor = SKColor.white()
                updateSelected()
            }
            
            if node == standardImg {
                standardLabel.fontColor = SKColor.white()
                updateSelected()
            }
            
            if node == babyImg {
                babyLabel.fontColor = SKColor.white()
                updateSelected()
            }
            
            if node == greekImg {
                greekLabel.fontColor = SKColor.white()
                updateSelected()
            }
            
            if node == ballerImg {
                ballerLabel.fontColor = SKColor.white()
                updateSelected()
            }
            
            updateSelected()
            
        }
        
    }

    func fadeInfadeOut(label: SKLabelNode, textBecomes: String) {
        label.text = textBecomes
        label.run(fadeInQuick)
        delay(3.0) {
            label.run(fadeOut)
        }
    }
    
    
    func updateSelected() {
        curTheme = defaults.string(forKey: "theme")
        
        Selected.text = curTheme!.capitalized + " theme selected"

    }
    
    func checkIfLocked(lockedItem: SKSpriteNode, lock: Bool) {
        if (lock == true) {
            self.addChild(lockedItem)
            lockedItem.run(fadeInQuick)
        }
    }
    
    
    
}

