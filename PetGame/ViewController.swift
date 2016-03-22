//
//  ViewController.swift
//  PetGame
//
//  Created by Kaleb Bataran on 3/5/16.
//  Copyright © 2016 kaydot. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

	@IBOutlet weak var rockMonsterImg: MonsterImg!
	@IBOutlet weak var foodImg: DragImg!
	@IBOutlet weak var heartImg: DragImg!
	@IBOutlet weak var ballImg: DragImg!
	
	@IBOutlet weak var skull1: UIImageView!
	@IBOutlet weak var skull2: UIImageView!
	@IBOutlet weak var skull3: UIImageView!
	@IBOutlet weak var resetTxt: UILabel!
	@IBOutlet weak var resetBtn: UIButton!
	
	//Sounds
	var musicPlayer: AVAudioPlayer!
	var sfxFood: AVAudioPlayer!
	var sfxHeart: AVAudioPlayer!
	var sfxBall: AVAudioPlayer!
	var sfxSkull: AVAudioPlayer!
	var sfxDeath: AVAudioPlayer!
	
	var timer: NSTimer!
	var penalties = 0
	var monsterIsHappy = true
	var currentItem = 0
	
	let DIM: CGFloat = 0.3
	let OPAQUE:CGFloat = 1.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		do {
			try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
			try sfxFood = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
			try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
			try sfxBall = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("happy", ofType: "wav")!))
			try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
			try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
			
		} catch let err as NSError{
			print(err.debugDescription)
		}
		musicPlayer.prepareToPlay()
		musicPlayer.volume = 0.6
		musicPlayer.play()
		
		sfxFood.prepareToPlay()
		sfxHeart.prepareToPlay()
		sfxBall.prepareToPlay()
		sfxSkull.prepareToPlay()
		sfxDeath.prepareToPlay()
		
		startGame()
	}
	
	func startGame() {
		
		penalties = 0
		monsterIsHappy = true
		
		foodImg.dropTarget = rockMonsterImg
		foodImg.alpha = DIM
		
		heartImg.dropTarget = rockMonsterImg
		heartImg.alpha = DIM
		
		ballImg.dropTarget = rockMonsterImg
		ballImg.alpha = DIM
		
		skull1.alpha = DIM
		skull2.alpha = DIM
		skull3.alpha = DIM
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter", name: "onTargetDropped", object: nil)
		
		startTimer()
		rockMonsterImg.playIdleAnimation()
	}
	
	func startTimer() {
		if timer != nil {
			timer.invalidate()
		}
		
		timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "updateGame", userInfo: nil, repeats: true)
	}
	
	func updateGame() {
		
		let rand = arc4random_uniform(3)
		currentItem = Int(rand)
		switch rand {
		case 0:
			foodImg.alpha = OPAQUE
			foodImg.userInteractionEnabled = true
			
			heartImg.alpha = DIM
			heartImg.userInteractionEnabled = false
			
			ballImg.alpha = DIM
			ballImg.userInteractionEnabled = false
		case 1:
			heartImg.alpha = OPAQUE
			heartImg.userInteractionEnabled = true
			
			foodImg.alpha = DIM
			foodImg.userInteractionEnabled = false
			
			ballImg.alpha = DIM
			ballImg.userInteractionEnabled = false
		case 2:
			ballImg.alpha = OPAQUE
			ballImg.userInteractionEnabled = true
			
			foodImg.alpha = DIM
			foodImg.userInteractionEnabled = false
			
			heartImg.alpha = DIM
			heartImg.userInteractionEnabled = false
		default:
			break
		}
		
		
		if !monsterIsHappy {
			sfxSkull.play()
			
			penalties++
			switch penalties {
			case 1:
				skull1.alpha = OPAQUE
			case 2:
				skull2.alpha = OPAQUE
			case 3:
				gameOver()
			default:
				break
			}
		}
		
		monsterIsHappy = false
	}
	
	func itemDroppedOnCharacter() {
		monsterIsHappy = true
		
		switch currentItem {
		case 0:
			sfxFood.play()
		case 1:
			sfxHeart.play()
		case 2:
			sfxHeart.play()
		default:
			break
		}
		
		foodImg.alpha = DIM
		foodImg.userInteractionEnabled = false
		
		heartImg.alpha = DIM
		heartImg.userInteractionEnabled = false
		
		ballImg.alpha = DIM
		ballImg.userInteractionEnabled = false
	}
	
	func gameOver() {
		sfxDeath.play()
		timer.invalidate()
		skull3.alpha = OPAQUE
		rockMonsterImg.playDeathAnimation()
		resetTxt.hidden = false
		resetBtn.hidden = false
	}
	
	@IBAction func onResetPressed(sender: AnyObject) {
		rockMonsterImg.playRebirthAnimation()
		sfxBall.play()
		resetBtn.hidden = true
		resetTxt.hidden	= true
		timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: "startGame", userInfo: nil, repeats: false)
	}
}

