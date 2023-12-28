//
//  ViewController.swift
//  AccelerometerFun
//
//  Created by David Fry on 6/10/14.
//  Copyright (c) 2014 David Fry. All rights reserved.
//
// Most of the ideas for this comes from http://nscookbook.com/2013/03/ios-programming-recipe-19-using-core-motion-to-access-gyro-and-accelerometer/
// Coverted it into Swift
// Credit: Joe Hoffman 

import UIKit
import CoreMotion
import Foundation

class ViewController: UIViewController {
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("test_log.txt")
    
    
    
    var currentMaxAccelX: Double = 0.0
    var currentMaxAccelY: Double = 0.0
    var currentMaxAccelZ: Double = 0.0
    var currentMaxRotX: Double = 0.0
    var currentMaxRotY: Double = 0.0
    var currentMaxRotZ: Double = 0.0
    
    
    
    let motionManager = CMMotionManager()
    
    @IBOutlet var accX : UILabel! = nil
    @IBOutlet var accY : UILabel! = nil
    @IBOutlet var accZ : UILabel! = nil
    
    @IBOutlet var maxAccX : UILabel! = nil
    @IBOutlet var maxAccY : UILabel! = nil
    @IBOutlet var maxAccZ : UILabel! = nil
    
    @IBOutlet var rotX : UILabel! = nil
    @IBOutlet var rotY : UILabel! = nil
    @IBOutlet var rotZ : UILabel! = nil
    
    @IBOutlet var maxRotX : UILabel! = nil
    @IBOutlet var maxRotY : UILabel! = nil
    @IBOutlet var maxRotZ : UILabel! = nil
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.gyroUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData, error) in
            if let acceleration = accelerometerData?.acceleration {
                self.outputAccelerationData(acceleration: acceleration)
            }
            if let error = error {
                print("\(error)")
            }
        }

        
        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: { (gyroData: CMGyroData?, error: Error?) in
            if let data = gyroData {
                self.outputRotationData(rotation: data.rotationRate)
            }
            if let err = error {
                print("\(err)")
            }
        })
        
        if !FileManager.default.fileExists(atPath: filePath.path) {
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
        }
    }

    @IBAction func resetButtonPressed(sender : AnyObject)
    {
        currentMaxAccelX = 0
        currentMaxAccelY = 0
        currentMaxAccelZ = 0
        
        currentMaxRotX = 0
        currentMaxRotY = 0
        currentMaxRotZ = 0
    }
    
    func outputAccelerationData(acceleration:CMAcceleration)
    {
        // Swift does not have string formation yet
        accX.text = String(format:"%.4f", acceleration.x)
        
        if fabs(acceleration.x) > fabs(currentMaxAccelX)
        {
            currentMaxAccelX = acceleration.x
        }
        
        accY.text = String(format:"%.4f", acceleration.y)
        
        if acceleration.y > currentMaxAccelY
        {
            currentMaxAccelY = acceleration.y
        }

        accZ.text = String(format:"%.4f", acceleration.z)
        
        if acceleration.z > currentMaxAccelZ
        {
            currentMaxAccelZ = acceleration.z
        }
        
        maxAccX.text = String(format:"%.4f", currentMaxAccelX)
        maxAccY.text = String(format:"%.4f", currentMaxAccelY)
        maxAccZ.text = String(format:"%.4f", currentMaxAccelZ)
        
    }
    
    func outputRotationData(rotation:CMRotationRate)
    {
        rotX.text = String(format:"%.4f", rotation.x)
        if fabs(rotation.x) > fabs(currentMaxRotX)
        {
            currentMaxRotX = rotation.x
        }
        
        rotY.text = String(format:"%.4f", rotation.y)
        if fabs(rotation.y) > fabs(currentMaxRotY)
        {
            currentMaxRotY = rotation.y
        }
        rotZ.text = String(format:"%.4f", rotation.z)
        if fabs(rotation.z) > fabs(currentMaxRotZ)
        {
            currentMaxRotZ = rotation.z
        }
        
        maxRotX.text = String(format:"%.4f", currentMaxRotX)
        maxRotY.text = String(format:"%.4f", currentMaxRotY)
        maxRotZ.text = String(format:"%.4f", currentMaxRotZ)
        
        if let accXString = accX.text, let accYString = accY.text {
            let values = "acceleration x: \(accXString) y: \(accYString)"
            print( values )
            // write the values to the file
            do {
                let fileHandle = try FileHandle(forWritingTo: filePath)
                fileHandle.seekToEndOfFile()
                fileHandle.write(values.data(using: .utf8)!)
                fileHandle.closeFile()
            } catch {
                print("Error writing to file \(error)")
            }
        } else {
            print("One or both of the optionals are nil")
        }
    }

}

