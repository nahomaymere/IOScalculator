//
//  ViewController.swift
//  Calculator
//
//  Created by Nahom Hailu on 26/09/16.
//  Copyright (c) 2016 Nahom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   

    
    @IBOutlet var display: UILabel! // NOTE: made public for testing purpose.
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
    

    // TODO: Follow the teacher's function naming!!!
    // This is an action so name it `touchDot` like the teacher
    // or something like `dotTapped` which is actually more common.
    // but if you do that, you'll have to be consistent and rename
    // all button targets.
    @IBAction func dot(_ sender: UIButton) { // TODO: would be cool if you don't have to assign a dedicated target for dot, its either an operand or operator if you think about it ;)
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

    // NOTE: Button targets are made public for testing purpose.
    
    @IBAction func touchDigit(_ sender: UIButton) {
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
        set { // TODO: bad indentation.
                let formatter = NumberFormatter()
                formatter.minimumSignificantDigits = 0
                formatter.maximumFractionDigits = 6
            
            display.text = newValue !=  nil ? formatter.string(from:NSNumber(value:newValue!)):nil
            }
        
        
    }
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
 
        if userIntheMiddleOfTyping {

            // TODO: What happens if displayValue is nil? (Tap on `+-` and `=`, it'll crash)
            // You use `!` to forcefully unwrapp an optional only in two cases:
            // 1: you're 100% sure it has value
            // 2: you want your application to crash if this value is nil.
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

