//
//  GameScene.swift
//  Snake
//
//  Created by KONSTANTIN TISHCHENKO on 31.07.2021.
//

import SpriteKit
import GameplayKit
import UIKit

struct COllisionCategary {
    static let Snake: UInt32 = 0x1 << 0 //0001 1
    static let SnakeHead: UInt32 = 0x1 << 1 //0010 2
    static let Apple: UInt32 = 0x1 << 2 //0100 4
    static let EdgeBody: UInt32 = 0x1 << 3 //1000 8
}

class GameScene: SKScene {
    
    var snake: Snake?
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.1488249898, green: 0.1894520223, blue: 0.2775300741, alpha: 1)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.allowsRotation = false
        
        view.showsPhysics = true
        
        
        let counterClockWise = SKShapeNode()
        counterClockWise.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 60, height: 60)).cgPath
        counterClockWise.position = CGPoint(x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30)
        counterClockWise.fillColor = UIColor.white
        counterClockWise.strokeColor = UIColor.black
//        counterClockWise.lineWidth = 10
        counterClockWise.name = "counterClockWise"
        let image = UIImage.init(systemName: "arrow.uturn.left.circle")
        counterClockWise.fillTexture = SKTexture.init(image: image!)
        self.addChild(counterClockWise)
        
        let clockButton = SKShapeNode()
        clockButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 60, height: 60)).cgPath
        clockButton.position = CGPoint(x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY + 30)
        clockButton.name = "clockButton"
        clockButton.strokeColor = UIColor.black
        clockButton.fillColor = UIColor.white
        let image2 = UIImage.init(systemName: "arrow.uturn.right.circle")
        clockButton.fillTexture = SKTexture.init(image: image2!)
        self.addChild(clockButton)
        
        createApple()
        
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        self.addChild(snake!)
        
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.categoryBitMask = COllisionCategary.EdgeBody
        self.physicsBody?.collisionBitMask = COllisionCategary.Snake | COllisionCategary.SnakeHead
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard let touchesNode = self.atPoint(touchLocation) as? SKShapeNode, touchesNode.name == "counterClockWise" || touchesNode.name == "clockButton" else {
                return
            }
            
            touchesNode.fillColor = .blue
            
            if touchesNode.name == "counterClockWise" {
                snake!.moveCOunterClockWise()
            } else if touchesNode.name == "clockButton" {
                snake!.moveClockwise()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard let touchesNode = self.atPoint(touchLocation) as? SKShapeNode, touchesNode.name == "counterClockWise" || touchesNode.name == "clockButton" else {
                return
            }
            
            touchesNode.fillColor = .orange
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func createApple() {
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)))
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)))
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        self.addChild(apple)
    }
    
    override func update(_ currentTime: TimeInterval) {
        snake!.move()
    }
}

var appleCount = 0

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let collisionObject = bodyes - COllisionCategary.SnakeHead
        
        switch collisionObject {
        case COllisionCategary.Apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            appleCount += 1
            createApple()
        case COllisionCategary.EdgeBody:
            snake?.removeAllChildren()
            let alert = UIAlertController(title: "Игра окончена", message: "Вы съели \(appleCount) яблок(-a).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: { (action: UIAlertAction!) in
                appleCount = 0
                self.newGame()
            }))
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        default:
            break
            
        }
    }
    
    func newGame() {
        guard let scene = scene else { return }
        snake = Snake(atPoint: CGPoint(x: scene.frame.midX, y: scene.frame.midY))
        sleep(1)
        self.addChild(snake!)
    }
}
