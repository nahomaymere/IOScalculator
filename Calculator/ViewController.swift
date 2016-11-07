//
//  ViewController.swift
//  Calculator
//
//  Created by Nahom Hailu on 26/09/16.
//  Copyright (c) 2016 Nahom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   

    
    @IBOutlet private var display: UILabel!
    
     private var userIntheMiddleOfTyping = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIntheMiddleOfTyping {
            let textCurrentlydisplayed = display.text!
            display.text = textCurrentlydisplayed + digit
        }
        else {
            display.text = digit
        }
        userIntheMiddleOfTyping = true
    }
    private var displayValue: Double {
        get {
            return Double(display.text!)!;
        }
        set {
            display.text = String(newValue)
        }
        
    }
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIntheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIntheMiddleOfTyping = false
        }
        if let mathSymbol = sender.currentTitle{
            
            brain.performOperation(symbol: mathSymbol)
        }
        displayValue = brain.result
    }
}

