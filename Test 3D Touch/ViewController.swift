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
    private var alarmOn = 0
    private var touchDirection = 1
    private var stopTouches = 0
    private var hoursCounter0: NSTimer!
    private var hoursCounter1: NSTimer!
    private var hoursCounter2: NSTimer!
    
    
    
    @IBOutlet weak var ForceTester: UILabel!
    @IBOutlet weak var ForceValue: UILabel!
    
    @IBOutlet weak var timeDisplayHours: UILabel!
    @IBOutlet weak var timeDisplayMinutes: UILabel!
    @IBOutlet weak var timeDisplayMode: UILabel!
    @IBOutlet weak var timeDisplayView: UIStackView!
    
    @IBOutlet weak var modeTouchAbove: UILabel!
    @IBOutlet weak var hoursTouchAbove: UILabel!
    @IBOutlet weak var minutesTouchAbove: UILabel!
    @IBOutlet weak var touchAboveView: UIStackView!
    
    @IBOutlet weak var modeTouchBelow: UILabel!
    @IBOutlet weak var hoursTouchBelow: UILabel!
    @IBOutlet weak var minutesTouchBelow: UILabel!
    @IBOutlet weak var touchBelowView: UIStackView!
    

    @IBOutlet weak var timeDisplayConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.init(red: 0.84, green:0.03, blue:0.03, alpha:1.0)
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
            
            ForceValue.text = "May the Force Be with YOu"
            
        }
        
        ForceTester.hidden = true
        ForceValue.hidden = true
        
        currentAlarm = Alarm.init(hours: "12", minutes: "00", mode: "AM")
        timeDisplayHours.text = currentAlarm.getHours()
        timeDisplayMinutes.text = currentAlarm.getMinutes()
        timeDisplayMode.text = currentAlarm.getMode()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { // 1
            dispatch_async(dispatch_get_main_queue()) { // 2
                let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkAlarm", userInfo: nil, repeats: true)
                timer.fire()
            }
        }

        
        configureHalfCircularProgress()
        updateProgress(0)
        
        
        
        
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
        
        //self.view.addSubview(halfCircularProgress)
        
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
        
        if touchDirection == 1 {
            var current: Int = Int(touchedLabel.text!)!
            current = ((current % (12 * minuteFlag)) + 1)
            touchedLabel.text = String(format: format, current)
        } else {
            var current: Int = Int(touchedLabel.text!)!
            current--
            current =  current <= 0 ?  (12 * minuteFlag) - 1 : current
            touchedLabel.text = String(format: format, current)
        }
        
        
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
    
    func stopCounters() {
        
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

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        print("the touch has ended")
        stopCounters()
        //
//        
//        self.ForceValue.text = "Return of the Jedi ?"
//        self.progress = 0.0
//        updateProgress(0)
        stopTouches = 0
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        for touch in touches {
            
            let touchPoint = touch.locationInView(self.view)
            
            if (CGRectContainsPoint( CGRectMake(timeDisplayMode.frame.origin.x + timeDisplayView.frame.origin.x, timeDisplayMode.frame.origin.y + timeDisplayView.frame.origin.y, timeDisplayMode.frame.width, timeDisplayMode.frame.height), touchPoint) || CGRectContainsPoint( CGRectMake(modeTouchAbove.frame.origin.x + touchAboveView.frame.origin.x, modeTouchAbove.frame.origin.y + touchAboveView.frame.origin.y, modeTouchAbove.frame.width, modeTouchAbove.frame.height), touchPoint) || CGRectContainsPoint( CGRectMake(modeTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, modeTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, modeTouchBelow.frame.width, modeTouchBelow.frame.height), touchPoint)) && alarmOn == 0 {
                
                if timeDisplayMode.text == "AM" {
                    timeDisplayMode.text = "PM"
                    break;
                } else {
                    timeDisplayMode.text = "AM"
                    break;
                }
            } else if CGRectContainsPoint( CGRectMake(timeDisplayHours.frame.origin.x + timeDisplayView.frame.origin.x, timeDisplayHours.frame.origin.y + timeDisplayView.frame.origin.y, timeDisplayHours.frame.width, timeDisplayHours.frame.height), touchPoint) && alarmOn == 0 {
                
                var currentHours: Int = Int(timeDisplayHours.text!)!
                currentHours = ((currentHours % 12) + 1)
                timeDisplayHours.text = String(currentHours)
                break;
                
            } else if CGRectContainsPoint( CGRectMake(timeDisplayMinutes.frame.origin.x + timeDisplayView.frame.origin.x, timeDisplayMinutes.frame.origin.y + timeDisplayView.frame.origin.y, timeDisplayMinutes.frame.width, timeDisplayMinutes.frame.height), touchPoint) && alarmOn == 0 {
                
                var currentMinutes: Int = Int(timeDisplayMinutes.text!)!
                currentMinutes = ((currentMinutes  % 60) + 5)
                if currentMinutes == 60 {
                    timeDisplayMinutes.text = "00"
                } else  {
                    timeDisplayMinutes.text = String(format: "%02d", currentMinutes)
                }
                break;
                
            } else if CGRectContainsPoint( CGRectMake(hoursTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, hoursTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, hoursTouchBelow.frame.width, hoursTouchBelow.frame.height), touchPoint) && alarmOn == 0 {
                
                var current: Int = Int(timeDisplayHours.text!)!
                current = ((current % 12) + 1)
                timeDisplayHours.text = String(current)
                
                
            } else if CGRectContainsPoint( CGRectMake(minutesTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, minutesTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, minutesTouchBelow.frame.width, minutesTouchBelow.frame.height), touchPoint) && alarmOn == 0 {
                
                var current: Int = Int(timeDisplayMinutes.text!)!
                current = ((current % 60) + 1)
                timeDisplayMinutes.text = String(format:"%02d", current)
                
                
            } else if CGRectContainsPoint( CGRectMake(hoursTouchAbove.frame.origin.x + touchAboveView.frame.origin.x, hoursTouchAbove.frame.origin.y + touchAboveView.frame.origin.y, hoursTouchAbove.frame.width, hoursTouchAbove.frame.height), touchPoint) && alarmOn == 0 {
                
                var current: Int = Int(timeDisplayHours.text!)!
                current--
                current = current <= 0 ? 12 : current
                timeDisplayHours.text = String(current)
                
                
            } else if CGRectContainsPoint( CGRectMake(minutesTouchAbove.frame.origin.x + touchAboveView.frame.origin.x, minutesTouchAbove.frame.origin.y + touchAboveView.frame.origin.y, minutesTouchAbove.frame.width, minutesTouchAbove.frame.height), touchPoint) && alarmOn == 0 {
                
                var current: Int = Int(timeDisplayMinutes.text!)!
                current--
                current = current <= 0 ? 59 : current
                timeDisplayMinutes.text = String(format:"%02d", current)
                
                
            }
            
            
            
        }
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        var touchedLabel: UILabel!
        touchedLabel = nil
        
        for touch in touches {
            
            let touchPoint = touch.locationInView(self.view)
            
            //print("the force in this one is : \(Double(touch.force))")
            
            
            if CGRectContainsPoint(ForceTester.frame, touchPoint) && alarmOn == 1 {
                
                ForceValue.text = "\(touch.force)"
                updateProgress(touch.force)
                
            } else if (CGRectContainsPoint( CGRectMake(modeTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, modeTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, modeTouchBelow.frame.width, modeTouchBelow.frame.height), touchPoint) || CGRectContainsPoint( CGRectMake(modeTouchAbove.frame.origin.x + touchAboveView.frame.origin.x, modeTouchAbove.frame.origin.y + touchAboveView.frame.origin.y, modeTouchAbove.frame.width, modeTouchAbove.frame.height), touchPoint)) && alarmOn == 0 && stopTouches == 0 {
                
                changeTime(touch.force, selector: "changeMode", touchedLabel: nil)
                
                
            }
                
            else if CGRectContainsPoint( CGRectMake(hoursTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, hoursTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, hoursTouchBelow.frame.width, hoursTouchBelow.frame.height), touchPoint) && alarmOn == 0 && stopTouches == 0 {
                
                touchedLabel = timeDisplayHours
                touchDirection = 1
                changeTime(touch.force, selector: "updateLabel", touchedLabel: touchedLabel)
                
                
            } else if CGRectContainsPoint( CGRectMake(minutesTouchBelow.frame.origin.x + touchBelowView.frame.origin.x, minutesTouchBelow.frame.origin.y + touchBelowView.frame.origin.y, minutesTouchBelow.frame.width, minutesTouchBelow.frame.height), touchPoint) && alarmOn == 0 && stopTouches == 0 {
                
                touchedLabel = timeDisplayMinutes
                touchDirection = 1
                changeTime(touch.force, selector: "updateLabel", touchedLabel: touchedLabel)
                
                
                
            } else if CGRectContainsPoint( CGRectMake(hoursTouchAbove.frame.origin.x + touchAboveView.frame.origin.x, hoursTouchAbove.frame.origin.y + touchAboveView.frame.origin.y, hoursTouchAbove.frame.width, hoursTouchAbove.frame.height), touchPoint) && alarmOn == 0 && stopTouches == 0{
                
                touchedLabel = timeDisplayHours
                touchDirection = -1
                changeTime(touch.force, selector: "updateLabel", touchedLabel: touchedLabel)
                
                
                
            } else if CGRectContainsPoint( CGRectMake(minutesTouchAbove.frame.origin.x + touchAboveView.frame.origin.x, minutesTouchAbove.frame.origin.y + touchAboveView.frame.origin.y, minutesTouchAbove.frame.width, minutesTouchAbove.frame.height), touchPoint) && alarmOn == 0 && stopTouches == 0{
                
                touchedLabel = timeDisplayMinutes
                touchDirection = -1
                changeTime(touch.force, selector: "updateLabel", touchedLabel: touchedLabel)
                
                
                
            } else if !CGRectContainsPoint(CGRectMake(touchAboveView.frame.origin.x, touchAboveView.frame.origin.y, touchAboveView.frame.width, touchAboveView.frame.height + timeDisplayView.frame.height + touchBelowView.frame.height), touchPoint) || alarmOn == 1 {
                
                print("alarm is : \(stopTouches)")
                if touch.force > 6.666 && stopTouches == 0 {
                    
                    stopTouches = 1
                    
                    if alarmOn == 0 {
                        stopCounters()
                        self.touchAboveView.userInteractionEnabled = false
                        self.touchBelowView.userInteractionEnabled = false

                        self.view.userInteractionEnabled = false
                        self.view.backgroundColor = UIColor.init(red: 0.05, green:0.68, blue:0.23, alpha:1.0)

                        
                        currentAlarm.setHours(timeDisplayHours.text!)
                        currentAlarm.setMinutes(timeDisplayMinutes.text!)
                        currentAlarm.setMode(timeDisplayMode.text!)
                        self.timeDisplayConstraint.constant = self.timeDisplayConstraint.constant + 300

                        
                        UIView.animateWithDuration(1.0, delay: 0.0, options: [.CurveEaseInOut], animations: { () -> Void in
                            
                            self.view.layoutIfNeeded()
                            
                            }, completion: { (Bool) -> Void in
                                
                                self.alarmOn = 1
                                self.view.userInteractionEnabled = true
                              
                                
                        })
                       break
                        
                    } else {
                        self.view.userInteractionEnabled = false
                        self.timeDisplayConstraint.constant = self.timeDisplayConstraint.constant - 300


                        self.view.backgroundColor = UIColor.init(red: 0.84, green:0.03, blue:0.03, alpha:1.0)
                        UIView.animateWithDuration(2.0, delay: 0.1, options: [.CurveEaseInOut], animations: { () -> Void in
                            
                            self.view.layoutIfNeeded()
                            
                            }, completion: { (Bool) -> Void in
                                
                                self.alarmOn = 0
                                self.view.userInteractionEnabled = true
                                self.touchAboveView.userInteractionEnabled = true
                                self.touchBelowView.userInteractionEnabled = true
                        })

                        
                      

                        break
                        
                        
                    }
                }
                
            }
            
            
        }
        
    }
    
    
    func changeTime(force: CGFloat, selector: String, touchedLabel: UILabel!) {
        
        
        switch Double(force) {
            
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
                hoursCounter0 = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: Selector(selector), userInfo: touchedLabel, repeats: true)
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
                hoursCounter1 = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector(selector), userInfo: touchedLabel, repeats: true)
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
                hoursCounter2 = NSTimer.scheduledTimerWithTimeInterval(0.09, target: self, selector: Selector(selector), userInfo: touchedLabel, repeats: true)
            }
            
            break
        default:
            break
            
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

