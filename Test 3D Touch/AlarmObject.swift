//
//  AlarmObject.swift
//  Test 3D Touch
//
//  Created by Mani Batra on 9/11/2015.
//  Copyright © 2015 Mani Batra. All rights reserved.
//

import Foundation

class Alarm {
    
    private var hours: UInt8
    private var minutes: UInt8
    
    init(hours: UInt8, minutes: UInt8) {
        self.hours = hours
        self.minutes = minutes
    }
    
    func getHours() -> UInt8 {
        
        return self.hours
    }
    
    func getMinutes() -> UInt8 {
        
        return self.minutes
    }
}
