//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nahom Hailu on 31/10/2016.
//  Copyright © 2016 Nahom. All rights reserved.
//

import Foundation


class   CalculatorBrain
{
    private var isPartialResult = false
    private var description = " "
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    private var operations:Dictionary<String,Operations> = [
        "π" : Operations.Constant(.pi), //M_PI,
        "e" : Operations.Constant(M_E), //M_E,
        "C" : Operations.Cancel, //cancel
        "√" : Operations.UnaryOperations(sqrt), //sqrt
        "cos" : Operations.UnaryOperations(cos), // cose
        "sin" : Operations.UnaryOperations(sin), // sin
        "±" : Operations.UnaryOperations({-$0}), // change sign
        "%" : Operations.UnaryOperations({($0 * 0.01)}),
        "×" : Operations.BinaryOperations( * ),
        "+" : Operations.BinaryOperations( + ),
        "-" : Operations.BinaryOperations( - ),
        "÷" : Operations.BinaryOperations( / ),
        "=" : Operations.Equals,
        "rand":Operations.RandomNumberGenerator
    ]
    private enum Operations {
        case Constant(Double)
        case UnaryOperations((Double)->Double)
        case BinaryOperations((Double, Double)->Double)
        case RandomNumberGenerator
        case Equals
        case Cancel
    }
    private var pending: PendingBinaryInfo?
    private struct PendingBinaryInfo {
        var binaryFunction: (Double,Double)->Double
        var firstOperand: Double
    }
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clearMemory()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    }
                    else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    var result:Double {
        get {
            return accumulator
        }
    }

    func setOperand(operand:Double) {
        accumulator = operand;
        internalProgram.append(operand as AnyObject)
    }
    
    func getDescription()->String {
        return description
    }
    
    func isResultPartial()->Bool {
        return isPartialResult
    }
    
    func performOperation(symbol:String) {
        if let operation = operations[symbol] {
            internalProgram.append(symbol as AnyObject)
            if symbol == "π" || symbol == "e" {
                if description == "0" {
                    description = String(format:"%g",accumulator)
                }
            } else  if symbol == "rand" {
                description = "rand() = " + String(format:"%g",accumulator)
                
            } else  if description != " " {
                let lastChar = description[description.index(before: description.endIndex)]
                if (symbol == "×" ||  symbol == "÷") && (lastChar == "+" || lastChar == "-") || ((symbol == "+" ||  symbol == "-") && (lastChar == "×" || lastChar == "÷")) {
                    description.insert("(", at: description.startIndex)
                    description.append(String(format:"%g",accumulator)+")"+symbol)
                } else  if lastChar == "=" {
                    description = (String(format:"%g",accumulator)+symbol)
                } else {
                    description.append(String(format:"%g",accumulator)+symbol)
                }
            } else {
                description.append(String(format:"%g",accumulator)+symbol)
            }
            
            switch operation {
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
            case .UnaryOperations(let function):
                accumulator = function(accumulator)
            case .BinaryOperations(let function):
                executePendingOperation()
                pending = PendingBinaryInfo(binaryFunction:function, firstOperand:accumulator)
                isPartialResult = true
            case .Equals:
                executePendingOperation()
            case.Cancel:
                clearMemory()
            case.RandomNumberGenerator:
                generateRandNum()
            }
        }
    }
    
    private func generateRandNum() {
        let rndNum = drand48();
        accumulator = (rndNum)
    }
    
    private func clearMemory() {
        accumulator = 0.0
        description = " "
        internalProgram.removeAll()
        pending = nil
        isPartialResult = false
    }
    
    private func executePendingOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
            isPartialResult = false

        }

    }
}
