//
//  ThemeScene.swift
//  X vs O
//
//  Created by Janak Malla on 7/25/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import SpriteKit

class ThemeScene: SKScene {
    
    //Scrollview
    var scrollView: CustomScrollView!
    let moveableNode = SKNode()
    
    
    let defaults = UserDefaults.standard
    var backButton = SKSpriteNode(imageNamed: "arrow")
    var curTheme: String?
    
    var lockTree = SKSpriteNode()
    
    let standardImg = SKSpriteNode(imageNamed: "Xeyes")
    let standardLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName)
    
    let warriorImg = SKSpriteNode(imageNamed: "Xwarrior")
    let warriorLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName)
    let lockWarrior = SKSpriteNode(imageNamed: "lockedItem")
    var lockedWarrior = Bool()
    
    let babyImg = SKSpriteNode(imageNamed: "Xbaby")
    let babyLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName)
    let lockBaby = SKSpriteNode(imageNamed: "lockedItem")
    var lockedBaby = Bool()
    
    let ballerImg = SKSpriteNode(imageNamed: "Xballer")
    let ballerLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName)
    let lockBaller = SKSpriteNode(imageNamed: "lockedItem")
    var lockedBaller = Bool()
    
    let greekImg = SKSpriteNode(imageNamed: "Xgreek")
    let greekLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName)
    let lockGreek = SKSpriteNode(imageNamed: "lockedItem")
    var lockedGreek = Bool()
    
    let plainImg = SKSpriteNode(imageNamed: "X")
    let plainLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName)
    let lockPlain = SKSpriteNode(imageNamed: "lockedItem")
    var lockedPlain = Bool();
    
    var unlock = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.bold).familyName)
    var Selected = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.light).familyName)
    var overlaySelected = SKSpriteNode(imageNamed: "overlay")
    
    let fadeInQuick = SKAction.fadeIn(withDuration: 0.5)
    
    override func didMove(to view: SKView) {
        
        //REAL BACKGROUND
        let bg = SKSpriteNode(imageNamed: "bg")
        bg.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        bg.size = CGSize(width:self.frame.width, height: self.frame.height)
        self.addChild(bg)
        bg.zPosition = -2
        
        
        //Scrollview
        
        addChild(moveableNode)
        
        
        
        
        scrollView = CustomScrollView(frame: CGRect(x: 0, y: 175, width: self.frame.size.width, height: self.frame.size.height+200), moveableNode: moveableNode, scrollDirection: .horizontal)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 3, height: scrollView.frame.size.height)
        view.addSubview(scrollView)
        
        scrollView.setContentOffset(CGPoint(x: 0 + self.frame.size.width * 2, y: 0), animated: true)
        
        
        
        
        let page1ScrollView = SKSpriteNode(color: SKColor.clear, size: CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: self.frame.midX - (self.frame.size.width * 2), y: self.frame.midY)
        moveableNode.addChild(page1ScrollView)
        
        let page2ScrollView = SKSpriteNode(color: SKColor.clear, size: CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height))
        page2ScrollView.position = CGPoint(x: self.frame.midX - (self.frame.size.width), y: self.frame.midY)
        moveableNode.addChild(page2ScrollView)
        
        let page3ScrollView = SKSpriteNode(color: SKColor.clear, size: CGSize(width: scrollView.frame.size.width, height:
            scrollView.frame.size.height))
        page3ScrollView.zPosition = -1
        page3ScrollView.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        moveableNode.addChild(page3ScrollView)
        
        
        
        
        
        /// Test sprites page 2
        let sprite1Page2 = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName)
        sprite1Page2.fontColor = SKColor.darkGray; sprite1Page2.fontSize = 60;
        sprite1Page2.text = "COMING SOON!"
        sprite1Page2.position = CGPoint(x: 0, y: 0)
        page2ScrollView.addChild(sprite1Page2)
        
        
        /// Test sprites page 3
        let sprite1Page3 = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName)
        sprite1Page3.fontColor = SKColor.darkGray; sprite1Page3.fontSize = 50;
        sprite1Page3.text = "Let me know if you have ideas!"
        sprite1Page3.position = CGPoint(x: 0, y: 0)
        page3ScrollView.addChild(sprite1Page3)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let Title = SKSpriteNode(imageNamed: "themesTitle")
        Title.xScale = 3.0; Title.yScale = 3.0; Title.run(SKAction.colorize(with: SKColor.green, colorBlendFactor: 0.5, duration: 0))
        Title.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 500)
        
        
        
        //let Title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightLight).familyName)
        //Title.fontSize = 200; Title.alpha = 0; Title.fontColor = UIColor.darkGray;
        //Title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        //Title.text = "Themes"
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        self.addChild(Title);
        Title.run(fadeIn);
        
        unlock.position = CGPoint(x: self.frame.midX, y: self.frame.midX - 484)
        unlock.alpha = 0; unlock.fontSize = 40; unlock.fontColor = SKColor.darkGray;
        self.addChild(unlock)
        delay(2.0) {self.fadeInfadeOut(self.unlock, textBecomes: "Defeat X-O bot to unlock new themes!")}
        
        backButton.xScale = 1.0; backButton.yScale = 1.0; backButton.alpha = 0;
        backButton.position = CGPoint(x: self.frame.midX - 275, y: self.frame.midY - 550)
        self.addChild(backButton)
        backButton.run(fadeIn)
        
        let scrollButton = SKSpriteNode(imageNamed: "arrow")
        scrollButton.xScale = -0.5; scrollButton.yScale = 0.5; scrollButton.alpha = 0;
        scrollButton.position = CGPoint(x:self.frame.midX + 275, y: self.frame.midY - 300)
        
        let scrollLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold).familyName)
        scrollLabel.position = CGPoint(x:scrollButton.position.x, y: scrollButton.position.y+20)
        scrollLabel.fontColor = SKColor.darkGray; scrollLabel.text = "SCROLL";
        scrollLabel.alpha = 0; scrollLabel.fontSize = 18;
        
        self.addChild(scrollButton); self.addChild(scrollLabel);
        scrollButton.run(fadeIn); scrollLabel.run(fadeIn);
        
        delay(2.0) {
            scrollButton.run(SKAction.repeatForever(SKAction.sequence([fadeIn, SKAction.wait(forDuration: 1.0), fadeOut])))
            scrollLabel.run(SKAction.repeatForever(SKAction.sequence([fadeIn, SKAction.wait(forDuration: 1.0), fadeOut])))
        }
        
        standardLabel.position = CGPoint(x:self.frame.midX - 250, y: self.frame.midY+100); standardLabel.alpha = 0;
        babyLabel.position = CGPoint(x:self.frame.midX + 250, y: self.frame.midY+100); babyLabel.alpha = 0;
        warriorLabel.position = CGPoint(x:self.frame.midX, y: self.frame.midY+100); warriorLabel.alpha = 0;
        babyLabel.text = "Baby"; warriorLabel.text = "Warrior"; standardLabel.text = "Standard"
        ballerLabel.position = CGPoint(x:self.frame.midX - 250, y: self.frame.midY-250); ballerLabel.alpha = 0;
        greekLabel.position = CGPoint(x:self.frame.midX, y: self.frame.midY-250); greekLabel.alpha = 0;
        ballerLabel.text = "Baller"; greekLabel.text = "Greek";
        standardLabel.fontColor = SKColor.darkGray; babyLabel.fontColor = SKColor.darkGray; warriorLabel.fontColor = SKColor.darkGray;
        ballerLabel.fontColor = SKColor.darkGray; greekLabel.fontColor = SKColor.darkGray;
        plainLabel.position = CGPoint(x:self.frame.midX + 250, y: self.frame.midY-250); plainLabel.alpha = 0;
        plainLabel.text = "Plain"; plainLabel.fontColor = SKColor.darkGray;
        
        
        page1ScrollView.addChild(babyLabel); page1ScrollView.addChild(warriorLabel); page1ScrollView.addChild(standardLabel)
        page1ScrollView.addChild(ballerLabel); page1ScrollView.addChild(greekLabel); page1ScrollView.addChild(plainLabel)
        
        
        delay(1.0) {
            self.standardLabel.run(fadeIn)
            self.babyLabel.run(fadeIn)
            self.warriorLabel.run(fadeIn)
            self.ballerLabel.run(fadeIn)
            self.greekLabel.run(fadeIn)
            self.plainLabel.run(fadeIn)
        }
        
        
        warriorImg.xScale = 0.9; warriorImg.yScale = 0.9; warriorImg.alpha = 0;
        babyImg.xScale = 0.9; babyImg.yScale = 0.9; babyImg.alpha = 0;
        standardImg.xScale = 0.9; standardImg.yScale = 0.9; standardImg.alpha = 0;
        warriorImg.position = CGPoint(x: self.frame.midX, y:self.frame.midY+250);
        babyImg.position = CGPoint(x: self.frame.midX + 250, y:self.frame.midY+250);
        standardImg.position = CGPoint(x: self.frame.midX - 250, y:self.frame.midY+250);
        page1ScrollView.addChild(warriorImg); page1ScrollView.addChild(standardImg); page1ScrollView.addChild(babyImg);
        warriorImg.run(fadeIn); babyImg.run(fadeIn); standardImg.run(fadeIn)
        
        ballerImg.xScale = 0.9; ballerImg.yScale = 0.9; ballerImg.alpha = 0;
        greekImg.xScale = 0.9; greekImg.yScale = 0.9; greekImg.alpha = 0;
        ballerImg.position = CGPoint(x: self.frame.midX-250, y:self.frame.midY-100);
        greekImg.position = CGPoint(x: self.frame.midX, y:self.frame.midY-100);
        page1ScrollView.addChild(ballerImg); page1ScrollView.addChild(greekImg);
        ballerImg.run(fadeIn); greekImg.run(fadeIn)
        
        plainImg.xScale = 0.9; plainImg.yScale = 0.9; plainImg.alpha = 0;
        plainImg.position = CGPoint(x: self.frame.midX + 250, y:self.frame.midY-100)
        page1ScrollView.addChild(plainImg); plainImg.run(fadeIn)
        
        
        lockWarrior.xScale = 0.9; lockWarrior.yScale = 0.9; lockWarrior.alpha = 0;
        lockBaby.xScale = 0.9; lockBaby.yScale = 0.9; lockBaby.alpha = 0;
        lockWarrior.position = CGPoint(x: self.frame.midX, y:self.frame.midY+250);
        lockBaby.position = CGPoint(x: self.frame.midX+250, y:self.frame.midY+250);
        lockWarrior.zPosition = 2; lockBaby.zPosition = 2;
        lockBaller.xScale = 0.9; lockBaller.yScale = 0.9; lockBaller.alpha = 0;
        lockGreek.xScale = 0.9; lockGreek.yScale = 0.9; lockGreek.alpha = 0;
        lockPlain.xScale = 0.9; lockPlain.yScale = 0.9; lockPlain.alpha = 0;
        lockBaller.position = CGPoint(x: self.frame.midX-250, y:self.frame.midY-100);
        lockGreek.position = CGPoint(x: self.frame.midX, y:self.frame.midY-100);
        lockPlain.position = CGPoint(x: self.frame.midX+250, y:self.frame.midY-100);
        lockBaller.zPosition = 2; lockGreek.zPosition = 2; lockPlain.zPosition = 2;
        
        let staticLabel = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.semibold).familyName);
        staticLabel.fontSize = 70; staticLabel.position = CGPoint(x: self.frame.midX - 180, y: self.frame.midY - 400)
        staticLabel.fontColor = SKColor.darkGray; staticLabel.text = "selected: "; staticLabel.alpha = 0;
        
        Selected.fontSize = 70; Selected.alpha = 0; Selected.fontColor = UIColor.darkGray;
        Selected.position = CGPoint(x: self.frame.midX + 165, y: self.frame.midY - 400)
        Selected.text = "NONE"
        updateSelected()
        
        overlaySelected.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 380)
        overlaySelected.xScale = 1.55; overlaySelected.yScale = 0.45; overlaySelected.alpha = 0;
        overlaySelected.zPosition = -1.5;
        
        self.addChild(Selected); self.addChild(overlaySelected); self.addChild(staticLabel)
        Selected.run(fadeIn); overlaySelected.run(SKAction.fadeAlpha(to: 0.2, duration: 1)); staticLabel.run(fadeIn)
        
        lockedBaby = defaults.bool(forKey: "babyLock")
        checkIfLocked(lockBaby, lock: lockedBaby, page1ScrollView: page1ScrollView)
        
        lockedWarrior = defaults.bool(forKey: "warriorLock")
        checkIfLocked(lockWarrior, lock: lockedWarrior, page1ScrollView: page1ScrollView)

        lockedBaller = defaults.bool(forKey: "ballerLock")
        checkIfLocked(lockBaller, lock: lockedBaller, page1ScrollView: page1ScrollView)
        
        lockedGreek = defaults.bool(forKey: "greekLock")
        checkIfLocked(lockGreek, lock: lockedGreek, page1ScrollView: page1ScrollView)
        
        lockedPlain = defaults.bool(forKey: "plainLock")
        checkIfLocked(lockPlain, lock: lockedPlain, page1ScrollView: page1ScrollView)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == backButton {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                scrollView?.removeFromSuperview()
                if let view = view {
                    let scene = SettingsScene(fileNamed: "SettingsScene")
                    let transition = SKTransition.crossFade(withDuration: 0.50)
                    scene?.scaleMode = SKSceneScaleMode.fill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
            if node == warriorImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("warrior", forKey: "theme")
                warriorLabel.fontColor = SKColor.white
            }
            
            if node == standardImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("standard", forKey: "theme")
                standardLabel.fontColor = SKColor.white
            }
            
            if node == babyImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("baby", forKey: "theme")
                babyLabel.fontColor = SKColor.white
            }
            
            if node == ballerImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("baller", forKey: "theme")
                ballerLabel.fontColor = SKColor.white
            }
            
            if node == greekImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("greek", forKey: "theme")
                greekLabel.fontColor = SKColor.white
            }
            
            if node == plainImg {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                defaults.set("plain", forKey: "theme")
                plainLabel.fontColor = SKColor.white;
            }
            
            if node == lockWarrior {
                fadeInfadeOut(unlock, textBecomes: "Req: High Score of 5 on \"Hard\"!")
            }
            
            if node == lockBaby {
                fadeInfadeOut(unlock, textBecomes: "Req: Complete the Tutorial!")
            }
            
            if node == lockBaller {
                fadeInfadeOut(unlock, textBecomes: "Req: High Score of 5 on \"Medium\"!")
            }
            
            if node == lockGreek {
                fadeInfadeOut(unlock, textBecomes: "Req: High Score of 5 on \"Easy\"!")
            }
            
            if node == lockPlain {
                fadeInfadeOut(unlock, textBecomes: "Req: Play one multiplayer match!")
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in:self)
            let node = self.atPoint(pos)
            
            if node == warriorImg {
                updateSelected()
            }
            
            if node == standardImg {
                updateSelected()
            }
            
            if node == babyImg {
                updateSelected()
            }
            
            if node == greekImg {
                updateSelected()
            }
            
            if node == ballerImg {
                updateSelected()
            }
            
            if node == plainImg {
                updateSelected()
            }
            
            warriorLabel.fontColor = SKColor.darkGray
            standardLabel.fontColor = SKColor.darkGray
            babyLabel.fontColor = SKColor.darkGray
            greekLabel.fontColor = SKColor.darkGray
            ballerLabel.fontColor = SKColor.darkGray
            plainLabel.fontColor = SKColor.darkGray
            
            
        }
        
    }

    func fadeInfadeOut(_ label: SKLabelNode, textBecomes: String) {
        label.text = textBecomes
        label.run(fadeInQuick)
        delay(3.0) {
            label.run(fadeOut)
        }
    }
    
    
    func updateSelected() {
        Selected.run(titleChange)
        curTheme = defaults.string(forKey: "theme")
        delay(0.8) {
            self.Selected.text = self.curTheme!.uppercased()
        }

    }
    
    func checkIfLocked(_ lockedItem: SKSpriteNode, lock: Bool, page1ScrollView: SKSpriteNode) {
        if (lock == true) {
            page1ScrollView.addChild(lockedItem)
            lockedItem.run(fadeInQuick)
        }
    }
    
    
    
}

