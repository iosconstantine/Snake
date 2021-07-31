//
//  SnakeBodyPart.swift
//  Snake
//
//  Created by KONSTANTIN TISHCHENKO on 31.07.2021.
//

import UIKit
import SpriteKit

class SnakeBodyPart:  SKShapeNode {
    let diametr = 10
    
    init(atPOint point: CGPoint) {
        super.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diametr, height: diametr)).cgPath
        fillColor = #colorLiteral(red: 0.2728336453, green: 0.5556452274, blue: 0.3589534163, alpha: 1)
        strokeColor = #colorLiteral(red: 0.2728336453, green: 0.5556452274, blue: 0.3589534163, alpha: 1)
        lineWidth = 5
        
        self.position = point
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(diametr - 4), center: CGPoint(x: 5, y: 5))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = COllisionCategary.Snake
        
        self.physicsBody?.contactTestBitMask = COllisionCategary.EdgeBody | COllisionCategary.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
