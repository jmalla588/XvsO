//
//  OnlineScene.swift
//  GameTestSprite
//
//  Created by Janak Malla on 6/7/17.
//  Copyright (c) 2016 Janak Malla. All rights reserved.
//

import SpriteKit
import GameKit

//var turn = 0
var myTurn = true
//var gameOver = Bool()
//let Title = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 60, weight: UIFontWeightSemibold).fontName)
//let TitleShadow = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 60, weight: UIFontWeightSemibold).fontName)
//defaults = UserDefaults.standard
//var myArr = [Int](repeating: 0, count: 9)
//let fadeIn = SKAction.fadeIn(withDuration: 1)
//let fadeOut = SKAction.fadeOut(withDuration: 1)
//let wait = SKAction.wait(forDuration: 1)
//let waitTiny = SKAction.wait(forDuration:0.1)
//let delayTimeHalf = DispatchTime.now() + 1.0
//var gameType = defaults.integer(forKey: "gametype")
//var difficulty = defaults.string(forKey: "difficulty")
//var p1Key = defaults.string(forKey: "nameOne")
//var p2Key = defaults.string(forKey: "nameTwo")
//var score1 = 0
//var score2 = 0
//var totalGamesSP = defaults.integer(forKey: "totalGamesSP")
//var totalGamesMP = defaults.integer(forKey: "totalGamesMP")
//var hsEasy: Int?
//var hsMedium: Int?
//var hsHard: Int?
//var theme: String?
//var scoreOneLabel = SKLabelNode();
//var scoreTwoLabel = SKLabelNode();
//var scoreOneLabelShadow = SKLabelNode();
//var scoreTwoLabelShadow = SKLabelNode();
//var x = SKSpriteNode();
//var o = SKSpriteNode();
//var winner = 0;
//let wag = SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: 0.2, duration: 0.3),
//                                                    SKAction.rotate(byAngle: -0.4, duration: 0.6),
//                                                    SKAction.rotate(byAngle: 0.2, duration: 0.3)]))
//let titleChange = SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.2), SKAction.scale(to: 0.05, duration: 0.5), SKAction.wait(forDuration: 0.2), SKAction.scale(to: 1.1, duration: 0.5), SKAction.scale(to: 1.0, duration: 0.1)])


/* Create a 9 member array, to match with each spot in the hash table. e.g:
 
 0   |   1   |   2
 -------------------
 3   |   4   |   5
 -------------------
 6   |   7   |   8         0 = empty, 1 = x, 2 = o     */

class OnlineScene: SKScene {
    override func didMove(to view: SKView) {
        
        EGC.findMatchWithMinPlayers(2, maxPlayers: 2)
        
        turn = 0
        myTurn = true
        gameOver = Bool()

        //shared array needs to be passed back and forth
        myArr = [Int](repeating: 0, count: 9)
        
        
        //CALLS RESTART
        score1 = 0;
        score2 = 0;
        //  myTurn = true;
        theme = defaults.string(forKey: "theme")
        
        restart(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            let location = touch.location(in: self)
            playGame(location, self: self)
            
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}



//PLAYS GAME
func playGame(_ location: CGPoint, self: OnlineScene) {
    let touchedNode = self.atPoint(location)
    
    if let name = touchedNode.name {
        if name == "retry" {
            self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: true))
            delay(0.3) {
                restart (self)
            }
            
        }
        if name == "back" {
            //GO BACK TO MENUSCENE
            self.run(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
            if let view = self.view {
                let scene = MenuScene(fileNamed:"MenuScene")
                let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.60)
                scene?.scaleMode = SKSceneScaleMode.fill
                view.presentScene(scene!, transition: transition)
            }
        }
    }
    
    
    //CREATES SPRITE
    let sprite = SKSpriteNode(imageNamed: "X")
    sprite.position = location
    winner = 0
    
    //FIGURES OUT TURN AND SETS BOOL myTurn T/F
    myTurn = findTurnModifySprite(turn, sprite: sprite)
    
    
    
    //GETS COLUMN AND ROW OF TOUCH INPUT
    let col = getColumn(location, self: self)
    let row = getRow(location, self: self)
    
    
    //STOPS IF TOUCH WAS IN AN INVALID LOCATION
    if (col == -1 || row == -1 || gameOver == true) {return}
    
    var xPoint = CGFloat(1.0)
    var yPoint = CGFloat(1.0)
    
    if (col == 0) {xPoint = 0.73}
    if (col == 2) {xPoint = 1.27}
    
    if (row == 0) {yPoint = 1.4}
    if (row == 2) {yPoint = 0.6}
    
    if (myArr[((3*row) + col)] != 0) {return}                   //Prevents End Game Failure Bug
    
    if (myArr[((3*row) + col)] == 0) {                          //Only add new Sprite if spot is empty
        sprite.position = CGPoint(x:self.frame.midX*xPoint, y:(self.frame.midY*yPoint)+30)
        self.addChild(sprite)
        let fadeIn = SKAction.fadeIn(withDuration: 0.50)
        
        sprite.run(fadeIn)
    }
    
    //ADD APPROPRIATE PLAYER VALUE TO ARRAY
    
    if (myTurn)    {myArr[((3*row) + col)] = 1
        self.run(SKAction.playSoundFileNamed("X.wav", waitForCompletion: false))
        
    }
    if (!myTurn)   {myArr[((3*row) + col)] = 2
        self.run(SKAction.playSoundFileNamed("O.wav", waitForCompletion: false))
    }
    
    
    //END GAME CODE
    winner = checkForWin(myArr)
    let retry = SKSpriteNode(imageNamed:"retry")
    setupRetryButton(retry, self: self)
    
    if winner != 0 {
        
        countTotalGames()
        
        //RUN WIN GAME SCENARIO
        let winLine = findWinningLine(myArr)
        drawWinLine(winLine, self: self)
        if winner == 1 {
            Title.run(titleChange)
            TitleShadow.run(titleChange)
            delay(0.8) {
                Title.text = p1Key! + " wins!";
                TitleShadow.text = p1Key! + " wins!";
            }
            score1 += 1
        }
        else if winner == 2 {
            Title.run(titleChange)
            TitleShadow.run(titleChange)
            delay(0.8) {
                Title.text = p2Key! + " wins!";
                TitleShadow.text = p2Key! + " wins!";
            }
            score2 += 1
        }
        retry.run(SKAction.sequence([wait, SKAction.repeatForever(SKAction.sequence([fadeIn, waitTiny, fadeOut]))]))
        gameOver = true;
        scoreOneLabel.text = "\(score1)"
        scoreTwoLabel.text = "\(score2)"
        scoreOneLabelShadow.text = "\(score1)"
        scoreTwoLabelShadow.text = "\(score2)"
        
        //UPDATE SINGLE PLAYER HIGH SCORE
        if (winner == 1 && gameType == 1 && score1 > (hsEasy ?? 0)) {
            if (difficulty == "easy") {
                hsEasy = score1; defaults.set(score1, forKey: "hsEasy")
                saveHighscore(score1)
            }
            
        }
        
        if (winner == 1 && gameType == 1 && score1 > (hsMedium ?? 0)) {
            if (difficulty == "medium") {
                hsMedium = score1; defaults.set(score1, forKey: "hsMedium")
                saveHighscore(score1)
            }
        }
        
        if (winner == 1 && gameType == 1 && score1 > (hsHard ?? 0)) {
            if (difficulty == "hard") {
                hsHard = score1; defaults.set(score1, forKey: "hsHard")
                saveHighscore(score1)
            }
        }
        delay(0.6) {
            if (gameType == 2 || (gameType == 1 && winner == 1)) {
                self.run(SKAction.playSoundFileNamed("win.wav", waitForCompletion: false))
            }
        }
        delay(0.6) {
            if (gameType == 1 && winner == 2) {
                self.run(SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false))
            }
        }
        
    }
        
    else if (checkForDraw(myArr)){
        
        //RUN DRAW GAME SCENARIO
        retry.run(SKAction.sequence([wait, SKAction.repeatForever(SKAction.sequence([fadeIn, waitTiny, fadeOut]))]))
        Title.run(titleChange)
        TitleShadow.run(titleChange)
        delay(0.8) {
            Title.text = "Draw"
            TitleShadow.text = "Draw"
        }
        countTotalGames()
        
        gameOver = true;
    }
    
    turn += 1
    
    //INDICATOR ANIMATION
    checkIndicator(self, winner: winner, restart: false);
    
    
    //ALLOWS COMPUTER TO AUTOMATICALLY MOVE
    if (gameType == 1 && myTurn) {
        delay(0.6){
            playGame(location, self: self)
        }
    }
    
}

//INCREASES GAMECOUNT
//func countTotalGames() {
//    if (gameType == 1) {
//        totalGamesSP += 1;
//        defaults.set(totalGamesSP, forKey: "totalGamesSP")
//    }
//    if (gameType == 2) {
//        totalGamesMP += 1;
//        defaults.set(totalGamesMP, forKey: "totalGamesMP")
//    }
//}


//ANIMATES PLAYER INDICATOR
func checkIndicator(_ self: OnlineScene, winner: Int, restart: Bool) {
    let scaleUp = SKAction.scale(to: 0.25, duration: 0.2)
    let scaleDown = SKAction.scale(to: 0.1, duration: 0.2)
    var tempBool = Bool()
    
    if restart {tempBool = !myTurn} else {tempBool = myTurn}
    
    if (!tempBool && winner == 0) {
        x.run(scaleUp); o.run(scaleDown)
    } else if (tempBool && winner == 0) {
        o.run(scaleUp); x.run(scaleDown)
    }
}


//SIMPLE DELAY FUNCTION
//func delay(_ delay:Double, closure:@escaping ()->()) {
//    let when = DispatchTime.now() + delay
//    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
//}


//SETS UP RETRY BUTTON
func setupRetryButton(_ retry: SKSpriteNode, self: OnlineScene) {
    
    retry.position = CGPoint(x: self.frame.midX*1.335, y: self.frame.midY*0.15)
    retry.alpha = 0.0; retry.xScale = 0.6; retry.yScale = 0.6; retry.name = "retry"
    self.addChild(retry)
    
}

//DECIDES IF X TURN OR Y TURN
//func findTurnModifySprite(_ turn: Int, sprite: SKSpriteNode) -> Bool {
//    
//    sprite.alpha = 0.0
//    sprite.xScale = 0.5
//    sprite.yScale = 0.5
//    let throwaway = SKSpriteNode()
//    
//    if (turn % 2 == 0) {
//        //Theming
//        if let texture = theme {applyTheme(texture, x: sprite, o: throwaway)}
//        else {sprite.texture = SKTexture(imageNamed: "Xeyes")}
//        
//        return true;
//        
//    } else {
//        //Theming
//        if let texture = theme {applyTheme(texture, x: throwaway, o: sprite)}
//        else {sprite.texture = SKTexture(imageNamed: "Oeyes")}
//        
//        return false;
//    }
//}


//GETS COLUMN OF TOUCH IN 3x3 PLOT
func getColumn(_ location: CGPoint, self: OnlineScene) -> Int {
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


//GETS ROW OF TOUCH IN 3x3 PLOTt
func getRow(_ location: CGPoint, self: OnlineScene) -> Int {
    if (location.y < (self.frame.midY*1.55)+30 &&
        location.y > (self.frame.midY*1.20)+30) {
        return 0;
    } else if (location.y > (self.frame.midY*0.81)+30 &&
        location.y < (self.frame.midY*1.18)+30) {
        return 1;
    } else if (location.y > (self.frame.midY*0.43)+30 &&
        location.y < (self.frame.midY*0.79)+30) {
        return 2;
    }
    return -1;
}


//GETS ROW FROM ARRAY VALUE
//func getRowFromArray(_ i: Int) -> Int {
//    if (i >= 0 && i <= 2) {
//        return 0;
//    }
//    if (i >= 3 && i <= 5) {
//        return 1;
//    }
//    if (i >= 6 && i <= 8) {
//        return 2;
//    }
//    
//    return -1;
//}

//GETS COLUMN FROM ARRAY VALUE
//func getColFromArray(_ i: Int) -> Int {
//    if (i == 0 || i == 3 || i == 6) {
//        return 0;
//    }
//    if (i == 1 || i == 4 || i == 7) {
//        return 1;
//    }
//    if (i == 2 || i == 5 || i == 8) {
//        return 2;
//    }
//    
//    return -1;
//}


////CHECKS IF EITHER PLAYER HAS WON
//func checkForWin(_ myArr: [Int]) -> Int {
//    
//    if turn < 3 {return 0}
//    
//    if ((myArr[0] != 0) || (myArr[4] != 0) || (myArr[8] != 0)) {
//        if (myArr[0] == myArr[1] && myArr[1] == myArr[2] && myArr[2] != 0) ||
//            (myArr[0] == myArr[3] && myArr[3] == myArr[6] && myArr[6] != 0) ||
//            (myArr[0] == myArr[4] && myArr[4] == myArr[8] && myArr[8] != 0) {
//            return myArr[0]
//        }
//            
//        else if (myArr[4] == myArr[0] && myArr[0] == myArr[8]) ||
//            (myArr[4] == myArr[1] && myArr[1] == myArr[7] && myArr[7] != 0) ||
//            (myArr[4] == myArr[6] && myArr[6] == myArr[2] && myArr[2] != 0) ||
//            (myArr[4] == myArr[3] && myArr[3] == myArr[5] && myArr[5] != 0) {
//            return myArr[4]
//        }
//            
//        else if (myArr[8] == myArr[4] && myArr[4] == myArr[0]) ||
//            (myArr[8] == myArr[2] && myArr[2] == myArr[5] && myArr[5] != 0) ||
//            (myArr[8] == myArr[6] && myArr[6] == myArr[7] && myArr[7] != 0) {
//            return myArr[8]
//        }
//    }
//    
//    return 0
//}


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
 
 
 //FINDS THE WINNING COMBINATION */
//func findWinningLine(_ myArr: [Int]) -> Int {
//    
//    //WinLine1
//    if (myArr[0] == myArr[1] && myArr[1] == myArr[2] && myArr[2] != 0) {
//        return 1;
//    }
//    
//    //WinLine2
//    if (myArr[3] == myArr[4] && myArr[4] == myArr[5] && myArr[5] != 0) {
//        return 2;
//    }
//    
//    //WinLine3
//    if (myArr[6] == myArr[7] && myArr[7] == myArr[8] && myArr[8] != 0) {
//        return 3;
//    }
//    
//    //WinLine4
//    if (myArr[0] == myArr[3] && myArr[3] == myArr[6] && myArr[6] != 0) {
//        return 4;
//    }
//    
//    //WinLine5
//    if (myArr[1] == myArr[4] && myArr[4] == myArr[7] && myArr[7] != 0) {
//        return 5;
//    }
//    
//    //WinLine6
//    if (myArr[2] == myArr[5] && myArr[5] == myArr[8] && myArr[8] != 0) {
//        return 6;
//    }
//    
//    //WinLine7
//    if (myArr[0] == myArr[4] && myArr[4] == myArr[8] && myArr[8] != 0) {
//        return 7;
//    }
//    
//    //WinLine8
//    if (myArr[2] == myArr[4] && myArr[4] == myArr[6] && myArr[6] != 0) {
//        return 8;
//    }
//    
//    return 0;
//}


//DRAWS 3 IN A ROW LINE WHEN PLAYER WINS
func drawWinLine(_ lineNum: Int, self: OnlineScene) {
    let line = SKSpriteNode(imageNamed: "line")
    line.alpha = 0
    line.zPosition = 2
    line.xScale = 0.15
    line.yScale = 1.05
    
    
    let rotate90 = SKAction.rotate(byAngle: 1.57079632, duration: 0)
    let rotate45 = SKAction.rotate(byAngle: 0.70539816, duration: 0)
    let rotate45ish = SKAction.rotate(byAngle: 0.87839816, duration: 0)
    
    if lineNum == 1 {
        line.position = CGPoint(x:self.frame.midX, y:(self.frame.midY*1.4)+30)
        line.run(rotate90)
    }
    
    if lineNum == 2 {
        line.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)+30)
        line.run(rotate90)
    }
    
    if lineNum == 3 {
        line.position = CGPoint(x:self.frame.midX, y:(self.frame.midY*0.6)+30)
        line.run(rotate90)
    }
    
    if lineNum == 4 {
        line.position = CGPoint(x:self.frame.midX*0.73, y:(self.frame.midY)+30)
    }
    
    if lineNum == 5 {
        line.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)+30)
    }
    
    if lineNum == 6 {
        line.position = CGPoint(x:self.frame.midX*1.27, y:(self.frame.midY)+30)
    }
    
    if lineNum == 7 {
        line.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)+30)
        line.run(rotate45)
        line.yScale = 1.15
    }
    
    if lineNum == 8 {
        line.position = CGPoint(x:self.frame.midX, y:(self.frame.midY)+30)
        line.run(rotate90)
        line.run(rotate45ish)
        line.yScale = 1.15
    }
    
    self.addChild(line)
    line.run(fadeIn)
}


//CALLED BY RESTART TO SETUP SCENE
func createSceneContents(_ self: OnlineScene) {
    
    //self.backgroundColor = UIColor.lightGray
    
    //REAL BACKGROUND
    let bg = SKSpriteNode(imageNamed: "bg")
    bg.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
    bg.size = CGSize(width:self.frame.width/2, height: self.frame.height)
    self.addChild(bg)
    bg.zPosition = -1.1
    
    Title.text = "Tic Tac Toe!"; Title.fontColor = SKColor.darkGray
    TitleShadow.text = "Tic Tac Toe!"; TitleShadow.fontColor = SKColor.white;
    Title.fontSize = 60; Title.alpha = 0; TitleShadow.fontSize = 60; TitleShadow.alpha = 0;
    Title.position = CGPoint(x:self.frame.midX, y:((self.frame.midY)/4)+15)
    TitleShadow.position = CGPoint(x:self.frame.midX+2, y:((self.frame.midY)/4)+13); TitleShadow.zPosition = -1;
    
    self.addChild(Title); self.addChild(TitleShadow)
    Title.run(fadeIn); TitleShadow.run(fadeIn)
    
    let map = SKSpriteNode(imageNamed:"Hash")
    map.xScale = 0.6
    map.yScale = 0.6
    map.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 30)
    map.alpha = 0;
    
    self.addChild(map)
    map.run(fadeIn)
    
    p1Key = defaults.string(forKey: "nameOne")
    p2Key = defaults.string(forKey: "nameTwo")
    
    if p1Key == nil {p1Key = "Player 1"}
    if p2Key == nil {p2Key = "Player 2"}
    if gameType == 1 {p2Key = "X-O Bot"}
    
    let PlayerIndicator1 = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold).fontName)
    let PlayerIndicator2 = SKLabelNode(fontNamed:UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold).fontName)
    PlayerIndicator1.text = p1Key! + ": ";
    PlayerIndicator2.text = p2Key! + ": ";
    PlayerIndicator1.fontSize = 20; PlayerIndicator1.alpha = 0;
    PlayerIndicator2.fontSize = 20; PlayerIndicator2.alpha = 0;
    PlayerIndicator1.fontColor = UIColor.darkGray;
    PlayerIndicator2.fontColor = UIColor.darkGray;
    PlayerIndicator1.position = CGPoint(x:self.frame.midX*0.7, y:(self.frame.midY)*1.75)
    PlayerIndicator2.position = CGPoint(x:self.frame.midX*1.2, y:(self.frame.midY)*1.75)
    
    self.addChild(PlayerIndicator1)
    self.addChild(PlayerIndicator2)
    PlayerIndicator1.run(fadeIn); PlayerIndicator2.run(fadeIn)
    
    scoreOneLabel = SKLabelNode(fontNamed:"Avenir")
    scoreTwoLabel = SKLabelNode(fontNamed:"Avenir")
    scoreOneLabel.text = "\(score1)"
    scoreTwoLabel.text = "\(score2)"
    scoreOneLabel.fontSize = 60; scoreTwoLabel.fontSize = 60;
    scoreOneLabel.alpha = 0; scoreTwoLabel.alpha = 0;
    scoreOneLabel.fontColor = UIColor.white; scoreTwoLabel.fontColor = UIColor.white
    scoreOneLabel.position = CGPoint(x:self.frame.midX*0.7, y:(self.frame.midY)*1.80)
    scoreTwoLabel.position = CGPoint(x:self.frame.midX*1.2, y:(self.frame.midY)*1.80)
    
    scoreOneLabelShadow = SKLabelNode(fontNamed:"Avenir")
    scoreTwoLabelShadow = SKLabelNode(fontNamed:"Avenir")
    scoreOneLabelShadow.text = "\(score1)"
    scoreTwoLabelShadow.text = "\(score2)"
    scoreOneLabelShadow.fontSize = 60; scoreTwoLabelShadow.fontSize = 60;
    scoreOneLabelShadow.alpha = 0; scoreTwoLabelShadow.alpha = 0;
    scoreOneLabelShadow.fontColor = UIColor.darkGray; scoreTwoLabelShadow.fontColor = UIColor.darkGray
    scoreOneLabelShadow.position = CGPoint(x:(self.frame.midX*0.7)-2, y:((self.frame.midY)*1.80)+2)
    scoreTwoLabelShadow.position = CGPoint(x:(self.frame.midX*1.2)-2, y:((self.frame.midY)*1.80)+2)
    scoreOneLabelShadow.zPosition = -1; scoreTwoLabelShadow.zPosition = -1;
    
    let botDiff = SKLabelNode(fontNamed: "Avenir")
    botDiff.text = "Difficulty: " + difficulty!
    botDiff.fontSize = 20; botDiff.alpha = 0; botDiff.fontColor = UIColor.darkGray
    botDiff.position = CGPoint(x:self.frame.midX, y: (self.frame.midY)*1.91)
    if gameType == 1 {
        self.addChild(botDiff)
        botDiff.run(fadeIn)
    }
    delay(3) {
        botDiff.run(fadeOut)
    }
    
    self.addChild(scoreOneLabel); self.addChild(scoreOneLabelShadow)
    self.addChild(scoreTwoLabel); self.addChild(scoreTwoLabelShadow)
    scoreOneLabel.run(fadeIn); scoreTwoLabel.run(fadeIn); scoreOneLabelShadow.run(fadeIn); scoreTwoLabelShadow.run(fadeIn)
    
    x = SKSpriteNode(imageNamed:"X")
    o = SKSpriteNode(imageNamed:"O")
    x.xScale = 0.1; x.yScale = 0.1; o.xScale = 0.1; o.yScale = 0.1;
    x.position = CGPoint(x:self.frame.midX*0.85, y:(self.frame.midY)*1.77)
    o.position = CGPoint(x:self.frame.midX*1.35, y:(self.frame.midY)*1.77)
    x.alpha = 0; o.alpha = 0;
    
    self.addChild(x)
    self.addChild(o)
    x.run(fadeIn); o.run(fadeIn); x.run(wag); o.run(wag)
    
    let back = SKSpriteNode(imageNamed:"arrow")
    back.xScale = 0.6; back.yScale = 0.6; back.name = "back"; back.alpha = 0;
    back.position = CGPoint(x:self.frame.midX*0.69, y: self.frame.midY*0.15)
    
    self.addChild(back)
    back.run(fadeIn)
    
    hsEasy = defaults.integer(forKey: "hsEasy")
    hsMedium = defaults.integer(forKey: "hsMedium")
    hsHard = defaults.integer(forKey: "hsHard")
    
    //Theming
    if let texture = theme {
        applyTheme(texture, x: x, o: o)
    }
    
    //Unlock Things if necessary
    unlockThings()
    
    //Indicator
    checkIndicator(self, winner: winner, restart: true)
}

//func unlockThings() {
//    if (difficulty == "hard" && gameType == 1 && hsHard == 5) {
//        defaults.set(false, forKey: "warriorLock")
//        let warriortheme = GKAchievement.init(identifier: "XvsOThemeUnlockwarrior")
//        warriortheme.showsCompletionBanner = true;
//        warriortheme.percentComplete = 100.0
//        GKAchievement.report([warriortheme], withCompletionHandler: nil)
//    }
//    
//    if (difficulty == "medium" && gameType == 1 && hsMedium == 5) {
//        defaults.set(false, forKey: "ballerLock")
//        let ballertheme = GKAchievement.init(identifier: "XvsOThemeUnlockballer")
//        ballertheme.showsCompletionBanner = true;
//        ballertheme.percentComplete = 100.0
//        GKAchievement.report([ballertheme], withCompletionHandler: nil)
//    }
//    
//    if (difficulty == "easy" && gameType == 1 && hsEasy == 5) {
//        defaults.set(false, forKey: "greekLock")
//        let greektheme = GKAchievement.init(identifier: "XvsOThemeUnlockgreek")
//        greektheme.showsCompletionBanner = true;
//        greektheme.percentComplete = 100.0
//        GKAchievement.report([greektheme], withCompletionHandler: nil)
//    }
//    
//    if (gameType == 2 && totalGamesMP == 1) {
//        defaults.set(false, forKey: "plainLock")
//        let plaintheme = GKAchievement.init(identifier: "XvsOThemeUnlockplain")
//        plaintheme.showsCompletionBanner = true;
//        plaintheme.percentComplete = 100.0
//        GKAchievement.report([plaintheme], withCompletionHandler: nil)
//    }
//    
//}


//CALLED ON SCENE MOVING TO VIEW
func restart(_ self: OnlineScene) {
    
    self.removeAllChildren()
    self.removeAllActions()
    gameOver = false
    gameType = defaults.integer(forKey: "gametype")
    difficulty = defaults.string(forKey: "difficulty")
    
    
    
    for i in 0...8 {
        myArr[i] = 0
    }
    
    createSceneContents(self)
    if (gameType == 1 && !myTurn) {
        delay(1) {
            playGame(CGPoint(x:self.frame.midX, y:self.frame.midY), self: self)
        }
    }
}


//CHECKS FOR DRAW IN GAME
//func checkForDraw(_ myArr: [Int]) -> Bool {
//    for i in 0...8 {
//        if myArr[i] == 0 {return false}
//    }
//    return true
//}


//APPLIES THEME
//func applyTheme(_ texture: String, x: SKSpriteNode, o: SKSpriteNode) {
//    //Standard theme
//    if texture == "standard" {
//        x.texture = SKTexture(imageNamed: "Xeyes")
//        o.texture = SKTexture(imageNamed: "Oeyes")
//    }
//    
//    //Baby Theme
//    if texture == "baby" {
//        x.texture = SKTexture(imageNamed: "Xbaby")
//        o.texture = SKTexture(imageNamed: "Obaby")
//    }
//    
//    //Warrior Theme
//    if texture == "warrior" {
//        x.texture = SKTexture(imageNamed: "Xwarrior")
//        o.texture = SKTexture(imageNamed: "Owarrior")
//    }
//    
//    //Baller Theme
//    if texture == "baller" {
//        x.texture = SKTexture(imageNamed: "Xballer")
//        o.texture = SKTexture(imageNamed: "Oballer")
//    }
//    
//    //Greek Theme
//    if texture == "greek" {
//        x.texture = SKTexture(imageNamed: "Xgreek")
//        o.texture = SKTexture(imageNamed: "Ogreek")
//    }
//    
//    //Plain Theme
//    if texture == "plain" {
//        x.texture = SKTexture(imageNamed: "X")
//        o.texture = SKTexture(imageNamed: "O")
//    }
//}


//SAVES HIGH SCORES TO GAME CENTER
//func saveHighscore(_ score: Int) {
//    
//    let leaderboardString = "XvsOLeaders" + difficulty!;
//    
//    
//    //check if user is signed in
//    if GKLocalPlayer.localPlayer().isAuthenticated {
//        
//        let scoreReporter = GKScore(leaderboardIdentifier: leaderboardString) //leaderboard id here
//        
//        scoreReporter.value = Int64(score) //score variable here (same as above)
//        
//        let scoreArray: [GKScore] = [scoreReporter]
//        
//        GKScore.report(scoreArray, withCompletionHandler: nil)
//        
//    }
//    
//}










