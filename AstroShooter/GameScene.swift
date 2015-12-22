//
//  GameScene.swift
//  AstroShooter
//
//  Created by Julian Abhari on 10/18/15.
//  Copyright (c) 2015 Julian Abhari. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Enemy : UInt32 = 1
    static let Bullet : UInt32 = 2
    static let Player : UInt32 = 3
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Score = Int()
    var Player = SKSpriteNode(imageNamed: "Person.png")
    var scoreLabel = UILabel()
    var gameOverLabel = UILabel()
    var isGameOver = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.contactDelegate = self
        
        Player.position = CGPointMake(self.size.width/2, self.size.height/5)
        Player.physicsBody = SKPhysicsBody(rectangleOfSize: Player.size)
        Player.physicsBody!.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        Player.physicsBody?.dynamic = false
        
        self.addChild(Player)
        
        var Timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("spawnBullet"), userInfo: nil, repeats: true)
        
        var EnemyTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("spawnEnemies"), userInfo: nil, repeats: true)
        
        scoreLabel.text = "\(Score)"
        scoreLabel = UILabel(frame: CGRect(x: 30, y: 50, width: 100, height: 20))
        scoreLabel.backgroundColor = UIColor.clearColor()
        scoreLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(scoreLabel)
        
        gameOverLabel.text = "Game Over"
        gameOverLabel = UILabel(frame: CGRect(x: 150, y: 100, width: 100, height: 20))
        gameOverLabel.backgroundColor = UIColor.clearColor()
        gameOverLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(gameOverLabel)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Bullet)) || ((firstBody.categoryBitMask == PhysicsCategory.Bullet) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
            
            CollisionWithBullet(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
        }
            
            
        else if ((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Player)) || ((firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)){
            
            CollisionWithPerson(firstBody.node as! SKSpriteNode, Person: secondBody.node as! SKSpriteNode)
            
            
        }
    }
    
    func CollisionWithPerson(Enemy: SKSpriteNode, Person: SKSpriteNode) {
        Enemy.removeFromParent()
        Person.removeFromParent()
        
        gameOver()
        
    }
    
    func CollisionWithBullet(Enemy: SKSpriteNode, Bullet: SKSpriteNode) {
        Enemy.removeFromParent()
        Bullet.removeFromParent()
        Score++
        
        scoreLabel.text = "\(Score)"
    }
    
    func spawnBullet() {
        
        let Bullet = SKSpriteNode(imageNamed: "Bullet.png")
        Bullet.zPosition = -5
        Bullet.position = CGPointMake(Player.position.x, Player.position.y)
        
        let action = SKAction.moveToY(self.size.height + 30, duration: 0.8)
        let actionDone = SKAction.removeFromParent()
        Bullet.runAction(SKAction.sequence([action, actionDone]))
        self.addChild(Bullet)
        Bullet.physicsBody = SKPhysicsBody(rectangleOfSize: Bullet.size)
        Bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.dynamic = false
        if isGameOver == true {
            
            self.removeAllChildren()
        }
        
    }
    
    func spawnEnemies() {
        
        let Enemy = SKSpriteNode(imageNamed: "Enemy")
        let MinValue = self.size.width / 8
        let MaxValue = self.size.width - 20
        let SpawnPoint = UInt32(MaxValue - MinValue)
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: self.size.height)
        Enemy.physicsBody = SKPhysicsBody(rectangleOfSize: Enemy.size)
        Enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        Enemy.physicsBody!.affectedByGravity = false
        Enemy.physicsBody?.dynamic = true
        
        let action = SKAction.moveToY(-70, duration: 1.5)
        let actionDone = SKAction.removeFromParent()
        Enemy.runAction(SKAction.sequence([action, actionDone]))
        
        self.addChild(Enemy)
        if isGameOver == true {
            
            self.removeAllChildren()
        }
        
    }
    
    func gameOver() {
        isGameOver = true
        
        gameOverLabel.text = "Game Over"
    }
    
    func restart() {
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .AspectFill
        
        view!.presentScene(newScene)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if isGameOver {
            restart()
        }
        
        else {
            for touch in touches {
                let location = touch.locationInNode(self)
                
                Player.position.x = location.x
            }
            
        }
        
    }
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        for touch in touches {
            let location = touch.locationInNode(self)
            
            Player.position.x = location.x
            
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
