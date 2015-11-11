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
    private var touchCounter = 0
    private var hoursCounter0: NSTimer!
    private var hoursCounter1: NSTimer!
    private var hoursCounter2: NSTimer!
    
    
    
    @IBOutlet weak var ForceTester: UILabel!
    @IBOutlet weak var ForceValue: UILabel!
    
    @IBOutlet weak var timeDisplayHours: UILabel!
    @IBOutlet weak var timeDisplayMinutes: UILabel!
    @IBOutlet weak var timeDisplayMode: UILabel!
    @IBOutlet weak var timeDisplayView: UIStackView!
    
    @IBOutlet weak var modeTouchBelow: UILabel!
    @IBOutlet weak var hoursTouchBelow: UILabel!
    @IBOutlet weak var minutesTouchBelow: UILabel!
    @IBOutlet weak var touchBelowView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
            
            ForceValue.text = "May the Force Be with YOu"
            
        }
        
        currentAlarm = Alarm.init(hours: "5", minutes: "00", mode: "PM")
        timeDisplayHours.text = currentAlarm.getHours()
        timeDisplayMinutes.text = currentAlarm.getMinutes()
        timeDisplayMode.text = currentAlarm.getMode()
        
        configureHalfCircularProgress()
        updateProgress(0)
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { // 1
            dispatch_async(dispatch_get_main_queue()) { // 2
                let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkAlarm", userInfo: nil, repeats: true)
                timer.fire()
            }
        }
        
        
    }
    
    private func configureHalfCircularProgress() {
        
        let progressFrame = CGRectMake(0, touchBelowView.frame.origin.y + touchBelowView.frame.height*2, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/4)
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
    
    func updateLabel() {
        var touchedLabel: UILabel!
        if(hoursCounter0 != nil ) {
            touchedLabel = hoursCounter0.userInfo as! UILabel
            
        } else if(hoursCounter1 != nil) {
            touchedLabel = hoursCounter1.userInfo as! UILabel
        } else if(hoursCounter2 != nil) {
            touchedLabel = hoursCounter2.userInfo as! UILabel
        }
        var minuteFlag = 1
        var format = "%1d"
        
        if touchedLabel == timeDisplayMinutes {
            minuteFlag = 5
            format = "%02d"
        }
        var current: Int = Int(touchedLabel.text!)!
        current = ((current % (12 * minuteFlag)) + 1)
        touchedLabel.text = String(format: format, current)
        
        
    }
    
    func changeMode() {
        
        
        if timeDisplayMode.text == "AM" {
            timeDisplayMode.text = "PM"
        } else {
            timeDisplayMode.text = "AM"
        }
        
        
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
        
        print("the touch has ended")
        
        if(hoursCounter0 != nil) {
            hoursCounter0.invalidate()
            hoursCounter0 = nil
        }
        if(hoursCounter1 != nil) {
            hoursCounter1.invalidate()
            hoursCounter1 = nil
        }
        if(hoursCounter2 != nil) {
            hoursCounter2.invalidate()
            hoursCounter2 = nil
        }
        
        
        self.ForceValue.text = "Return of the Jedi ?"
        self.progress = 0.0
        updateProgress(0)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        for touch in touches {
            
            let touchPoint = touch.locationInView(self.view)
            
            if CGRectContainsPoint( CGRectMake(timeDisplayMode.frame.origin.x + timeDisplayView.frame.origin.x, timeDisplayMode.frame.origin.y + timeDisplayView.frame.origin.y, timeDisplayMode.frame.width, timeDisplayMode.frame.height), touchPoint) || CGRectContainsPoint( CGRectMake(modeTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, modeTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, modeTouchBelow.frame.width, modeTouchBelow.frame.height), touchPoint) {
                
                if timeDisplayMode.text == "AM" {
                    timeDisplayMode.text = "PM"
                    break;
                } else {
                    timeDisplayMode.text = "AM"
                    break;
                }
            } else if CGRectContainsPoint( CGRectMake(timeDisplayHours.frame.origin.x + timeDisplayView.frame.origin.x, timeDisplayHours.frame.origin.y + timeDisplayView.frame.origin.y, timeDisplayHours.frame.width, timeDisplayHours.frame.height), touchPoint) {
                
                var currentHours: Int = Int(timeDisplayHours.text!)!
                currentHours = ((currentHours % 12) + 1)
                timeDisplayHours.text = String(currentHours)
                break;
                
            } else if CGRectContainsPoint( CGRectMake(timeDisplayMinutes.frame.origin.x + timeDisplayView.frame.origin.x, timeDisplayMinutes.frame.origin.y + timeDisplayView.frame.origin.y, timeDisplayMinutes.frame.width, timeDisplayMinutes.frame.height), touchPoint) {
                
                var currentMinutes: Int = Int(timeDisplayMinutes.text!)!
                currentMinutes = ((currentMinutes  % 60) + 5)
                if currentMinutes == 60 {
                    timeDisplayMinutes.text = "00"
                } else  {
                    timeDisplayMinutes.text = String(format: "%02d", currentMinutes)
                }
                break;
                
            } else if CGRectContainsPoint( CGRectMake(hoursTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, hoursTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, hoursTouchBelow.frame.width, hoursTouchBelow.frame.height), touchPoint) {
                
                var current: Int = Int(timeDisplayHours.text!)!
                current = ((current % 12) + 1)
                timeDisplayHours.text = String(current)

                
            } else if CGRectContainsPoint( CGRectMake(minutesTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, minutesTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, minutesTouchBelow.frame.width, minutesTouchBelow.frame.height), touchPoint) {
                
                var current: Int = Int(timeDisplayMinutes.text!)!
                current = ((current % 60) + 1)
                timeDisplayMinutes.text = String(format:"%02d", current)
                
                
            }
            
            
        }
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        for touch in touches {
            
            let touchPoint = touch.locationInView(self.view)
            
            //print("the force in this one is : \(Double(touch.force))")
            
            
            if CGRectContainsPoint(ForceTester.frame, touchPoint) {
                
                ForceValue.text = "\(touch.force)"
                updateProgress(touch.force)
                
            } else if CGRectContainsPoint( CGRectMake(modeTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, modeTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, modeTouchBelow.frame.width, modeTouchBelow.frame.height), touchPoint) {
                
                switch Double(touch.force) {
                    
                case 0.0 ..< 2.22 :
                    
                    
                    if (hoursCounter2 != nil) {
                        hoursCounter2.invalidate()
                        hoursCounter2 = nil
                    }
                    
                    if (hoursCounter1 != nil) {
                        hoursCounter1.invalidate()
                        hoursCounter1 = nil
                    }
                    
                    if (hoursCounter0 == nil) {
                        hoursCounter0 = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "changeMode", userInfo: nil, repeats: true)
                    }
                    
                    break
                    
                case 2.22 ..< 4.44 :
                    if (hoursCounter0 != nil) {
                        hoursCounter0.invalidate()
                        hoursCounter0 = nil
                    }
                    
                    if (hoursCounter2 != nil) {
                        hoursCounter2.invalidate()
                        hoursCounter2 = nil
                    }
                    
                    if (hoursCounter1 == nil) {
                        hoursCounter1 = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "changeMode", userInfo: nil, repeats: true)
                    }
                    
                    break
                    
                case 4.44 ... 6.67 :
                    if (hoursCounter0 != nil) {
                        hoursCounter0.invalidate()
                        hoursCounter0 = nil
                    }
                    
                    if (hoursCounter1 != nil) {
                        hoursCounter1.invalidate()
                        hoursCounter1 = nil
                    }
                    
                    if (hoursCounter2 == nil) {
                        hoursCounter2 = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: "changeMode", userInfo: nil, repeats: true)
                    }
                    
                    break
                default:
                    break
                    
                }

                
            }
                
            else {
                
                
                var touchedLabel: UILabel!
                touchedLabel = nil
                
                if CGRectContainsPoint( CGRectMake(hoursTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, hoursTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, hoursTouchBelow.frame.width, hoursTouchBelow.frame.height), touchPoint) {
                    
                    touchedLabel = timeDisplayHours
                    
                    
                } else if CGRectContainsPoint( CGRectMake(minutesTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, minutesTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, minutesTouchBelow.frame.width, minutesTouchBelow.frame.height), touchPoint) {
                    
                    touchedLabel = timeDisplayMinutes
                    
                    
                }
                if touchedLabel != nil {
                    
                    
                    
                    switch Double(touch.force) {
                        
                    case 0.0 ..< 2.22 :
                        
                        
                        if (hoursCounter2 != nil) {
                            hoursCounter2.invalidate()
                            hoursCounter2 = nil
                        }
                        
                        if (hoursCounter1 != nil) {
                            hoursCounter1.invalidate()
                            hoursCounter1 = nil
                        }
                        
                        if (hoursCounter0 == nil) {
                            hoursCounter0 = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "updateLabel", userInfo: touchedLabel, repeats: true)
                        }
                        
                        break
                        
                    case 2.22 ..< 4.44 :
                        if (hoursCounter0 != nil) {
                            hoursCounter0.invalidate()
                            hoursCounter0 = nil
                        }
                        
                        if (hoursCounter2 != nil) {
                            hoursCounter2.invalidate()
                            hoursCounter2 = nil
                        }
                        
                        if (hoursCounter1 == nil) {
                            hoursCounter1 = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateLabel", userInfo: touchedLabel, repeats: true)
                        }
                        
                        break
                        
                    case 4.44 ... 6.67 :
                        if (hoursCounter0 != nil) {
                            hoursCounter0.invalidate()
                            hoursCounter0 = nil
                        }
                        
                        if (hoursCounter1 != nil) {
                            hoursCounter1.invalidate()
                            hoursCounter1 = nil
                        }
                        
                        if (hoursCounter2 == nil) {
                            hoursCounter2 = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: "updateLabel", userInfo: touchedLabel, repeats: true)
                        }
                        
                        break
                    default:
                        break
                        
                    }
                    
                    
                }
                
                
                
                
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

