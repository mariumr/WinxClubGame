//
//  GameScene.swift
//  MariumMidterm2020
//
//  Created by Xcode User on 2020-10-22.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import SpriteKit
import GameplayKit

//used to track what was hit and what it hit
struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Baddy : UInt32 = 0b1
    static let Hero : UInt32 = 0b10
    static let fifth : UInt32 = 1
}

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var background = SKSpriteNode(imageNamed: "background.jpg")
    private var sportNode : SKSpriteNode?
    
    private var score : Int?
    private var highscore : Int?
    let scoreIncerement = 10
    private var lblScore : SKLabelNode?
    private var lblHighScore : SKLabelNode?
    
    
    
    override func sceneDidLoad() {

        background.position = CGPoint(x : frame.size.width/2, y: frame.size.height/2)
        background.size = CGSize(width : frame.size.width, height: frame.size.height)
        addChild(background)
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        sportNode = SKSpriteNode(imageNamed: "bell.png")
        sportNode?.position = CGPoint(x: 100, y:100)
        sportNode?.size = CGSize(width: 300, height: 350)
        addChild(sportNode!)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self;
        
        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius: (sportNode?.size.width)!/2)
        sportNode?.physicsBody?.isDynamic = true
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Baddy
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBadFaries) , SKAction.wait(forDuration: 0.75)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addGoodfairyToCollide) , SKAction.wait(forDuration: 1.0)])))
        
        score = 0
        self.lblScore = self.childNode(withName: "//score") as? SKLabelNode
        self.lblScore?.text = "Score: \(score!)"
        
        if let slabel = self.lblScore {
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
            
        }
        
        highscore = 1736282
        self.lblHighScore = self.childNode(withName: "//highscore") as? SKLabelNode
        self.lblHighScore?.text = "High Score : \(highscore!)"
        if let shlabel = self.lblHighScore {
            shlabel.alpha = 0.0
            shlabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
    
    //bad fairy
    func addBadFaries(){
        let baddy = SKSpriteNode(imageNamed:"3d-villian.png")
        baddy.yScale = baddy.yScale
        let actualX = random(min: baddy.size.height/2, max: size.height-baddy.size.height/2)
        baddy.position = CGPoint(x: actualX , y: size.height + baddy.size.height/2)
        baddy.size = CGSize(width: 500, height: 250)
        addChild(baddy)
        
        // force feild around the bad fairy
        baddy.physicsBody = SKPhysicsBody(rectangleOf: baddy.size)
        baddy.physicsBody?.isDynamic = true;
        // physics category.baddy was hit
        baddy.physicsBody?.categoryBitMask = PhysicsCategory.Baddy
        baddy.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        //test with contact with fairy
        baddy.physicsBody?.collisionBitMask = PhysicsCategory.None
    
        let actualDuration = random(min: CGFloat(2.0) , max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX , y : -baddy.size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveHorizontal = SKAction.moveBy(x: size.width, y: size.width, duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        baddy.run(SKAction.sequence([actionMove, actionMoveDone]))
        baddy.run(SKAction.sequence([actionMoveHorizontal , actionMoveDone]))
        
       }
    
    //every fifth object dropped
    func addGoodfairyToCollide() {
        let fifth = SKSpriteNode(imageNamed:"flora.png")
        fifth.yScale = fifth.yScale
        let actualX = random(min: fifth.size.height/2, max: size.height-fifth.size.height/2)
        fifth.position = CGPoint(x: size.width , y: size.height + fifth.size.height/4)
        fifth.size = CGSize(width: 500, height: 250)
        addChild(fifth)
        
        // force feild around the fifth fairy
        fifth.physicsBody = SKPhysicsBody(rectangleOf: fifth.size)
        fifth.physicsBody?.isDynamic = true;
        // physics category.fifth was hit
        fifth.physicsBody?.categoryBitMask = PhysicsCategory.Baddy
        fifth.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        //test with contact with fairy
        fifth.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actualDuration = random(min: CGFloat(2.0) , max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX , y : -fifth.size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveHorizontal = SKAction.moveBy(x: size.width, y: size.width, duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        fifth.run(SKAction.sequence([actionMove, actionMoveDone]))
        fifth.run(SKAction.sequence([actionMoveHorizontal , actionMoveDone]))
    }
    
    func moveWinx(toPoint  pos : CGPoint) {
        let actionMove = SKAction.move(to: pos, duration: TimeInterval(2.0))
        
        let actionMoveDone = SKAction.rotate(byAngle: (180.0), duration: TimeInterval(0.5))
        sportNode?.run(SKAction.sequence([actionMove,actionMoveDone]))
        
    }
    
    func heroDidCollide(hero : SKSpriteNode , fifth : SKSpriteNode)  {
        print("hit")
        
        score = score! + scoreIncerement
        
        self.lblScore?.text = "Score: \(score!)"
        
        if (highscore! < score!){
            highscore  = score
            self.lblHighScore?.text = "High Score : \(highscore!)"
            if let shlabel = self.lblHighScore {
                shlabel.alpha = 0.0
                shlabel.run(SKAction.fadeOut(withDuration: 2.0))
                
            }
            
        }
        if let slabel = self.lblScore {
            slabel.alpha = 0.0
            slabel.run(SKAction.fadeIn(withDuration: 2.0))
    }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstbody : SKPhysicsBody
        var secondbody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstbody = contact.bodyA
            secondbody = contact.bodyB
        }
        else  {
            firstbody = contact.bodyB
            secondbody = contact.bodyA
        }
        
        
        if((firstbody.categoryBitMask & PhysicsCategory.Baddy != 0) && (secondbody.categoryBitMask & PhysicsCategory.Hero != 0))  {
            heroDidCollide(hero: firstbody.node as! SKSpriteNode, fifth: secondbody.node as! SKSpriteNode)
        }
        
    }
    
    
   func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    
        moveWinx(toPoint: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
        
        moveWinx(toPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}


