//
//  ViewController.swift
//  Test 3D Touch
//
//  Created by Mani Batra on 5/11/2015.
//  Copyright © 2015 Mani Batra. All rights reserved.
//

import UIKit
import KYCircularProgress

class ViewController: UIViewController  {
    
    private var halfCircularProgress: KYCircularProgress!
    private var progress: Double = 0.0
    private var currentAlarm: Alarm!
    private var alarmOn = 1
    
    @IBOutlet weak var ForceTester: UILabel!
    @IBOutlet weak var ForceValue: UILabel!
    
    @IBOutlet weak var timeDisplayHours: UILabel!
    @IBOutlet weak var timeDisplayMinutes: UILabel!
    @IBOutlet weak var timeDisplayMode: UILabel!
    @IBOutlet weak var timeDisplayView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
            
            ForceValue.text = "May the Force Be with YOu"
            
        }
        
        currentAlarm = Alarm.init(hours: "5", minutes: "38", mode: "PM")
        timeDisplayHours.text = currentAlarm.getHours()
        timeDisplayMinutes.text = currentAlarm.getMinutes()
        timeDisplayMode.text = currentAlarm.getMode()
        configureHalfCircularProgress()
        updateProgress(0)
        
        // NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { // 1
            dispatch_async(dispatch_get_main_queue()) { // 2
                let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkAlarm", userInfo: nil, repeats: true)
                timer.fire()
            }
        }
        
        
    }
    
    private func configureHalfCircularProgress() {
        
        let progressFrame = CGRectMake(0, timeDisplayView.frame.origin.y + timeDisplayView.frame.height*2, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/4)
        halfCircularProgress = KYCircularProgress(frame: progressFrame, showProgressGuide: true)
        
        let center = CGPoint(x: view.frame.midX, y: 140.0)
        halfCircularProgress.path = UIBezierPath(arcCenter: center, radius: CGFloat(CGRectGetWidth(halfCircularProgress.frame)/3), startAngle: CGFloat(M_PI), endAngle: CGFloat(0.0), clockwise: true)
        
        halfCircularProgress.colors = [UIColor(rgba: 0xA6E39DAA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABAA)]
        
        halfCircularProgress.lineWidth = 8.0
        
        halfCircularProgress.progressGuideColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
        
        
        
        let textLabel = UILabel(frame: CGRectMake(halfCircularProgress.frame.midX - 40.0, halfCircularProgress.bounds.origin.y + halfCircularProgress.frame.height/2, 80.0, 32.0))
        textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.greenColor()
        textLabel.alpha = 0.3
        halfCircularProgress.addSubview(textLabel)
        
        halfCircularProgress.progressChangedClosure() {
            (progress: Double, circularView: KYCircularProgress) in
            print("progress: \(progress)")
            textLabel.text = "\(Int(progress * 100.0))%"
        }
        
        self.view.addSubview(halfCircularProgress)
        
    }
    
    func updateProgress(force: CGFloat) {
        
        let forceProgressFactor = 0.150015
        progress = Double(force) * forceProgressFactor
        halfCircularProgress.progress = Double(self.progress)
        
        
        
    }
    
    func checkAlarm() {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), {
            
            let date = NSDate()
            let dateformatter = CFDateFormatterCreate(nil, CFLocaleCopyCurrent(), CFDateFormatterStyle.ShortStyle, CFDateFormatterStyle.ShortStyle)
            let time = CFDateFormatterCreateStringWithDate(nil, dateformatter, date)
            let timeString   = (time as String).componentsSeparatedByString(", ")[1]
            let hours = timeString.componentsSeparatedByString(":")[0]
            let minutes = timeString.componentsSeparatedByString(":")[1].componentsSeparatedByString(" ")[0]
            let mode = timeString.componentsSeparatedByString(":")[1].componentsSeparatedByString(" ")[1]
            if hours == self.currentAlarm.getHours() && minutes == self.currentAlarm.getMinutes() && mode == self.currentAlarm.getMode() && self.alarmOn == 1 {
                
                self.alarmOn = 0
    
                let alert = UIAlertController (title: "Alarm Time", message: "Wakey Wakey!!", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                
                
                alert.addAction(UIAlertAction(title: "Shut Up", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                    
                }))

                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    
                    self.presentViewController(alert, animated: true, completion: nil)

                    
                })
                
            }
            
            
        })
        
        
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.ForceValue.text = "Return of the Jedi ?"
        self.progress = 0.0
        updateProgress(0)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        for touch in touches {
            
            let touchPoint = touch.locationInView(self.view)
            
            if CGRectContainsPoint(ForceTester.frame, touchPoint) {
                
                ForceValue.text = "\(touch.force)"
                updateProgress(touch.force)
                
            }
            
            
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if traitCollection.forceTouchCapability != UIForceTouchCapability.Available {
            
            ForceValue.text = "The Empire Strikes Back"
        }
    }
    
    
    
    
}

