//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nahom Hailu on 31/10/2016.
//  Copyright © 2016 Nahom. All rights reserved.
//

import Foundation


class   CalculatorBrain {
    
    private(set) var isPartialResult = false
    private(set) var description = ""
    private var accumulator = 0.0
    private var variable = ""
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
    public var variablesValues:Dictionary<String, Double> = [:]
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
        if description != "" {
            let lastChar = description[description.index(before: description.endIndex)]
            if lastChar == "=" {
                description.removeAll()
            }
            
        }
    }
    func setOperand(variableName:String) {
        let operandValue = variablesValues[variableName] ?? 0.0
        accumulator = operandValue

        
    }
    
    func performOperation(symbol:String) {
        if let operation = operations[symbol] {
            internalProgram.append(symbol as AnyObject)
            if symbol == "rand" {
                description = "rand() = " + String(format:"%g",accumulator)
                
            } else if description.characters.count > 0 {
                let lastChar = description[description.index(before: description.endIndex)]
                if lastChar == "=" {
                    if ["cos", "sin", "%", "√"].contains(symbol) {
                        description.insert(")", at: description.index(description.endIndex, offsetBy: -1))
                        description = symbol+"(" + description
                    } else if symbol == "e" || symbol == "π" {
                        description.removeAll()
                    } else if symbol == "+" || symbol == "-" {
                        description.remove(at: description.index(before: description.endIndex))
                        description.append(symbol)
                    } else if symbol == "×" || symbol == "÷" {
                        description.insert("(", at: description.startIndex)
                        description.remove(at: description.index(before: description.endIndex))
                        description.append(")" + symbol)
                    }
                } else if !["e","π"].contains(symbol) && [")","e","π"].contains(lastChar) || ["e","π"].contains(symbol) && !["e","π"].contains(lastChar) {
                    description.append(symbol)
                } else if (["×","÷"].contains(symbol)) && (["-","+"].contains(lastChar)) || (["-","+"].contains(symbol) && ["×","÷"].contains(lastChar)) {
                    description.insert("(", at: description.startIndex)
                    description.append(String(format:"%g",accumulator)+")"+symbol)
                } else  if ["cos","sin","%","√"].contains(symbol) {
                    description.append(symbol+"(" + String(format:"%g",accumulator) + ")")
                } else if ["×","÷","-","+","="].contains(symbol) {
                    description.append(String(format:"%g",accumulator)+symbol)
                }
            } else if ["×","÷","-","+"].contains(symbol) {
                description.append(String(format:"%g",accumulator)+symbol)
            } else if symbol == "π" || symbol == "e" {
                description.append(symbol)
            } else  if ["cos","sin","%","√"].contains(symbol) {
                description.append(symbol+"(" + String(format:"%g",accumulator) + ")")
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
        description.removeAll()
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
