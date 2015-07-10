//
//  ViewController.swift
//  Calculator
//
//  Created by Sau Chung Loh on 7/7/15.
//  Copyright (c) 2015 Sau Chung Loh. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

  @IBOutlet weak var display: UILabel!
  var userIsEnteringNewNumber = false
  var operandStack = Array<Double>()
  var displayValue: Double {
    get {
      return (display.text! as NSString).doubleValue //'Computes/Gets' the value of display text and converts to double
    }
    set {
      display.text = "\(newValue)" //Sets var displayValue to the returned value.
      userIsEnteringNewNumber = false
    }
  }

  @IBAction func signButtonPressed() {
    display.text! = "\(displayValue * -1)"
  }
  
  
  func clearButtonPressed() {
    display.text! = "0"
    operandStack = []
  }
  
  @IBAction func appendDigit(sender: UIButton) {
    let digit = sender.currentTitle!
    if userIsEnteringNewNumber {
      if !(display.text!.rangeOfString(".") != nil) || !(digit == ".") {
        display.text! += digit
      }
    } else {
      display.text! = digit
      userIsEnteringNewNumber = true
    }
  }
  

  
  @IBAction func enterButtonPressed() {
    userIsEnteringNewNumber = false
    operandStack.append(displayValue)
    println(operandStack)
  }
  
  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!
    if userIsEnteringNewNumber {
      enterButtonPressed()
    }
    switch operation {
      
    //Closures, passing a function into a method -> operateHelper({(op1: Double, op2: Double) -> Double in return op1 + op2})
    //Due to type inference, you can remove the types, and the function is known to return something, hence you can remove the return
    //You also do not HAVE to name your arguments, if not named, just use $0, $1, $3, etc
    //The function can be moved outside if it is the last argument. Can remove () if there's no other arguments
    case "+" : operateHelper {$0 + $1}
//      if operandStack.count >= 2 {
//        displayValue = operandStack.removeLast() + operandStack.removeLast()
//        enterButtonPressed()
//      }
    case "−" : operateHelper {$1 - $0}
//      if operandStack.count >= 2 {
//        var lastVal = operandStack.removeLast()
//        var firstVal = operandStack.removeLast()
//        displayValue =  firstVal - lastVal
//        enterButtonPressed()
//      }
    case "×" : operateHelper {$0 * $1}
//      if operandStack.count >= 2 {
//        displayValue = operandStack.removeLast() * operandStack.removeLast()
//        enterButtonPressed()
//      }
    case "÷" : operateHelper {$1 / $0}
//      if operandStack.count >= 2 {
//        var lastVal = operandStack.removeLast()
//        var firstVal = operandStack.removeLast()
//        displayValue =  firstVal / lastVal
//        enterButtonPressed()
//      }
    case "√" : operateHelper {sqrt($0)}
    case "sin" : operateHelper {sin($0)}
    case "cos" : operateHelper {cos($0)}
    case "C" : clearButtonPressed()
    default : break
    }
  }
  
  //This operation helper function takes two parameters for +, -, x, /
  func operateHelper (operation: (Double, Double) -> Double) {
    if operandStack.count >= 2 {
      displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
      enterButtonPressed()
    }
  }
  
  //This operation helper function takes one parameter for operations such as sqrt()
  //overriding/overload? methods, b/c UIKit is subclassing an ObjC class, you cannot as easily use two methods of the same name
  private func operateHelper (operation: Double -> Double) {
    if operandStack.count >= 1 {
      displayValue = operation(operandStack.removeLast())
      enterButtonPressed()
    }
  }
  
  private func operateHelper () -> Double {
    return M_PI
  }
}

