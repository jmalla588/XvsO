//
//  GameScene.swift
//  GameTestSprite
//
//  Created by Janak Malla on 6/14/16.
//  Copyright (c) 2016 Janak Malla. All rights reserved.
//

import SpriteKit

var turn = 0

let Title = SKLabelNode(fontNamed:"Avenir")

/* Create a 9 member array, to match with each spot in the hash table.
 e.g         0   |   1   |   2
            -------------------
             3   |   4   |   5
            -------------------
             6   |   7   |   8         0 = empty, 1 = x, 2 = o     */
var myArr = [Int](repeating: 0, count: 9)
let fadeIn = SKAction.fadeIn(withDuration: 1)

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        restart(self: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
            let location = touch.location(in: self)
            var isX = Bool()
            let retry = SKSpriteNode(imageNamed:"retry")
            let again = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 100, weight: UIFontWeightUltraLight).fontName)
            again.text = "Try again?"; again.position = CGPoint(x: self.frame.midX*1.11, y:self.frame.midY*0.11);
            let touchedNode = self.atPoint(location)
            
            if let name = touchedNode.name {
                if name == "retry" {
                    restart (self: self)
                }
                if name == "back" {
                    if let view = view {
                        let scene = MenuScene(fileNamed:"MenuScene")
                        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.75)
                        scene?.scaleMode = SKSceneScaleMode.aspectFill
                        view.presentScene(scene!, transition: transition)
                    }
                }
            }


            var sprite = SKSpriteNode()
            var winner = 0
            
            
            if (turn % 2 == 0) {
                sprite = SKSpriteNode(imageNamed:"X")
                isX = true
            } else {
                sprite = SKSpriteNode(imageNamed:"O")
                isX = false
            }
            
            sprite.alpha = 0.0
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            let col = getColumn(location, self: self)
            let row = getRow(location, self: self)
            
            //Stop if touch was in an invalid location.
            if (col == -1 || row == -1) {return}
            
            var xPoint = CGFloat(1.0)
            var yPoint = CGFloat(1.0)
            
            if (col == 0) {xPoint = 0.73}
            if (col == 2) {xPoint = 1.27}
            
            if (row == 0) {yPoint = 1.4}
            if (row == 2) {yPoint = 0.6}
            
            if (myArr[((3*row) + col)] == 0) {                          //Only add new Sprite if spot is empty
                sprite.position = CGPoint(x:self.frame.midX*xPoint, y:self.frame.midY*yPoint)
                self.addChild(sprite)
                let fadeIn = SKAction.fadeIn(withDuration: 0.50)

                sprite.run(fadeIn)
            }
            
            //Add appropriate player value to array
            if (isX)    {myArr[((3*row) + col)] = 1}
            if (!isX)   {myArr[((3*row) + col)] = 2}
            
            winner = checkForWin(myArr: myArr)
            
            if winner != 0 {
                
                let fadeIn1 = SKAction.fadeIn(withDuration: 1)
                let fadeOut1 = SKAction.fadeOut(withDuration:1)
                let wait = SKAction.wait(forDuration: 1)
                let waitTiny = SKAction.wait(forDuration: 0.1)
                
                let winLine = findWinningLine(myArr: myArr)
                drawWinLine(lineNum: winLine, self: self)
                
                Title.text = "Player " + String(winner) + " wins!"
                retry.position = CGPoint(x: self.frame.midX*1.335, y: self.frame.midY*0.15)
                retry.alpha = 0.0; retry.xScale = 0.6; retry.yScale = 0.6; retry.name = "retry"
                self.addChild(retry)
                retry.run(SKAction.sequence([wait, SKAction.repeatForever(SKAction.sequence([fadeIn1, waitTiny, fadeOut1]))]))
                
            } else if (checkForDraw(myArr: myArr)){
                
                let fadeIn1 = SKAction.fadeIn(withDuration: 1)
                let fadeOut1 = SKAction.fadeOut(withDuration:1)
                let wait = SKAction.wait(forDuration: 1)
                let waitTiny = SKAction.wait(forDuration:0.1)
                
                Title.text = "Draw"
                retry.position = CGPoint(x: self.frame.midX*1.335, y: self.frame.midY*0.15)
                retry.alpha = 0.0; retry.xScale = 0.6; retry.yScale = 0.6; retry.name = "retry"
                self.addChild(retry)
                retry.run(SKAction.sequence([wait, SKAction.repeatForever(SKAction.sequence([fadeOut1, waitTiny, fadeIn1]))]))

            }
            
            turn += 1
            
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}


//Gets column of touch in 3x3 plot
func getColumn(_ location: CGPoint, self: GameScene) -> Int {
    if (location.x < self.frame.midX*0.87 &&
        location.x > self.frame.midX*0.63) {
        return 0;
    } else if (location.x > self.frame.midX*0.89 &&
        location.x < self.frame.midX*1.12) {
        return 1;
    } else if (location.x > self.frame.midX*1.14 &&
        location.x < self.frame.midX*1.38) {
        return 2;
    }
    return -1;
}


//Gets Row of touch in 3x3 plot
func getRow(_ location: CGPoint, self: GameScene) -> Int {
    if (location.y < self.frame.midY*1.55 &&
        location.y > self.frame.midY*1.20) {
        return 0;
    } else if (location.y > self.frame.midY*0.81 &&
        location.y < self.frame.midY*1.18) {
        return 1;
    } else if (location.y > self.frame.midY*0.43 &&
        location.y < self.frame.midY*0.79) {
        return 2;
    }
    return -1;
}


//Check for gameWin
func checkForWin(myArr: [Int]) -> Int {

    if turn < 3 {return 0}

    if ((myArr[0] != 0) || (myArr[4] != 0) || (myArr[8] != 0)) {
        if (myArr[0] == myArr[1] && myArr[1] == myArr[2] && myArr[2] != 0) ||
           (myArr[0] == myArr[3] && myArr[3] == myArr[6] && myArr[6] != 0) ||
           (myArr[0] == myArr[4] && myArr[4] == myArr[8] && myArr[8] != 0) {
            return myArr[0]
        }
        
        else if (myArr[4] == myArr[0] && myArr[0] == myArr[8]) ||
           (myArr[4] == myArr[1] && myArr[1] == myArr[7] && myArr[7] != 0) ||
           (myArr[4] == myArr[6] && myArr[6] == myArr[2] && myArr[2] != 0) ||
           (myArr[4] == myArr[3] && myArr[3] == myArr[5] && myArr[5] != 0) {
            return myArr[4]
        }
        
        else if (myArr[8] == myArr[4] && myArr[4] == myArr[0]) ||
           (myArr[8] == myArr[2] && myArr[2] == myArr[5] && myArr[5] != 0) ||
           (myArr[8] == myArr[6] && myArr[6] == myArr[7] && myArr[7] != 0) {
            return myArr[8]
        }
    }

return 0
}


/*
 WinLines
 
 0   |   1   |   2
 -------------------
 3   |   4   |   5
 -------------------
 6   |   7   |   8
 
 WinLine1 = 012
 WinLine2 = 345
 WinLine3 = 678
 WinLine4 = 036
 WinLine5 = 147
 WinLine6 = 258
 WinLine7 = 048
 WinLine8 = 246
 
 
 */
func findWinningLine(myArr: [Int]) -> Int {
    
    //WinLine1
    if (myArr[0] == myArr[1] && myArr[1] == myArr[2] && myArr[2] != 0) {
        return 1;
    }
    
    //WinLine2
    if (myArr[3] == myArr[4] && myArr[4] == myArr[5] && myArr[5] != 0) {
        return 2;
    }
    
    //WinLine3
    if (myArr[6] == myArr[7] && myArr[7] == myArr[8] && myArr[8] != 0) {
        return 3;
    }
    
    //WinLine4
    if (myArr[0] == myArr[3] && myArr[3] == myArr[6] && myArr[6] != 0) {
        return 4;
    }
    
    //WinLine5
    if (myArr[1] == myArr[4] && myArr[4] == myArr[7] && myArr[7] != 0) {
        return 5;
    }
    
    //WinLine6
    if (myArr[2] == myArr[5] && myArr[5] == myArr[8] && myArr[8] != 0) {
        return 6;
    }
    
    //WinLine7
    if (myArr[0] == myArr[4] && myArr[4] == myArr[8] && myArr[8] != 0) {
        return 7;
    }
    
    //WinLine8
    if (myArr[2] == myArr[4] && myArr[4] == myArr[6] && myArr[6] != 0) {
        return 8;
    }
    
    return 0;
}

func drawWinLine(lineNum: Int, self: GameScene) {
    let line = SKSpriteNode(imageNamed: "line")
    line.alpha = 0
    line.zPosition = 2
    line.xScale = 0.15
    line.yScale = 1.05

    
    let rotate90 = SKAction.rotate(byAngle: 1.57079632, duration: 0)
    let rotate45 = SKAction.rotate(byAngle: 0.70539816, duration: 0)
    let rotate45ish = SKAction.rotate(byAngle: 0.87839816, duration: 0)
    
    if lineNum == 1 {
        line.position = CGPoint(x:self.frame.midX, y:self.frame.midY*1.4)
        line.run(rotate90)
    }
    
    if lineNum == 2 {
        line.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        line.run(rotate90)
    }
    
    if lineNum == 3 {
        line.position = CGPoint(x:self.frame.midX, y:self.frame.midY*0.6)
        line.run(rotate90)
    }
    
    if lineNum == 4 {
        line.position = CGPoint(x:self.frame.midX*0.73, y:self.frame.midY)
    }
    
    if lineNum == 5 {
        line.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
    }
    
    if lineNum == 6 {
        line.position = CGPoint(x:self.frame.midX*1.27, y:self.frame.midY)
    }
    
    if lineNum == 7 {
        line.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        line.run(rotate45)
        line.yScale = 1.15
    }
    
    if lineNum == 8 {
        line.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        line.run(rotate90)
        line.run(rotate45ish)
        line.yScale = 1.15
    }
    
    self.addChild(line)
    line.run(fadeIn)
}


func createSceneContents(self: GameScene) {
    
    self.backgroundColor = UIColor.lightGray()
    
    Title.text = "Tic Tac Toe!"
    Title.fontSize = 60; Title.alpha = 0;
    Title.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)/4)
    
    self.addChild(Title)
    Title.run(fadeIn)
    
    let map = SKSpriteNode(imageNamed:"Hash")
    map.xScale = 0.6
    map.yScale = 0.6
    map.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    map.alpha = 0;
    
    self.addChild(map)
    map.run(fadeIn)
    
    let PlayerIndicator1 = SKLabelNode(fontNamed:"Avenir")
    let PlayerIndicator2 = SKLabelNode(fontNamed:"Avenir")
    PlayerIndicator1.text = "Player 1: "
    PlayerIndicator2.text = "Player 2: "
    PlayerIndicator1.fontSize = 15; PlayerIndicator1.alpha = 0;
    PlayerIndicator2.fontSize = 15; PlayerIndicator2.alpha = 0;
    PlayerIndicator1.fontColor = UIColor.darkGray();
    PlayerIndicator2.fontColor = UIColor.darkGray();
    PlayerIndicator1.position = CGPoint(x:self.frame.midX*0.7, y:(self.frame.midY)*1.75)
    PlayerIndicator2.position = CGPoint(x:self.frame.midX*1.2, y:(self.frame.midY)*1.75)
    
    self.addChild(PlayerIndicator1)
    self.addChild(PlayerIndicator2)
    PlayerIndicator1.run(fadeIn); PlayerIndicator2.run(fadeIn)
    
    let x = SKSpriteNode(imageNamed:"X")
    let o = SKSpriteNode(imageNamed:"O")
    x.xScale = 0.1; x.yScale = 0.1; o.xScale = 0.1; o.yScale = 0.1;
    x.position = CGPoint(x:self.frame.midX*0.8, y:(self.frame.midY)*1.77)
    o.position = CGPoint(x:self.frame.midX*1.3, y:(self.frame.midY)*1.77)
    x.alpha = 0; o.alpha = 0;
    
    self.addChild(x)
    self.addChild(o)
    x.run(fadeIn); o.run(fadeIn)
    
    let back = SKSpriteNode(imageNamed:"arrow")
    back.xScale = 0.6; back.yScale = 0.6; back.name = "back"; back.alpha = 0;
    back.position = CGPoint(x:self.frame.midX*0.69, y: self.frame.midY*0.15)
    
    self.addChild(back)
    back.run(fadeIn)
}

func restart(self: GameScene) {
    self.removeAllChildren()
    self.removeAllActions()
    
    for i in 0...8 {
        myArr[i] = 0
    }
    
    createSceneContents(self: self)
}

func checkForDraw(myArr: [Int]) -> Boolean {
    for i in 0...8 {
        if myArr[i] == 0 {return false}
    }
    return true
}
