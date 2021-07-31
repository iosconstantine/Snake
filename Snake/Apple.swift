//
//  Apple.swift
//  Snake
//
//  Created by KONSTANTIN TISHCHENKO on 31.07.2021.
//

import UIKit
import SpriteKit

class Apple: SKShapeNode {
    init(position: CGPoint) {
        super.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        fillColor = #colorLiteral(red: 0.8843254447, green: 0.2396119833, blue: 0.1954329312, alpha: 1)
        strokeColor = #colorLiteral(red: 0.8843254447, green: 0.2396121025, blue: 0.2007003427, alpha: 1)
        lineWidth = 5
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 8.0, center: CGPoint(x: 5, y: 5))
        self.physicsBody?.categoryBitMask = COllisionCategary.Apple
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
