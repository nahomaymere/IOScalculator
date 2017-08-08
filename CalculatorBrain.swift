//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nahom Hailu on 31/10/2016.
//  Copyright © 2016 Nahom. All rights reserved.
//

import Foundation

// TODO: I recommend `CalculatorBrain {` but its your choice, however whichever you choose 
//          be consistent!!! Either change this or change in your ViewController class.
class   CalculatorBrain
{
    private var isPartialResult = false; // TODO: replace it with `private(set) var isPartialResult = false`

    // TODO: Description has a initial constant value which is space.
    // assign a constant for it, like: var description = initialDescriptionValue
    // and also comment why thats needed.
    private var description = " " // TODO: replace it with `private(set) var`
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()

    func setOperand(operand:Double) {
        accumulator = operand;
        internalProgram.append(operand as AnyObject)
    }
    func getDescription()->String  { // TODO: use the `private(set) var` and remove this method.
        return description
    }

  
    func isResultPartial()->Bool { // TODO: use the `private(set) var` and remove this method.
        return isPartialResult
    }
  
    private var operations:Dictionary<String,Operations> = [
        "π" : Operations.Constant(.pi), //M_PI,
        "e" : Operations.Constant(M_E), //M_E,
        "C" : Operations.Cancel, //cancel
        "√" : Operations.UnaryOperations(sqrt), //sqrt
        "cos" : Operations.UnaryOperations(cos), // cose
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
    func performOperation(symbol:String)  {
        if let operation = operations[symbol]{
            internalProgram.append(symbol as AnyObject)

            // TODO: This is ok for now but think what would happen
            // if you wanna change the symbols (eg ÷ with /)

            // TODO: `performOperation` seems to do more than that ;)
            // It'd be good practice to separate description related stuff out.
            //
            // Even better you can use the switch below and call particular 
            // description related method for each case, eg.
            // case .Constant(let associatedConstantValue):
            //   description(forConstant: associatedConstantValue)

            if(symbol == "rand"){
                description = "rand() = " + String(format:"%g",accumulator)
                
            }
            else if(description != " ") {
                let lastChar = description[description.index(before: description.endIndex)]
                if((symbol == "×" ||  symbol == "÷") && (lastChar == "+" || lastChar == "-")||((symbol == "+" ||  symbol == "-")&&(lastChar == "×" || lastChar == "÷")) ){
                    description.insert("(", at: description.startIndex)
                    description.append(String(format:"%g",accumulator)+")"+symbol)
                }
                else if(lastChar == "="){
                    description = (String(format:"%g",accumulator)+symbol)
                }
                else{
                    description.append(String(format:"%g",accumulator)+symbol)
                }
            }
  
            else{ // TODO: BAD INDENTATION!
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
    private func generateRandNum(){
        let rndNum = drand48();
        accumulator = (rndNum)
    }
    private func clearMemory(){
        accumulator = 0.0
        description = " " // TODO: Here you could do: description = initialDescriptionValue
        internalProgram.removeAll()
        pending = nil
        isPartialResult = false

    }
    private func executePendingOperation(){
        if(pending != nil){
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
            isPartialResult = false

        }

    }
    private var pending: PendingBinaryInfo?
    private struct PendingBinaryInfo {
        var binaryFunction: (Double,Double)->Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clearMemory()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }
                    else if let operation = op as? String{
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    var result:Double{
        get{
            return accumulator
        }
    }
    
}
