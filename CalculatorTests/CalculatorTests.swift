//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Nahom Hailu on 26/09/16.
//  Copyright (c) 2016 Nahom. All rights reserved.
//

import XCTest
@testable import Calculator

// You don't have to pay attention to this at all.
// This is how tests are done in iOS but its not covered 
// in the course and its also not neccessary atm.
// If you're just curios tap on the tiny button
// left from `class` and you'll see it crashes on line: 57
// thats because you have extra space in your description text :D
class CalculatorTests: XCTestCase {

    var vc: ViewController!
    
    override func setUp() {
        super.setUp()
        vc = ViewController()
        vc.display = UILabel()
        vc.descriptionLabel = UILabel()
    }
    
    // MARK: Required tasks

    // Task 1: Get calculator working
    // Task 2: ignore illegal floating points.
    func testIllegalFloatingPointInput() {

        /// entering 1.1.1 should ignore the last floating point and show 1.11
        let btn1: UIButton = UIButton.withTitle("1")
        let btnDot: UIButton = UIButton.withTitle(".")

        vc.touchDigit(btn1)
        vc.dot(btnDot)
        vc.touchDigit(btn1)
        vc.dot(btnDot)
        vc.touchDigit(btn1)

        assert(vc.display.text == "1.11")
    }

    // Task 3: Add more operation buttons.
    // Task 4: Use colors.
    // Task 5, 6, 7: Add description label functionality.
    func testDescriptionLabel() {

        // a: input: 7+, output: 7+...
        vc.touchDigit(UIButton.withTitle("7"))
        vc.performOperation(UIButton.withTitle("+"))

        assert(vc.descriptionLabel.text == "7+...")

        // clear
        vc.performOperation(UIButton.withTitle("C"))

        // b: input: 7+9, output: 7+... and 9 in display
        vc.touchDigit(UIButton.withTitle("7"))
        vc.performOperation(UIButton.withTitle("+"))
        vc.touchDigit(UIButton.withTitle("9"))

        assert(vc.descriptionLabel.text == "7+...")
        assert(vc.display.text == "9")

        // clear
        vc.performOperation(UIButton.withTitle("C"))

        // c: input: 7+9=, output: 7+9= and 16 in display
        vc.touchDigit(UIButton.withTitle("7"))
        vc.performOperation(UIButton.withTitle("+"))
        vc.touchDigit(UIButton.withTitle("9"))
        vc.performOperation(UIButton.withTitle("="))

        assert(vc.descriptionLabel.text == "7+9=")
        assert(vc.display.text == "16")

//        // clear
//        vc.performOperation(UIButton.withTitle("C"))
//
//        // d: input: 7+9=√, output: √(7+9)= and 4 in display
//        vc.touchDigit(UIButton.withTitle("7"))
//        vc.performOperation(UIButton.withTitle("+"))
//        vc.touchDigit(UIButton.withTitle("9"))
//        vc.performOperation(UIButton.withTitle("="))
//        vc.performOperation(UIButton.withTitle("√"))
//
//        assert(vc.descriptionLabel.text == " √(7+9)=")
//        assert(vc.display.text == "4")
//
//        // clear
//        vc.performOperation(UIButton.withTitle("C"))
//
//        // e: input: 7+9√, output: 7+√9= and 3 in display
//        vc.touchDigit(UIButton.withTitle("7"))
//        vc.performOperation(UIButton.withTitle("+"))
//        vc.touchDigit(UIButton.withTitle("9"))
//        vc.performOperation(UIButton.withTitle("√"))
//
//        assert(vc.descriptionLabel.text == " √(7+9)=")
//        assert(vc.display.text == "4")
    }

}

extension UIButton {

    static func withTitle(_ title: String) -> UIButton {
        let button: UIButton = UIButton()
        button.setTitle(title, for: .normal)
        return button
    }
}




