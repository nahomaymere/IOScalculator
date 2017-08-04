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
    @IBOutlet var descriptionLabel: UILabel!
    private var userIntheMiddleOfTyping = false
    private var numberHasDot = false

    @IBAction func backspace(_ sender: UIButton) {
        //deletes the last number from the display
        if(display.text?.characters.count == 1){
            display.text = "0";
        }
        else{
            display.text?.remove(at: (display.text?.index(before: (display.text?.endIndex)!))!)
        }
    }
    var savedProgram : CalculatorBrain.PropertyList?
    @IBAction func save() {
        savedProgram = brain.program
    }
    @IBAction func restore() {
        if(savedProgram != nil){
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    

    
    @IBAction func dot(_ sender: UIButton) {
        if !numberHasDot {
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
        numberHasDot = true
    }
    
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
    private var displayValue: Double? {
        get {
            if let value = Double(display.text!){
                return value
            }
            else{
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
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
 
        if userIntheMiddleOfTyping {
            brain.setOperand(operand: displayValue!)
            userIntheMiddleOfTyping = false
            numberHasDot = false
        }
        if let mathSymbol = sender.currentTitle{
            
            brain.performOperation(symbol: mathSymbol)
        }
        if(!brain.isResultPartial()){
            descriptionLabel.text = brain.getDescription() 
        }
        else{
            descriptionLabel.text = brain.getDescription() + "..."
        }

        displayValue = brain.result
    }
}

