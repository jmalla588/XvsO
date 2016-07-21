//
//  MenuScene.swift
//  X vs O
//
//  Created by Janak Malla on 6/16/16.
//  Copyright © 2016 Janak Malla. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "play")
    var sPlayer = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var mPlayer = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var settings = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var credits = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var help = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
    var redfx = SKEmitterNode(fileNamed: "TestParticle.sks")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "launchnocopy")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        addChild(background)
        background.zPosition = -1
        
        let slideOutBG = SKAction.move(by: CGVector(dx: 0, dy: 400), duration: 0.75)
        background.run(slideOutBG)

        sPlayer.text = "1 Player"; mPlayer.text = "2 Player"; settings.text = "Settings"; credits.text = "Credits"; help.text = "Tutorial"
        sPlayer.fontSize = 100; mPlayer.fontSize = 100; settings.fontSize = 100; credits.fontSize = 100; help.fontSize = 100;
        sPlayer.fontColor = UIColor.darkGray(); mPlayer.fontColor = UIColor.darkGray();
        settings.fontColor = UIColor.darkGray(); credits.fontColor = UIColor.darkGray();
        help.fontColor = UIColor.darkGray();
        sPlayer.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        mPlayer.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)-150)
        settings.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)-300)
        help.position = CGPoint(x: self.frame.midX, y:(self.frame.midY)-450)
        credits.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)-600)
        sPlayer.name = "1"; mPlayer.name = "2"; settings.name = "settings"; credits.name = "credits"; help.name = "help"
        sPlayer.alpha = 0; mPlayer.alpha = 0; settings.alpha = 0; credits.alpha = 0; help.alpha = 0;
        sPlayer.zPosition = 1;
        
        self.addChild(sPlayer); self.addChild(mPlayer); self.addChild(settings); self.addChild(credits); self.addChild(help);
        

        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        sPlayer.run(fadeIn); mPlayer.run(fadeIn); settings.run(fadeIn); credits.run(fadeIn); help.run(fadeIn);
        
        
        redfx?.position = CGPoint(x: self.frame.midX, y: self.frame.midY+400)
        redfx?.particleAlpha = 0;
        redfx?.run(fadeIn)
        
        self.addChild(redfx!);
        redfx?.particleZPosition = -1
        
    }
        
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)

            
            if node == sPlayer {
                sPlayer.fontColor = UIColor.white()
            }
            
            if node == mPlayer {
                mPlayer.fontColor = UIColor.white()
            }
            
            if node == settings {
                settings.fontColor = UIColor.white()
            }
            
            if node == credits {
                credits.fontColor = UIColor.white()
            }
            
            if node == help {
                help.fontColor = UIColor.white()
            }
            
        }

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pos = touch.location(in:self)
            let node = self.atPoint(pos)
            let transition = SKTransition.fade(with: UIColor.lightGray(), duration: 0.50)
            
            
            if node == sPlayer {
                sPlayer.fontColor = UIColor.darkGray()
                if let view = view {
                    let scene = GameScene(fileNamed:"GameScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
            if node == mPlayer {
                mPlayer.fontColor = UIColor.darkGray()
                if let view = view {
                    let scene = GameScene(fileNamed:"GameScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
            if node == settings {
                settings.fontColor = UIColor.darkGray()
                if let view = view {
                    let scene = SettingsScene(fileNamed: "SettingsScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
            if node == credits {
                credits.fontColor = UIColor.darkGray()
                if let view = view {
                    let scene = CreditsScene(fileNamed: "CreditsScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
            if node == help {
                help.fontColor = UIColor.darkGray()
                if let view = view {
                    let scene = TutorialScene(fileNamed: "TutorialScene")
                    scene?.scaleMode = SKSceneScaleMode.aspectFill
                    view.presentScene(scene!, transition: transition)
                }
            }
            
        }
    }
    
    
    
}
