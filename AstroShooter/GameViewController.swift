//
//  GameViewController.swift
//  AstroShooter
//
//  Created by Julian Abhari on 10/18/15.
//  Copyright (c) 2015 Julian Abhari. All rights reserved.
//

import UIKit
import SpriteKit



class GameViewController: UIViewController {
    
    
    var scene: GameScene!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure the view
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        //create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        //present the scene
        skView.presentScene(scene)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
}

