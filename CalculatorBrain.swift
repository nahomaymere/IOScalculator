//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nahom Hailu on 31/10/2016.
//  Copyright © 2016 Nahom. All rights reserved.
//

import Foundation

func multiply(op1:Double, op2:Double) -> Double {
    return  op1 * op2
}
class   CalculatorBrain
{
    private var accumulator = 0.0
    func setOperand(operand:Double) {
        accumulator = operand;
    }
    
    private var operations:Dictionary<String,Operations> = [
        "π" : Operations.Constant(M_PI), //M_PI,
        "e" : Operations.Constant(M_E), //M_E,
        "√" : Operations.UnaryOperations(sqrt), //sqrt
        "cos": Operations.UnaryOperations(cos), // cose
        "±": Operations.UnaryOperations({-$0}), // change sign
        "×": Operations.BinaryOperations({$0 * $1}),
        "+": Operations.BinaryOperations({$0 + $1}),
        "-": Operations.BinaryOperations({$0 - $1}),
        "÷": Operations.BinaryOperations({$0 / $1}),
        "=": Operations.Equals
        
    ]
    private enum Operations {
        case Constant(Double)
        case UnaryOperations((Double)->Double)
        case BinaryOperations((Double, Double)->Double)
        case Equals
    }
    func performOperation(symbol:String)  {
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
            case .UnaryOperations(let function):
                accumulator = function(accumulator)
            case .BinaryOperations(let function):
                executePendingOperation()
                pending = PendingBinaryInfo(binaryFunction:function, firstOperand:accumulator)
     
            case .Equals:
                executePendingOperation()
            }
        }
        
    }
    private func executePendingOperation(){
        if(pending != nil){
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }

    }
    private var pending: PendingBinaryInfo?
    private struct PendingBinaryInfo {
        var binaryFunction: (Double,Double)->Double
        var firstOperand: Double
    }
    var result:Double{
        get{
            return accumulator
        }
    }
}
