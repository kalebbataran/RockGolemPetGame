//
//  MonsterImg.swift
//  PetGame
//
//  Created by Kaleb Bataran on 3/5/16.
//  Copyright © 2016 kaydot. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		playIdleAnimation()
	}
	
	func playIdleAnimation() {
		
		self.image = UIImage(named: "idlerock1")
		self.animationImages = nil
		
		var imgArray = [UIImage]()
		for var x = 1; x <= 4; x++ {
			let img = UIImage(named: "idlerock\(x)")
			imgArray.append(img!)
		}
		
		self.animationImages = imgArray
		self.animationDuration = 0.7
		self.animationRepeatCount = 0
		self.startAnimating()
	}
	
	func playDeathAnimation() {
		
		self.image = UIImage(named: "deadrock5")
		self.animationImages = nil
		
		var imgArray = [UIImage]()
		for var x = 1; x <= 5; x++ {
			let img = UIImage(named: "deadrock\(x)")
			imgArray.append(img!)
		}
		
		self.animationImages = imgArray
		self.animationDuration = 0.7
		self.animationRepeatCount = 1
		self.startAnimating()
	}
	
	func playRebirthAnimation() {
		
		self.image = UIImage(named: "idlerock1")
		self.animationImages = nil
		
		var imgArray = [UIImage]()
		for var x = 5; x >= 1; x-- {
			let img = UIImage(named: "deadrock\(x)")
			imgArray.append(img!)
		}
		
		self.animationImages = imgArray
		self.animationDuration = 0.9
		self.animationRepeatCount = 1
		self.startAnimating()
	}
}