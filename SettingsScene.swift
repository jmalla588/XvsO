//
//  SettingsScene.swift
//  X vs O
//
//  Created by Janak Malla on 6/18/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    
    var backButton = SKSpriteNode(imageNamed: "arrow")
    var themes = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var pNames = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var diff = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var hs = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    
    let diffTree = SKNode()
    let nameTree = SKNode()
    let themeTree = SKNode()
    let hsTree = SKNode()
    
    var easy = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 40, weight: UIFontWeightLight).fontName)
    var med = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 40, weight: UIFontWeightLight).fontName)
    var hard = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 40, weight: UIFontWeightLight).fontName)
    let quickFadeOut = SKAction.fadeAlpha(to: 0, duration: 0.3)
    let quickFadeIn = SKAction.fadeAlpha(to: 1, duration: 0.3)
    
    var checkButton = SKSpriteNode(imageNamed: "checkGray")
    var nameOne = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 80, weight: UIFontWeightUltraLight).fontName)
    var nameTwo = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 80, weight: UIFontWeightUltraLight).fontName)
    let nameOneField = UITextField()
    let nameTwoField = UITextField()
    
    var easyHS = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 40, weight: UIFontWeightLight).fontName)
    var medHS = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 40, weight: UIFontWeightLight).fontName)
    var hardHS = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 40, weight: UIFontWeightLight).fontName)
    
    var diffFadeIn = Bool() //Fixes animation bug on quickly tapping diff->names
    
    override func didMove(to view: SKView) {
        
        let Title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
        Title.fontSize = 200; Title.alpha = 0; Title.fontColor = UIColor.darkGray();
        Title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 400)
        Title.text = "Settings"
        
        let diffString = defaults.string(forKey: "difficulty")
 
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
        self.addChild(Title)
        Title.run(fadeIn)
        
        backButton.xScale = 1.0; backButton.yScale = 1.0; backButton.alpha = 0;
        backButton.position = CGPoint(x: self.frame.midX - 275, y: self.frame.midY - 550)
        
        self.addChild(backButton)
        //backButton.run(SKAction.fadeAlpha(to: 1, duration: 3))
        backButton.run(fadeIn)
        
        themes.text = "Themes"; pNames.text = "Player Names"; diff.text = "CPU Difficulty"; hs.text = "High Scores"
        themes.fontSize = 100; pNames.fontSize = 100; diff.fontSize = 100; hs.fontSize = 100;
        themes.fontColor = UIColor.darkGray(); pNames.fontColor = UIColor.darkGray();
        diff.fontColor = UIColor.darkGray(); hs.fontColor = UIColor.darkGray()
        diff.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        pNames.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)-150)
        themes.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)-300)
        hs.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)-450)
        themes.name = "themes"; pNames.name = "players"; diff.name = "diff"; hs.name = "hs"
        themes.alpha = 0; pNames.alpha = 0; diff.alpha = 0; hs.alpha = 0;
        
        self.addChild(themes); self.addChild(pNames); self.addChild(diff); self.addChild(hs)

        themes.run(fadeIn); pNames.run(fadeIn); diff.run(fadeIn); hs.run(fadeIn)
        
        let gear = SKSpriteNode(imageNamed: "gear")
        gear.xScale = 0.25; gear.yScale = 0.25; gear.alpha = 0;
        gear.position = CGPoint(x: self.frame.midX, y: (self.frame.midY) + 240)
        
        self.addChild(gear)
        
        self.addChild(diffTree)
        self.addChild(nameTree)
        self.addChild(hsTree)
        
        let spin = SKAction.repeatForever(SKAction.rotate(byAngle: 6.2831853, duration: 4.0))
        gear.run(spin)
        gear.run(SKAction.fadeAlpha(to: 1, duration: 3))
        
        //difficulty settings
        easy.text = "EASY"; med.text = "MEDIUM"; hard.text = "HARD"
        easy.fontSize = 40; med.fontSize = 40; hard.fontSize = 40;
        easy.fontColor = UIColor.darkGray(); med.fontColor = UIColor.darkGray(); hard.fontColor = UIColor.darkGray()
        easy.position = (CGPoint(x:self.frame.midX-200, y:self.frame.midY))
        med.position = (CGPoint(x:self.frame.midX, y:self.frame.midY))
        hard.position = (CGPoint(x:self.frame.midX+200, y:self.frame.midY))
        easy.alpha = 0; med.alpha = 0; hard.alpha = 0;
        easy.name = "easy"; med.name = "med"; hard.name = "hard"
        
        if (diffString == "easy") {
            easy.fontColor = UIColor.white()
            med.fontColor = UIColor.darkGray()
            hard.fontColor = UIColor.darkGray()
        } else if (diffString == "hard") {
            easy.fontColor = UIColor.darkGray()
            med.fontColor = UIColor.darkGray()
            hard.fontColor = UIColor.white()
        } else {
            med.fontColor = UIColor.white()
            easy.fontColor = UIColor.darkGray()
            hard.fontColor = UIColor.darkGray()
        }
        
        //name settings
        checkButton.position = (CGPoint(x:self.frame.midX, y: self.frame.midY - 550))
        checkButton.alpha = 0; checkButton.xScale = 0.5; checkButton.yScale = 0.5;
        checkButton.name = "checkButton"
        
        nameOne.fontColor = UIColor.darkGray()
        nameTwo.fontColor = UIColor.darkGray()
        nameOne.text = "Player 1: "
        nameTwo.text = "Player 2: "
        nameOne.position = CGPoint(x:self.frame.midX - 207, y:self.frame.midY + 30)
        nameTwo.position = CGPoint(x:self.frame.midX - 200, y:self.frame.midY - 135)
        nameOne.alpha = 0; nameTwo.alpha = 0;
        nameOne.name = "p1"; nameTwo.name = "p2";
        nameOne.fontSize = 80; nameTwo.fontSize = 80;
        nameOneField.frame = CGRect(x:self.frame.midX+200, y:self.frame.midY+295, width:150, height:60)
        nameTwoField.frame = CGRect(x:self.frame.midX+200, y:self.frame.midY+395, width:150, height:60)
        nameOneField.backgroundColor = SKColor.lightGray()
        nameTwoField.backgroundColor = SKColor.lightGray()
        nameOneField.borderStyle = UITextBorderStyle.roundedRect
        nameTwoField.borderStyle = UITextBorderStyle.roundedRect
        nameOneField.textColor = SKColor.red()
        nameTwoField.textColor = SKColor.blue()
        nameOneField.autocorrectionType = UITextAutocorrectionType.no
        nameTwoField.autocorrectionType = UITextAutocorrectionType.no
        nameOneField.keyboardAppearance = UIKeyboardAppearance.dark
        nameTwoField.keyboardAppearance = UIKeyboardAppearance.dark
        
        let lightRed = SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2)
        let lightBlue = SKColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.2)
        let p1 = AttributedString(string: "Player 1", attributes: [NSForegroundColorAttributeName:lightRed])
        let p2 = AttributedString(string: "Player 2", attributes: [NSForegroundColorAttributeName:lightBlue])
        nameOneField.attributedPlaceholder = p1
        nameTwoField.attributedPlaceholder = p2
        nameOneField.text = defaults.string(forKey: "nameOne")
        nameTwoField.text = defaults.string(forKey: "nameTwo")
        nameOneField.delegate = self
        nameTwoField.delegate = self
        
        diffFadeIn = true; //Stupid animation bug
        
        
        let screenHeight = UIScreen.main().bounds.height
        
        //Moves the UI Textfields manually, as SpriteKit cannot automatically scale to different screen sizes
        switch screenHeight {

        case 568: // 4 inch
            nameOneField.frame = CGRect(x:self.frame.midX+167, y:self.frame.midY+239, width:115, height:45)
            nameTwoField.frame = CGRect(x:self.frame.midX+167, y:self.frame.midY+305, width:115, height:45)
        case 736: // 6+
            nameOneField.frame = CGRect(x:self.frame.midX+200, y:self.frame.midY+308, width:150, height:60)
            nameTwoField.frame = CGRect(x:self.frame.midX+200, y:self.frame.midY+400, width:150, height:60)
        default: //6
            nameOneField.frame = CGRect(x:self.frame.midX+200, y:self.frame.midY+276, width:150, height:52)
            nameTwoField.frame = CGRect(x:self.frame.midX+200, y:self.frame.midY+357, width:150, height:52)
        }
        
        
        
        //HS settings
        let hsEasy = defaults.integer(forKey: "hsEasy")
        let hsMedium = defaults.integer(forKey: "hsMedium")
        let hsHard = defaults.integer(forKey: "hsHard")
        
        easyHS.text = "EASY:  \(hsEasy)"; medHS.text = "MEDIUM:  \(hsMedium)"; hardHS.text = "HARD:  \(hsHard)"
        easyHS.fontSize = 40; medHS.fontSize = 40; hardHS.fontSize = 40;
        easyHS.fontColor = UIColor.darkGray(); medHS.fontColor = UIColor.darkGray(); hardHS.fontColor = UIColor.darkGray()
        easyHS.position = (CGPoint(x:self.frame.midX-250, y:self.frame.midY-450))
        medHS.position = (CGPoint(x:self.frame.midX, y:self.frame.midY-450))
        hardHS.position = (CGPoint(x:self.frame.midX+250, y:self.frame.midY-450))
        easyHS.alpha = 0; medHS.alpha = 0; hardHS.alpha = 0;
        easyHS.name = "easy"; medHS.name = "med"; hardHS.name = "hard"
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currCharCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currCharCount){
            return false
        }
        let newLength = currCharCount + string.characters.count - range.length
        return newLength <= 8
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == backButton {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                if let view = view {
                    let scene = MenuScene(fileNamed: "MenuScene")
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
                
            }
            
            if node == themes {
                themes.fontColor = UIColor.white()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                //comingSoon(thisLabel: themes)
                
                
                
                if let view = view {
                    let scene = ThemeScene(fileNamed: "ThemeScene")
                    let transition = SKTransition.fade(with: SKColor.lightGray(), duration: 0.75)
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
                
                
                
                
            }
            
            if node == pNames {
                pNames.fontColor = UIColor.white()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
            }
            
            if node == diff {
                diff.fontColor = UIColor.white()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
            }
            
            if node == hs {
                hs.fontColor = UIColor.white()
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
            }
            
            if node == easy {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                easy.fontColor = UIColor.white();
                med.fontColor = UIColor.darkGray();
                hard.fontColor = UIColor.darkGray();
                defaults.set("easy", forKey: "difficulty")
            }
            
            if node == med {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                easy.fontColor = UIColor.darkGray()
                med.fontColor = UIColor.white()
                hard.fontColor = UIColor.darkGray()
                defaults.set("medium", forKey: "difficulty")
            }
            
            if node == hard {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                easy.fontColor = UIColor.darkGray()
                med.fontColor = UIColor.darkGray()
                hard.fontColor = UIColor.white()
                defaults.set("hard", forKey: "difficulty")
            }
            
            if node == checkButton {
                self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                checkButton.texture = SKTexture(imageNamed: "checkWhite")
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
                setName()
            }
            
            if node == diff {
                diff.fontColor = UIColor.darkGray()
                setDiff()
            }
            
            if node == hs {
                hs.fontColor = UIColor.darkGray()
                viewHighScores()
            }
            
            if node == checkButton {
                checkButton.texture = SKTexture(imageNamed: "checkGray")
                saveNames()
                fadeInSettings()
                diffFadeIn = true
            }
            
        }

    }
    
    //
    
    func saveNames() {
        defaults.set(nameOneField.text, forKey: "nameOne")
        defaults.set(nameTwoField.text, forKey: "nameTwo")
    }

    //Called when checkmark is pressed and released
    
    func fadeInSettings() {
        
        let delayTimeHalf = DispatchTime.now() + 0.5
        
        checkButton.run(quickFadeOut)
        nameOne.run(quickFadeOut)
        nameTwo.run(quickFadeOut)
        nameOneField.removeFromSuperview()
        nameTwoField.removeFromSuperview()
        
        DispatchQueue.main.after(when: delayTimeHalf) {
            self.nameTree.removeAllChildren()
            self.pNames.run(self.quickFadeIn)
            self.diff.run(self.quickFadeIn)
            self.themes.run(self.quickFadeIn)
            self.hs.run(self.quickFadeIn)
            self.backButton.run(self.quickFadeIn)
        }
        
    }
    
    //Called when Player Names is selected
    
    func setName() {
        
        diffFadeIn = false; //fixes animation bug
        
        let delayTimeHalf = DispatchTime.now() + 0.5
        
        pNames.run(quickFadeOut)
        themes.run(quickFadeOut)
        diff.run(quickFadeOut)
        hs.run(quickFadeOut)
        backButton.run(quickFadeOut)
        
        easy.run(quickFadeOut)
        med.run(quickFadeOut)
        hard.run(quickFadeOut)
        diffTree.run(quickFadeOut)
        hsTree.run(quickFadeOut)
        
        nameTree.addChild(checkButton)
        nameTree.addChild(nameOne)
        nameTree.addChild(nameTwo)
        
        
        DispatchQueue.main.after(when: delayTimeHalf) {
            self.checkButton.run(self.quickFadeIn)
            self.nameOne.run(self.quickFadeIn)
            self.nameTwo.run(self.quickFadeIn)
            self.view!.addSubview(self.nameOneField)
            self.view!.addSubview(self.nameTwoField)
        }
        
        
    }
    
    
    
    func setDiff() {
        
        diff.run(quickFadeOut)
        diffTree.addChild(easy)
        diffTree.addChild(med)
        diffTree.addChild(hard)
        
        let delayTime3 = DispatchTime.now() + 3
        let delayTimeHalf = DispatchTime.now() + 0.5
        let delayTime4 = DispatchTime.now() + 3.7
        
        DispatchQueue.main.after(when: delayTimeHalf) {
            if self.diffFadeIn {
                self.diffTree.run(self.quickFadeIn)
                self.easy.run(self.quickFadeIn)
                self.med.run(self.quickFadeIn)
                self.hard.run(self.quickFadeIn)
                
            }
        }

        DispatchQueue.main.after(when: delayTime3) {
            self.easy.run(self.quickFadeOut)
            self.med.run(self.quickFadeOut)
            self.hard.run(self.quickFadeOut)
            self.diffTree.run(self.quickFadeOut)
            
            DispatchQueue.main.after(when: delayTime4) {
                if self.diffFadeIn {self.diff.run(self.quickFadeIn) }
                self.diffTree.removeAllChildren()
            }
            
        }
        
    }
    
    
    func viewHighScores() {
        
        hs.run(quickFadeOut)
        hsTree.addChild(easyHS)
        hsTree.addChild(medHS)
        hsTree.addChild(hardHS)
        
        let delayTime3 = DispatchTime.now() + 3
        let delayTimeHalf = DispatchTime.now() + 0.5
        let delayTime4 = DispatchTime.now() + 3.7
        
        DispatchQueue.main.after(when: delayTimeHalf) {
            if self.diffFadeIn {
                self.hsTree.run(self.quickFadeIn)
                self.easyHS.run(self.quickFadeIn)
                self.medHS.run(self.quickFadeIn)
                self.hardHS.run(self.quickFadeIn)

            }
        }
        
        DispatchQueue.main.after(when: delayTime3) {
            self.easyHS.run(self.quickFadeOut)
            self.medHS.run(self.quickFadeOut)
            self.hardHS.run(self.quickFadeOut)
            self.hsTree.run(self.quickFadeOut)
            DispatchQueue.main.after(when: delayTime4) {
                if self.diffFadeIn {self.hs.run(self.quickFadeIn) }
                self.hsTree.removeAllChildren()
            }
            
        }
        
    }
    
    
    
    
    func comingSoon(thisLabel: SKLabelNode) {
        let origText = thisLabel.text
        
        if diffFadeIn {
            thisLabel.run(quickFadeOut)
            delay(0.5) {
                thisLabel.text = "Coming Soon!"
                thisLabel.fontColor = SKColor.white()
                if self.diffFadeIn {thisLabel.run(self.quickFadeIn) }

            }
            delay(3.0) {
                thisLabel.run(self.quickFadeOut)
            }
            delay(3.7) {
                thisLabel.text = origText
                thisLabel.fontColor = SKColor.darkGray()
                if self.diffFadeIn {thisLabel.run(self.quickFadeIn)}
            }
        }
    }
    
    func delay(_ delay:Double, closure:()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.after(when: when, execute: closure)
    }
    
    
    
    
    
}
