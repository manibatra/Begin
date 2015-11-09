//
//  AlarmObject.swift
//  Test 3D Touch
//
//  Created by Mani Batra on 9/11/2015.
//  Copyright © 2015 Mani Batra. All rights reserved.
//

import Foundation

class Alarm {
    
    private var hours: String
    private var minutes: String
    private var mode: String
    
    init(hours: String, minutes: String, mode: String) {
        self.hours = hours
        self.minutes = minutes
        self.mode = mode
    }
    
    func getHours() -> String {
        
        return self.hours
    }
    
    func getMinutes() -> String {
        
        return self.minutes
    }
    
    func getMode() -> String {
        
        return self.mode
    }
    
    func description() -> String {
        
        return self.hours + " : " + self.minutes + "  " + self.mode
    }
}
