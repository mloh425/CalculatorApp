//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Sau Chung Loh on 7/9/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

import Foundation

class CalculatorModel {
  
  private enum Op {
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
  }
  
  private var opStack = [Op]() //Stack of operations
  private var knownOps = [String : Op]() //Dictionary of symbols, to the operation to by done, functions can be types too

  init() {
    knownOps["+"] = Op.BinaryOperation("+", +)
    knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
    knownOps["×"] = Op.BinaryOperation("×", *)
    knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
    knownOps["±"] = Op.UnaryOperation("±") { $0 * -1 }
    knownOps["√"] = Op.UnaryOperation("√", sqrt)
  }
  
  private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
    
    if !ops.isEmpty {
      //Due to the nature of structs, you must make a copy of the ops for it to be mutable.
      //Structs pass by value, classes are by reference
      var remainingOps = ops
      let op = remainingOps.removeLast()
      switch op {
      //switch on your op.
      case .Operand(let operand):
        //inside here, operand will have associated value of Operand(Double)
        return (operand, remainingOps)
      case .UnaryOperation(_, let operation):
        let operandEvaluation = evaluate(remainingOps) //recurse to find an operand to perform operation on. This var is a tuple
        if let operand = operandEvaluation.result { //Pulls the result out of the returned Tuple from operand Evaluation. Optional
          return (operation(operand), operandEvaluation.remainingOps) //operation(operand)???????
        }
      case .BinaryOperation(_, let operation):
        let op1Evaluation = evaluate(remainingOps) //Find the first operand
        if let operand1 = op1Evaluation.result { //If operand is found, pull it out from Tuple
          let op2Evaluation = evaluate(op1Evaluation.remainingOps) //Do the same with second operand, find it recursively
          if let operand2 = op2Evaluation.result {
            return (operation(operand1, operand2), op2Evaluation.remainingOps) //Pass in op1 and op2 into appropriate defined operation
          }
        }
      }
    }
    return (nil, ops)
  }
  
  func evaluate() -> Double? {
    let (result, _) = evaluate(opStack) //only care about result
    return result
  }
  
  //Pushes number onto stack
  func pushOperand (operand : Double) {
    opStack.append(Op.Operand(operand))
  }
  
  func performOperation (symbol : String) {
    //If the symbol is not nil when found, put the operation onto stack
    if let operation = knownOps[symbol] {
      opStack.append(operation)
    }
  }
}