//
//  ViewController.swift
//  Calculator
//
//  Created by Nahom Hailu on 26/09/16.
//  Copyright (c) 2016 Nahom. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet private var display: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    private var userIntheMiddleOfTyping = false
    private var numberHasDot = false
    private var operandIsVariable = false
    private var brain = CalculatorBrain()
    var savedProgram : CalculatorBrain.PropertyList?
    
    private var displayValue: Double? {
        get {
            if let value = Double(display.text!){
                return value
            } else {
                return nil
            }
            /*
             return display.text != nil ?
             Double(display.text!): nil*/
        }
        set {
            let formatter = NumberFormatter()
            formatter.minimumSignificantDigits = 0
            formatter.maximumFractionDigits = 6
            display.text = newValue !=  nil ? formatter.string(from:NSNumber(value:newValue!)):nil
        }
    }

    @IBAction func backspace(_ sender: UIButton) {
        //deletes the last number from the display
        if display.text != "" {
            display.text?.remove(at: (display.text?.index(before: (display.text?.endIndex)!))!)
        }
    }
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction private func touchOperand(_ sender: UIButton) {
        let operand = sender.currentTitle!
        if userIntheMiddleOfTyping {
            let textCurrentlydisplayed = display.text!
            display.text = textCurrentlydisplayed + operand

            if operand == "." && !numberHasDot {
                display.text = textCurrentlydisplayed + operand
                numberHasDot = true
            } else {
                display.text = textCurrentlydisplayed + operand
            }
            
        } else {
            display.text = operand
        }
        userIntheMiddleOfTyping = true
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIntheMiddleOfTyping {
            if displayValue != nil {
                brain.setOperand(operand: displayValue!)
                userIntheMiddleOfTyping = false
                numberHasDot = false
            }
            
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathSymbol)
        }
        if !brain.isPartialResult {
            descriptionLabel.text = brain.description
        } else {
            descriptionLabel.text = brain.description + "..."
        }
        
        displayValue = brain.result
    }
}

