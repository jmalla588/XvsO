//
//  GameCenter.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 7.0+ & iOS 8.0+ & iOS 9.0+ & TvOS 9.0+
//
//  The MIT License (MIT)
//  Copyright (c) 2015 Red Wolf Studio & Yannick Stephan
//  http://www.redwolfstudio.fr
//  http://yannickstephan.com
//  Version 2.3 for Swift 2.0
import Foundation
import GameKit
import SystemConfiguration

/**
 TODO List
 - REMEMBER report plusieur score  pour plusieur leaderboard  en array
 */

// Protocol Easy Game Center
@objc public protocol EGCDelegate:NSObjectProtocol {
    /**
     Authentified, Delegate Easy Game Center
     */
    @objc optional func EGCAuthentified(_ authentified:Bool)
    /**
     Not Authentified, Delegate Easy Game Center
     */
    //optional func EGCNotAuthentified()
    /**
     Achievementes in cache, Delegate Easy Game Center
     */
    @objc optional func EGCInCache()
    /**
     Method called when a match has been initiated.
     */
    @objc optional func EGCMatchStarted()
    /**
     Method called when the device received data about the match from another device in the match.
     
     - parameter match:          GKMatch
     - parameter didReceiveData: NSData
     - parameter fromPlayer:     String
     */
    @objc optional func EGCMatchRecept(_ match: GKMatch, didReceiveData: Data, fromPlayer: String)
    /**
     Method called when the match has ended.
     */
    @objc optional func EGCMatchEnded()
    /**
     Cancel match
     */
    @objc optional func EGCMatchCancel()
}

// MARK: - Public Func
extension EGC {
    /**
     CheckUp Connection the new
     
     - returns: Bool Connection Validation
     
     */
    static var isConnectedToNetwork: Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

/// Easy Game Center Swift
open class EGC: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLocalPlayerListener {
    
    /*####################################################################################################*/
    /*                                    Private    Instance                                             */
    /*####################################################################################################*/
    
    /// Achievements GKAchievement Cache
    fileprivate var achievementsCache:[String:GKAchievement] = [String:GKAchievement]()
    
    /// Achievements GKAchievementDescription Cache
    fileprivate var achievementsDescriptionCache = [String:GKAchievementDescription]()
    
    /// Save for report late when network working
    fileprivate var achievementsCacheShowAfter = [String:String]()
    
    /// Checkup net and login to GameCenter when have Network
    fileprivate var timerNetAndPlayer:Timer?
    
    /// Debug mode for see message
    fileprivate var debugModeGetSet:Bool = false
    
    static var showLoginPage:Bool = true
    
    /// The match object provided by GameKit.
    fileprivate var match: GKMatch?
    fileprivate var playersInMatch = Set<GKPlayer>()
    open var invitedPlayer: GKPlayer?
    open var invite: GKInvite?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /*####################################################################################################*/
    /*                                    Singleton Public Instance                                       */
    /*####################################################################################################*/
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(EGC.authenticationChanged), name: Notification.Name( NSNotification.Name.GKPlayerAuthenticationDidChangeNotificationName.rawValue), object: nil)
    }
    /**
     Static EGC
     
     */
    struct Static {
        /// Async EGC
        static var onceToken: Int = 0
        /// Instance of EGC
        static var instance: EGC? = nil
        /// Delegate of UIViewController
        static weak var delegate: UIViewController? = nil
    }
    /**
     Start Singleton GameCenter Instance
     
     */
    open class func sharedInstance(_ delegate:UIViewController)-> EGC {
        if Static.instance == nil {
            Static.instance = EGC()
            Static.delegate = delegate
            Static.instance!.loginPlayerToGameCenter()
        }
        return Static.instance!
    }
    /// Delegate UIViewController
    class var delegate: UIViewController {
        get {
            do {
                let delegateInstance = try EGC.sharedInstance.getDelegate()
                return delegateInstance
            } catch  {
                EGCError.noDelegate.errorCall()
                fatalError("Dont work\(error)")
            }
        }
        
        set {
            guard newValue != EGC.delegate else {
                return
            }
            Static.delegate = EGC.delegate
            
            EGC.printLogEGC("New delegate UIViewController is \(String(describing: type(of: Static.delegate)))\n")
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func / Object                                          */
    /*####################################################################################################*/
    
    open class var debugMode:Bool {
        get {
            return EGC.sharedInstance.debugModeGetSet
        }
        set {
            EGC.sharedInstance.debugModeGetSet = newValue
        }
    }
    /**
     If player is Identified to Game Center
     
     - returns: Bool is identified
     
     */
    public static var isPlayerIdentified: Bool {
        get {
            return GKLocalPlayer.local.isAuthenticated
        }
    }
    /**
     Get local player (GKLocalPlayer)
     
     - returns: Bool True is identified
     
     */
    static var localPlayer: GKLocalPlayer {
        get {
            return GKLocalPlayer.local
        }
    }
    //   class func getLocalPlayer() -> GKLocalPlayer {  }
    /**
     Get local player Information (playerID,alias,profilPhoto)
     
     :completion: Tuple of type (playerID:String,alias:String,profilPhoto:UIImage?)
     
     */
    class func getlocalPlayerInformation(completion completionTuple: @escaping (_ playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)?) -> ()) {
        
        guard EGC.isConnectedToNetwork else {
            completionTuple(nil)
            EGCError.noConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            completionTuple(nil)
            EGCError.notLogin.errorCall()
            return
        }
        
        EGC.localPlayer.loadPhoto(for: GKPlayer.PhotoSize.normal, withCompletionHandler: {
            (image, error) in
            
            var playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)
            playerInformationTuple.profilPhoto = nil
            
            playerInformationTuple.playerID = EGC.localPlayer.playerID
            playerInformationTuple.alias = EGC.localPlayer.alias
            if error == nil { playerInformationTuple.profilPhoto = image }
            completionTuple(playerInformationTuple)
        })
    }
    /*####################################################################################################*/
    /*                                      Public Func Show                                              */
    /*####################################################################################################*/
    /**
     Show Game Center
     
     - parameter completion: Viod just if open Game Center Achievements
     */
    open class func showGameCenter(_ completion: ((_ isShow:Bool) -> Void)? = nil) {
        
        guard EGC.isConnectedToNetwork else {
            if completion != nil { completion!(false) }
            EGCError.noConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            if completion != nil { completion!(false) }
            EGCError.notLogin.errorCall()
            return
        }
        
        
        EGC.printLogEGC("Show Game Center")
        
        let gc                = GKGameCenterViewController()
        gc.gameCenterDelegate = Static.instance
        
        #if !os(tvOS)
            gc.viewState          = GKGameCenterViewControllerState.default
        #endif
        
        var delegeteParent:UIViewController? = EGC.delegate.parent
        if delegeteParent == nil {
            delegeteParent = EGC.delegate
        }
        delegeteParent!.present(gc, animated: true, completion: {
            if completion != nil { completion!(true) }
        })
        
    }
    
    /**
     Show Game Center Player Achievements
     
     - parameter completion: Viod just if open Game Center Achievements
     */
    open class func showGameCenterAchievements(_ completion: ((_ isShow:Bool) -> Void)? = nil) {
        
        guard EGC.isConnectedToNetwork else {
            if completion != nil { completion!(false) }
            EGCError.noConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            if completion != nil { completion!(false) }
            EGCError.notLogin.errorCall()
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = Static.instance
        #if !os(tvOS)
            gc.viewState = GKGameCenterViewControllerState.achievements
        #endif
        
        var delegeteParent:UIViewController? = EGC.delegate.parent
        if delegeteParent == nil {
            delegeteParent = EGC.delegate
        }
        delegeteParent!.present(gc, animated: true, completion: {
            if completion != nil { completion!(true) }
        })
    }
    /**
     Show Game Center Leaderboard
     
     - parameter leaderboardIdentifier: Leaderboard Identifier
     - parameter completion:            Viod just if open Game Center Leaderboard
     */
    open class func showGameCenterLeaderboard(leaderboardIdentifier :String, completion: ((_ isShow:Bool) -> Void)? = nil) {
        
        guard leaderboardIdentifier != "" else {
            EGCError.empty.errorCall()
            if completion != nil { completion!(false) }
            return
        }
        
        guard EGC.isConnectedToNetwork else {
            EGCError.noConnection.errorCall()
            if completion != nil { completion!(false) }
            return
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            if completion != nil { completion!(false) }
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = Static.instance
        #if !os(tvOS)
            gc.leaderboardIdentifier = leaderboardIdentifier
            gc.viewState = GKGameCenterViewControllerState.leaderboards
        #endif
        
        var delegeteParent:UIViewController? = EGC.delegate.parent
        if delegeteParent == nil {
            delegeteParent = EGC.delegate
        }
        delegeteParent!.present(gc, animated: true, completion: {
            if completion != nil { completion!(true) }
        })
        
    }
    /**
     Show Game Center Challenges
     
     - parameter completion: Viod just if open Game Center Challenges
     
     */
    open class func showGameCenterChallenges(_ completion: ((_ isShow:Bool) -> Void)? = nil) {
        
        guard EGC.isConnectedToNetwork else {
            if completion != nil { completion!(false) }
            EGCError.noConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            if completion != nil { completion!(false) }
            EGCError.notLogin.errorCall()
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate =  Static.instance
        #if !os(tvOS)
            gc.viewState = GKGameCenterViewControllerState.challenges
        #endif
        
        var delegeteParent:UIViewController? =  EGC.delegate.parent
        if delegeteParent == nil {
            delegeteParent =  EGC.delegate
        }
        delegeteParent!.present(gc, animated: true, completion: {
            () -> Void in
            
            if completion != nil { completion!(true) }
        })
        
    }
    /**
     Show banner game center
     
     - parameter title:       title
     - parameter description: description
     - parameter completion:  When show message
     
     */
    open class func showCustomBanner(title:String, description:String,completion: (() -> Void)? = nil) {
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return
        }
        
        GKNotificationBanner.show(withTitle: title, message: description, completionHandler: completion)
    }
    /**
     Show page Authentication Game Center
     
     - parameter completion: Viod just if open Game Center Authentication
     
     */
    open class func showGameCenterAuthentication(_ completion: ((_ result:Bool) -> Void)? = nil) {
        if completion != nil {
            completion!(UIApplication.shared.openURL(URL(string: "gamecenter:")!))
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func LeaderBoard                                       */
    /*####################################################################################################*/
    
    /**
     Get Leaderboards
     
     - parameter completion: return [GKLeaderboard] or nil
     
     */
    open class func getGKLeaderboard(completion: @escaping ((_ resultArrayGKLeaderboard:Set<GKLeaderboard>?) -> Void)) {
        
        guard EGC.isConnectedToNetwork else {
            completion(nil)
            EGCError.noConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            completion(nil)
            EGCError.notLogin.errorCall()
            return
        }
        
        GKLeaderboard.loadLeaderboards {
            (leaderboards, error) in
            
            guard EGC.isPlayerIdentified else {
                completion(nil)
                EGCError.notLogin.errorCall()
                return
            }
            
            guard let leaderboardsIsArrayGKLeaderboard = leaderboards as [GKLeaderboard]? else {
                completion(nil)
                EGCError.error(error?.localizedDescription).errorCall()
                return
            }
            
            completion(Set(leaderboardsIsArrayGKLeaderboard))
            
        }
    }
    /**
     Reports a  score to Game Center
     
     - parameter The: score Int
     - parameter Leaderboard: identifier
     - parameter completion: (bool) when the score is report to game center or Fail
     
     
     */
    open class func reportScoreLeaderboard(leaderboardIdentifier:String, score: Int) {
        guard EGC.isConnectedToNetwork else {
            EGCError.noConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return
        }
        
        let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier)
        gkScore.value = Int64(score)
        gkScore.shouldSetDefaultLeaderboard = true
        GKScore.report([gkScore], withCompletionHandler: nil)
    }
    /**
     Get High Score for leaderboard identifier
     
     - parameter leaderboardIdentifier: leaderboard ID
     - parameter completion:            Tuple (playerName: String, score: Int, rank: Int)
     
     */
    open class func getHighScore(
        leaderboardIdentifier:String,
        completion:@escaping (((playerName:String, score:Int,rank:Int)?) -> Void)
        ) {
        EGC.getGKScoreLeaderboard(leaderboardIdentifier: leaderboardIdentifier, completion: {
            (resultGKScore) in
            
            guard let valGkscore = resultGKScore else {
                completion(nil)
                return
            }
            
            let rankVal = valGkscore.rank
            let nameVal  = EGC.localPlayer.alias
            let scoreVal  = Int(valGkscore.value)
            completion((playerName: nameVal, score: scoreVal, rank: rankVal))
            
        })
    }
    /**
     Get GKScoreOfLeaderboard
     
     - parameter completion: GKScore or nil
     
     */
    open class func  getGKScoreLeaderboard(leaderboardIdentifier:String, completion:@escaping ((_ resultGKScore:GKScore?) -> Void)) {
        
        guard leaderboardIdentifier != "" else {
            EGCError.empty.errorCall()
            completion(nil)
            return
        }
        
        guard EGC.isConnectedToNetwork else {
            EGCError.noConnection.errorCall()
            completion(nil)
            return
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            completion(nil)
            return
        }
        
        let leaderBoardRequest = GKLeaderboard()
        leaderBoardRequest.identifier = leaderboardIdentifier
        
        leaderBoardRequest.loadScores {
            (resultGKScore, error) in
            
            guard error == nil && resultGKScore != nil else {
                completion(nil)
                return
            }
            
            completion(leaderBoardRequest.localPlayerScore)
            
        }
    }
    /*####################################################################################################*/
    /*                                      Public Func Achievements                                      */
    /*####################################################################################################*/
    /**
     Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement
     
     - parameter achievementIdentifier: Identifier Achievement
     
     - returns: (gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?
     
     */
    open class func getTupleGKAchievementAndDescription(achievementIdentifier:String,completion completionTuple: ((_ tupleGKAchievementAndDescription:(gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?) -> Void)) {
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            completionTuple(nil)
            return
        }
        
        let achievementGKScore = EGC.sharedInstance.achievementsCache[achievementIdentifier]
        let achievementGKDes =  EGC.sharedInstance.achievementsDescriptionCache[achievementIdentifier]
        
        guard let aGKS = achievementGKScore, let aGKD = achievementGKDes else {
            completionTuple(nil)
            return
        }
        
        completionTuple((aGKS,aGKD))
        
    }
    /**
     Get Achievement
     
     - parameter identifierAchievement: Identifier achievement
     
     - returns: GKAchievement Or nil if not exist
     
     */
    open class func getAchievementForIndentifier(identifierAchievement : NSString) -> GKAchievement? {
        
        guard identifierAchievement != "" else {
            EGCError.empty.errorCall()
            return nil
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return nil
        }
        
        guard let achievementFind = EGC.sharedInstance.achievementsCache[identifierAchievement as String] else {
            return nil
        }
        return achievementFind
        
        
        
    }
    /**
     Add progress to an achievement
     
     - parameter progress:               Progress achievement Double (ex: 10% = 10.00)
     - parameter achievementIdentifier:  Achievement Identifier
     - parameter showBannnerIfCompleted: if you want show banner when now or not when is completed
     - parameter completionIsSend:       Completion if is send to Game Center
     
     */
    open class func reportAchievement( progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool = true ,addToExisting: Bool = false) {
        
        guard achievementIdentifier != "" else {
            EGCError.empty.errorCall()
            return
        }
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return
        }
        guard !EGC.isAchievementCompleted(achievementIdentifier: achievementIdentifier) else {
            EGC.printLogEGC("Achievement is already completed")
            return
        }
        
        guard let achievement = EGC.getAchievementForIndentifier(identifierAchievement: achievementIdentifier as NSString) else {
            EGC.printLogEGC("No Achievement for identifier")
            return
        }
        
        
        
        
        let currentValue = achievement.percentComplete
        let newProgress: Double = !addToExisting ? progress : progress + currentValue
        
        achievement.percentComplete = newProgress
        
        /* show banner only if achievement is fully granted (progress is 100%) */
        if achievement.isCompleted && showBannnerIfCompleted {
            EGC.printLogEGC("Achievement \(achievementIdentifier) completed")
            
            if EGC.isConnectedToNetwork {
                achievement.showsCompletionBanner = true
            } else {
                //oneAchievement.showsCompletionBanner = true << Bug For not show two banner
                // Force show Banner when player not have network
                EGC.getTupleGKAchievementAndDescription(achievementIdentifier: achievementIdentifier, completion: {
                    (tupleGKAchievementAndDescription) -> Void in
                    
                    if let tupleIsOK = tupleGKAchievementAndDescription {
                        let title = tupleIsOK.gkAchievementDescription.title
                        let description = tupleIsOK.gkAchievementDescription.achievedDescription
                        
                        EGC.showCustomBanner(title: title, description: description)
                    }
                })
            }
        }
        if  achievement.isCompleted && !showBannnerIfCompleted {
            EGC.sharedInstance.achievementsCacheShowAfter[achievementIdentifier] = achievementIdentifier
        }
        EGC.sharedInstance.reportAchievementToGameCenter(achievement: achievement)
        
        
        
        
    }
    /**
     Get GKAchievementDescription
     
     - parameter completion: return array [GKAchievementDescription] or nil
     
     */
    open class func getGKAllAchievementDescription(completion: ((_ arrayGKAD:Set<GKAchievementDescription>?) -> Void)){
        
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return
        }
        
        guard EGC.sharedInstance.achievementsDescriptionCache.count > 0 else {
            EGCError.noAchievement.printError()
            return
        }
        
        var tempsEnvoi = Set<GKAchievementDescription>()
        for achievementDes in EGC.sharedInstance.achievementsDescriptionCache {
            tempsEnvoi.insert(achievementDes.1)
        }
        completion(tempsEnvoi)
        
        
    }
    /**
     If achievement is Completed
     
     - parameter Achievement: Identifier
     :return: (Bool) if finished
     
     */
    open class func isAchievementCompleted(achievementIdentifier: String) -> Bool{
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return false
        }
        guard let achievement = EGC.getAchievementForIndentifier(identifierAchievement: achievementIdentifier as NSString), achievement.isCompleted || achievement.percentComplete == 100.00 else {
            return false
        }
        return true
    }
    /**
     Get Achievements Completes during the game and banner was not showing
     
     - returns: [String : GKAchievement] or nil
     
     */
    open class func getAchievementCompleteAndBannerNotShowing() -> [GKAchievement]? {
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return nil
        }
        
        let achievements : [String:String] = EGC.sharedInstance.achievementsCacheShowAfter
        var achievementsTemps = [GKAchievement]()
        
        if achievements.count > 0 {
            
            for achievement in achievements  {
                if let achievementExtract = EGC.getAchievementForIndentifier(identifierAchievement: achievement.1 as NSString) {
                    if achievementExtract.isCompleted && achievementExtract.showsCompletionBanner == false {
                        achievementsTemps.append(achievementExtract)
                    }
                }
            }
            return achievementsTemps
        }
        return nil
    }
    /**
     Show all save achievement Complete if you have ( showBannerAchievementWhenComplete = false )
     
     - parameter completion: if is Show Achievement banner
     (Bug Game Center if you show achievement by showsCompletionBanner = true when you report and again you show showsCompletionBanner = false is not show)
     
     */
    open class func showAllBannerAchievementCompleteForBannerNotShowing(_ completion: ((_ achievementShow:GKAchievement?) -> Void)? = nil) {
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            if completion != nil { completion!(nil) }
            return
        }
        guard let achievementNotShow: [GKAchievement] = EGC.getAchievementCompleteAndBannerNotShowing()  else {
            
            if completion != nil { completion!(nil) }
            return
        }
        
        
        for achievement in achievementNotShow  {
            
            EGC.getTupleGKAchievementAndDescription(achievementIdentifier: achievement.identifier, completion: {
                (tupleGKAchievementAndDescription) in
                
                guard let tupleOK = tupleGKAchievementAndDescription   else {
                    
                    if completion != nil { completion!(nil) }
                    return
                }
                
                //oneAchievement.showsCompletionBanner = true
                let title = tupleOK.gkAchievementDescription.title
                let description = tupleOK.gkAchievementDescription.achievedDescription
                
                EGC.showCustomBanner(title: title, description: description, completion: {
                    
                    if completion != nil { completion!(achievement) }
                })
                
            })
        }
        EGC.sharedInstance.achievementsCacheShowAfter.removeAll(keepingCapacity: false)
        
        
    }
    /**
     Get progress to an achievement
     
     - parameter Achievement: Identifier
     
     - returns: Double or nil (if not find)
     
     */
    open class func getProgressForAchievement(achievementIdentifier:String) -> Double? {
        
        guard achievementIdentifier != "" else {
            EGCError.empty.errorCall()
            return nil
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return nil
        }
        
        if let achievementInArrayInt = EGC.sharedInstance.achievementsCache[achievementIdentifier]?.percentComplete {
            return achievementInArrayInt
        } else {
            EGCError.error("No Achievement for achievementIdentifier : \(achievementIdentifier)").errorCall()
            EGCError.noAchievement.errorCall()
            return nil
        }
        
    }
    /**
     Remove All Achievements
     
     completion: return GKAchievement reset or Nil if game center not work
     sdsds
     */
    open class func resetAllAchievements( _ completion:  ((_ achievementReset:GKAchievement?) -> Void)? = nil)  {
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            if completion != nil { completion!(nil) }
            return
        }
        
        GKAchievement.resetAchievements(completionHandler: {
            (error:Error?) in
            guard error == nil else {
                EGC.printLogEGC("Couldn't Reset achievement (Send data error)")
                return
            }
            
            
            for lookupAchievement in Static.instance!.achievementsCache {
                let achievementID = lookupAchievement.0
                let achievementGK = lookupAchievement.1
                achievementGK.percentComplete = 0
                achievementGK.showsCompletionBanner = false
                if completion != nil { completion!(achievementGK) }
                EGC.printLogEGC("Reset achievement (\(achievementID))")
            }
            
        })
    }
    
    /*####################################################################################################*/
    /*                                          Mutliplayer                                               */
    /*####################################################################################################*/
    /**
     Find player By number
     
     - parameter minPlayers: Int
     - parameter maxPlayers: Max
     */
    open class func findMatchWithMinPlayers(_ minPlayers: Int, maxPlayers: Int) {
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return
        }
        do {
            let delegatVC = try EGC.sharedInstance.getDelegate()
            
            
            EGC.disconnectMatch()
            
            let request = GKMatchRequest()
            request.minPlayers = minPlayers
            request.maxPlayers = maxPlayers
            
            
            let controlllerGKMatch = GKMatchmakerViewController(matchRequest: request)
            controlllerGKMatch!.matchmakerDelegate = EGC.sharedInstance
            
            var delegeteParent:UIViewController? = delegatVC.parent
            if delegeteParent == nil {
                delegeteParent = delegatVC
            }
            delegeteParent!.present(controlllerGKMatch!, animated: true, completion: nil)
            
        } catch EGCError.noDelegate {
            EGCError.noDelegate.errorCall()
            
        } catch {
            fatalError("Dont work\(error)")
        }
    }
    /**
     Get Player in match
     
     - returns: Set<GKPlayer>
     */
    open class func getPlayerInMatch() -> Set<GKPlayer>? {
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return nil
        }
        
        guard EGC.sharedInstance.match != nil && EGC.sharedInstance.playersInMatch.count > 0  else {
            EGC.printLogEGC("No Match")
            return nil
        }
        
        return EGC.sharedInstance.playersInMatch
    }
    /**
     Deconnect the Match
     */
    open class func disconnectMatch() {
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return
        }
        guard let match = EGC.sharedInstance.match else {
            return
        }
        
        EGC.printLogEGC("Disconnect from match")
        match.disconnect()
        EGC.sharedInstance.match = nil
        (self.delegate as? EGCDelegate)?.EGCMatchEnded?()
        
    }
    /**
     Get match
     
     - returns: GKMatch or nil if haven't match
     */
    open class func getMatch() -> GKMatch? {
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return nil
        }
        
        guard let match = EGC.sharedInstance.match else {
            EGC.printLogEGC("No Match")
            return nil
        }
        
        return match
    }
    /**
     player in net
     */
    @available(iOS 8.0, *)
    fileprivate func lookupPlayers() {
        
        guard let match =  EGC.sharedInstance.match else {
            EGC.printLogEGC("No Match")
            return
        }
        
        
        let playerIDs = match.players.map { $0.playerID }
        
        guard let hasePlayerIDS = playerIDs as? [String] else {
            EGC.printLogEGC("No Player")
            return
        }
        
        /* Load an array of player */
        GKPlayer.loadPlayers(forIdentifiers: hasePlayerIDS) {
            (players, error) in
            
            guard error == nil else {
                EGC.printLogEGC("Error retrieving player info: \(error!.localizedDescription)")
                EGC.disconnectMatch()
                return
            }
            
            guard let players = players else {
                EGC.printLogEGC("Error retrieving players; returned nil")
                return
            }
            if EGC.debugMode {
                for player in players {
                    EGC.printLogEGC("Found player: \(String(describing: player.alias))")
                }
            }
            
            if let arrayPlayers = players as [GKPlayer]? { self.playersInMatch = Set(arrayPlayers) }
            
            GKMatchmaker.shared().finishMatchmaking(for: match)
            (Static.delegate as? EGCDelegate)?.EGCMatchStarted?()
            
        }
    }
    
    /**
     Transmits data to all players connected to the match.
     
     - parameter data:     NSData
     - parameter modeSend: GKMatchSendDataMode
     
     :GKMatchSendDataMode Reliable: a.s.a.p. but requires fragmentation and reassembly for large messages, may stall if network congestion occurs
     :GKMatchSendDataMode Unreliable: Preferred method. Best effort and immediate, but no guarantees of delivery or order; will not stall.
     */
    open class func sendDataToAllPlayers(_ data: Data!, modeSend:GKMatch.SendDataMode) {
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return
        }
        guard let match = EGC.sharedInstance.match else {
            EGC.printLogEGC("No Match")
            return
        }
        
        do {
            try match.sendData(toAllPlayers: data, with: modeSend)
            EGC.printLogEGC("Succes sending data all Player")
        } catch  {
            EGC.disconnectMatch()
            (Static.delegate as? EGCDelegate)?.EGCMatchEnded?()
            EGC.printLogEGC("Fail sending data all Player")
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*####################################################################################################*/
    /*                                    Singleton  Private  Instance                                    */
    /*####################################################################################################*/
    
    /// ShareInstance Private
    class fileprivate var sharedInstance : EGC {
        
        guard let instance = Static.instance else {
            EGCError.error("No Instance, please sharedInstance of EasyGameCenter").errorCall()
            fatalError("No Instance, please sharedInstance of EasyGameCenter")
        }
        return instance
    }
    /**
     Delegate UIViewController
     
     
     - throws: .NoDelegate
     
     - returns: UIViewController
     */
    fileprivate func getDelegate() throws -> UIViewController {
        guard let delegate = Static.delegate else {
            throw EGCError.noDelegate
        }
        return delegate
    }
    
    /*####################################################################################################*/
    /*                                            private Start                                           */
    /*####################################################################################################*/
    /**
     Init Implemented by subclasses to initialize a new object
     
     - returns: An initialized object
     */
    //override init() { super.init() }
    
    /**
     Completion for cachin Achievements and AchievementsDescription
     
     - parameter achievementsType: GKAchievement || GKAchievementDescription
     */
    fileprivate static func completionCachingAchievements(_ achievementsType :[AnyObject]?) {
        
        func finish() {
            if EGC.sharedInstance.achievementsCache.count > 0 &&
                EGC.sharedInstance.achievementsDescriptionCache.count > 0 {
                
                (Static.delegate as? EGCDelegate)?.EGCInCache?()
                
            }
        }
        
        
        // Type GKAchievement
        if achievementsType is [GKAchievement] {
            
            guard let arrayGKAchievement = achievementsType as? [GKAchievement], arrayGKAchievement.count > 0 else {
                EGCError.cantCachingGKAchievement.errorCall()
                return
            }
            
            for anAchievement in arrayGKAchievement where  anAchievement.identifier != nil {
                EGC.sharedInstance.achievementsCache[anAchievement.identifier] = anAchievement
            }
            finish()
            
            // Type GKAchievementDescription
        } else if achievementsType is [GKAchievementDescription] {
            
            guard let arrayGKAchievementDes = achievementsType as? [GKAchievementDescription], arrayGKAchievementDes.count > 0 else {
                EGCError.cantCachingGKAchievementDescription.errorCall()
                return
            }
            
            for anAchievementDes in arrayGKAchievementDes where  anAchievementDes.identifier != nil {
                
                // Add GKAchievement
                if EGC.sharedInstance.achievementsCache.index(forKey: anAchievementDes.identifier) == nil {
                    EGC.sharedInstance.achievementsCache[anAchievementDes.identifier] = GKAchievement(identifier: anAchievementDes.identifier)
                    
                }
                // Add CGAchievementDescription
                EGC.sharedInstance.achievementsDescriptionCache[anAchievementDes.identifier] = anAchievementDes
            }
            
            GKAchievement.loadAchievements(completionHandler: {
                (allAchievements, error) in
                
                guard (error == nil) && allAchievements!.count != 0  else {
                    finish()
                    return
                }
                
                EGC.completionCachingAchievements(allAchievements)
                
            })
        }
    }
    
    
    
    /**
     Load achievements in cache
     (Is call when you init EGC, but if is fail example for cut connection, you can recall)
     And when you get Achievement or all Achievement, it shall automatically cached
     
     */
    fileprivate func cachingAchievements() {
        guard EGC.isConnectedToNetwork else {
            EGCError.noConnection.errorCall()
            return
        }
        guard EGC.isPlayerIdentified else {
            EGCError.notLogin.errorCall()
            return
        }
        // Load GKAchievementDescription
        GKAchievementDescription.loadAchievementDescriptions(completionHandler: {
            (achievementsDescription, error) in
            guard error == nil else {
                EGCError.error(error?.localizedDescription).errorCall()
                return
            }
            EGC.completionCachingAchievements(achievementsDescription)
        })
    }
    /**
     Login player to GameCenter With Handler Authentification
     This function is recall When player connect to Game Center
     
     - parameter completion: (Bool) if player login to Game Center
     */
    /// Authenticates the user with their Game Center account if possible
    
    // MARK: Internal functions
    
    @objc internal func authenticationChanged() {
        guard let delegateEGC = Static.delegate as? EGCDelegate else {
            return
        }
        if EGC.isPlayerIdentified {
            delegateEGC.EGCAuthentified?(true)
            EGC.sharedInstance.cachingAchievements()
        } else {
            delegateEGC.EGCAuthentified?(false)
        }
    }
    
    fileprivate func loginPlayerToGameCenter()  {
        
        guard !EGC.isPlayerIdentified else {
            return
        }
        
        guard let delegateVC = Static.delegate  else {
            EGCError.noDelegate.errorCall()
            return
        }
        
        guard EGC.isConnectedToNetwork else {
            EGCError.noConnection.errorCall()
            return
        }
        
        GKLocalPlayer.local.authenticateHandler = {
            (gameCenterVC, error) in
            
            guard error == nil else {
                EGCError.error("User has canceled authentication").errorCall()
                return
            }
            guard let gcVC = gameCenterVC else {
                return
            }
            if EGC.showLoginPage {
                DispatchQueue.main.async {
                    delegateVC.present(gcVC, animated: true, completion: nil)
                }
            }
            
            
        }
    }
    
    /*####################################################################################################*/
    /*                              Private Timer checkup                                                 */
    /*####################################################################################################*/
    /**
     Function checkup when he have net work login Game Center
     */
    @objc func checkupNetAndPlayer() {
        DispatchQueue.main.async {
            if self.timerNetAndPlayer == nil {
                self.timerNetAndPlayer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EGC.checkupNetAndPlayer), userInfo: nil, repeats: true)
            }
            
            if EGC.isConnectedToNetwork {
                self.timerNetAndPlayer!.invalidate()
                self.timerNetAndPlayer = nil
                
                EGC.sharedInstance.loginPlayerToGameCenter()
            }
        }
    }
    
    /*####################################################################################################*/
    /*                                      Private Func Achievements                                     */
    /*####################################################################################################*/
    /**
     Report achievement classic
     
     - parameter achievement: GKAchievement
     */
    fileprivate func reportAchievementToGameCenter(achievement:GKAchievement) {
        /* try to report the progress to the Game Center */
        
        GKAchievement.report([achievement], withCompletionHandler:  {
            (error:Error?) -> Void in
            if error != nil { /* Game Center Save Automatique */ }
        })
    }
    /*####################################################################################################*/
    /*                             Public Delagate Game Center                                          */
    /*####################################################################################################*/
    /**
     Dismiss Game Center when player open
     - parameter GKGameCenterViewController:
     
     Override of GKGameCenterControllerDelegate
     
     */
    open func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    /*####################################################################################################*/
    /*                                          GKMatchDelegate                                           */
    /*####################################################################################################*/
    /**
     Called when data is received from a player.
     
     - parameter theMatch: GKMatch
     - parameter data:     NSData
     - parameter playerID: String
     */
    open func match(_ theMatch: GKMatch, didReceive data: Data, fromPlayer playerID: String) {
        guard EGC.sharedInstance.match == theMatch else {
            return
        }
        (Static.delegate as? EGCDelegate)?.EGCMatchRecept?(theMatch, didReceiveData: data, fromPlayer: playerID)
        
    }
    /**
     Called when a player connects to or disconnects from the match.
     
     Echange avec autre players
     
     - parameter theMatch: GKMatch
     - parameter playerID: String
     - parameter state:    GKPlayerConnectionState
     */
    
    open func match(_ theMatch: GKMatch, player playerID: String, didChange state: GKPlayerConnectionState) {
        /* recall when is desconnect match = nil */
        guard self.match == theMatch else {
            return
        }
        
        switch state {
            /* Connected */
        case .connected where self.match != nil && theMatch.expectedPlayerCount == 0:
            if #available(iOS 8.0, *) {
                self.lookupPlayers()
            }
            /* Lost deconnection */
        case .disconnected:
            EGC.disconnectMatch()
        default:
            break
        }
    }
    /**
     Called when the match cannot connect to any other players.
     
     - parameter theMatch: GKMatch
     - parameter error:    NSError
     
     */
    open func match(_ theMatch: GKMatch, didFailWithError error: Error?) {
        guard self.match == theMatch else {
            return
        }
        
        guard error == nil else {
            EGCError.error("Match failed with error: \(String(describing: error?.localizedDescription))").errorCall()
            EGC.disconnectMatch()
            return
        }
    }
    
    /*####################################################################################################*/
    /*                            GKMatchmakerViewControllerDelegate                                      */
    /*####################################################################################################*/
    /**
     Called when a peer-to-peer match is found.
     
     - parameter viewController: GKMatchmakerViewController
     - parameter theMatch:       GKMatch
     */
    open func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind theMatch: GKMatch) {
        viewController.dismiss(animated: true, completion: nil)
        self.match = theMatch
        self.match!.delegate = self
        if match!.expectedPlayerCount == 0 {
            if #available(iOS 8.0, *) {
                self.lookupPlayers()
            }
        }
    }
    
    
    /*####################################################################################################*/
    /*                             GKLocalPlayerListener                                                  */
    /*####################################################################################################*/
    /**
     Called when another player accepts a match invite from the local player
     
     - parameter player:         GKPlayer
     - parameter inviteToAccept: GKPlayer
     */
    open func player(_ player: GKPlayer, didAccept inviteToAccept: GKInvite) {
        guard let gkmv = GKMatchmakerViewController(invite: inviteToAccept) else {
            EGCError.error("GKMatchmakerViewController invite to accept nil").errorCall()
            return
        }
        gkmv.matchmakerDelegate = self
        
        var delegeteParent:UIViewController? = EGC.delegate.parent
        if delegeteParent == nil {
            delegeteParent = EGC.delegate
        }
        delegeteParent!.present(gkmv, animated: true, completion: nil)
    }
    /**
     Initiates a match from Game Center with the requested players
     
     - parameter player:          The GKPlayer object containing the current player’s information
     - parameter playersToInvite: An array of GKPlayer
     */
    open func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) { }
    
    /**
     Called when the local player starts a match with another player from Game Center
     
     - parameter player:            The GKPlayer object containing the current player’s information
     - parameter playerIDsToInvite: An array of GKPlayer
     */
    open func player(_ player: GKPlayer, didRequestMatchWithPlayers playerIDsToInvite: [String]) { }
    
    /*####################################################################################################*/
    /*                            GKMatchmakerViewController                                              */
    /*####################################################################################################*/
    /**
     Called when the user cancels the matchmaking request (required)
     
     - parameter viewController: GKMatchmakerViewController
     */
    open func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        (Static.delegate as? EGCDelegate)?.EGCMatchCancel?()
        EGC.printLogEGC("Player cancels the matchmaking request")
        
    }
    /**
     Called when the view controller encounters an unrecoverable error.
     
     - parameter viewController: GKMatchmakerViewController
     - parameter error:          NSError
     */
    open func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        
        viewController.dismiss(animated: true, completion: nil)
        (Static.delegate as? EGCDelegate)?.EGCMatchCancel?()
        EGCError.error("Error finding match: \(error.localizedDescription)\n").errorCall()
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
/*####################################################################################################*/
/*                                          Debug                                                     */
/*####################################################################################################*/

// MARK: - Extension EGC Debug
extension EGC {
    /**
     Print
     
     - parameter object: Any
     */
    fileprivate class func printLogEGC(_ object: Any) {
        if EGC.debugMode {
            DispatchQueue.main.async {
                Swift.print("\n[Easy Game Center] \(object)\n")
            }
        }
    }
}
// MARK: - Debug  /  Error Func
extension EGC {
    /**
     ErrorType debug
     
     - Error:                               Some Error
     - CantCachingGKAchievementDescription: Cant caching GKAchievements Des
     - CantCachingGKAchievement:            Cant caching GKAchievements
     - NoAchievement:                       No Achievement create
     - Empty:                               Param empty
     - NoConnection:                        No internet
     - NotLogin:                            No login
     - NoDelegate:                          No Delegate
     */
    fileprivate enum EGCError : Error {
        case error(String?)
        case cantCachingGKAchievementDescription
        case cantCachingGKAchievement
        case noAchievement
        case empty
        case noConnection
        case notLogin
        case noDelegate
        
        /// Description
        var description : String {
            
            switch self {
                
            case .error(let error):
                return (error != nil) ? "\(error!)" : "\(String(describing: error))"
                
            case .cantCachingGKAchievementDescription:
                return "Can't caching GKAchievementDescription\n( Have you create achievements in ItuneConnect ? )"
                
            case .cantCachingGKAchievement:
                return "Can' t caching GKAchievement\n( Have you create achievements in ItuneConnect ? )"
                
            case .noAchievement:
                return "No GKAchievement and GKAchievementDescription\n\n( Have you create achievements in ItuneConnect ? )"
                
            case .noConnection:
                return "No internet connection"
                
            case .notLogin:
                return "User is not identified to game center"
                
            case .noDelegate :
                return "\nDelegate UIViewController not added"
                
            case .empty:
                return "\nThe parameter is empty"
            }
        }
        /**
         Print Debug Enum error
         
         - parameter error: EGCError
         */
        fileprivate func printError(_ error: EGCError) {
            EGC.printLogEGC(error.description)
        }
        /**
         Print self enum error
         */
        fileprivate func printError() {
            EGC.printLogEGC(self.description)
        }
        /**
         Handler error
         */
        fileprivate func errorCall() {
            
            defer { self.printError() }
            
            switch self {
            case .notLogin:
                (EGC.delegate  as? EGCDelegate)?.EGCAuthentified?(false)
                break
            case .cantCachingGKAchievementDescription:
                EGC.sharedInstance.checkupNetAndPlayer()
                break
            case .cantCachingGKAchievement:
                
                break
            default:
                break
            }
        }
    }
    
}
