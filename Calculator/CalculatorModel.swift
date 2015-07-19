//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Sau Chung Loh on 7/9/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

import Foundation

class CalculatorModel {
  
  private enum Op: Printable {
    case Operand(Double)
//    case Variable(String)
//    case Constant(String, () -> Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
    
    var description : String { //getter and setter, but no need to set, just retrieving the symbol
      get {
        switch self {
        case .Operand(let operand):
          return "\(operand)"
//        case .Variable(let variable):
//          return variable
//        case .Constant(let symbol, _):
//          return symbol
        case .UnaryOperation(let symbol, _):
          return symbol
        case .BinaryOperation(let symbol, _):
          return symbol
        }
      }
    }
  }
  
  private var opStack = [Op]() //Stack of operations
  private var knownOps = [String : Op]() //Dictionary of symbols, to the operation to by done, functions can be types too
  var variableValues = Dictionary<String, Double>()
 
  init() {
    func learnOp(op : Op) {
      knownOps[op.description] = op
    }
    learnOp(Op.BinaryOperation("+", +))
    learnOp(Op.BinaryOperation("−") { $1 - $0 })
    learnOp(Op.BinaryOperation("×", *))
    learnOp(Op.BinaryOperation("÷") { $1 / $0 })
    learnOp(Op.UnaryOperation("±") { $0 * -1 })
    learnOp(Op.UnaryOperation("√", sqrt))
    learnOp(Op.UnaryOperation("sin") { sin($0) })
    learnOp(Op.UnaryOperation("cos") { cos($0) })
    learnOp(Op.UnaryOperation("PI") { $0 * M_PI })
    //Need to add sin cos, clearing? but UI is involved so...
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
  
  func clearStack() {
    opStack = []
  }
  
  func evaluate() -> Double? {
    let (result, remainder) = evaluate(opStack) //only care about result
    println("\(opStack) = \(result) with \(remainder) left over")
    return result
  }
  
  //Pushes number onto stack
  func pushOperand (operand : Double) -> Double? {
    opStack.append(Op.Operand(operand))
    return evaluate()
  }
  
//  func pushOperand (variable : String) -> String? {
//    opStack.append(Op.Operand(variable))
//    return evaluate()
//  }
  
  func performOperation (symbol : String) -> Double? {
    //If the symbol is not nil when found, put the operation onto stack
    if let operation = knownOps[symbol] {
      opStack.append(operation)
    }
    return evaluate()
  }
}