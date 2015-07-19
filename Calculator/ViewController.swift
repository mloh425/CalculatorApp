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

  @IBOutlet weak var historyDisplay: UILabel!
  @IBOutlet weak var display: UILabel!
  var userIsEnteringNewNumber = false
  var calculatorModel = CalculatorModel()
  
  var displayValue: Double? {
    get {
      return (display.text! as NSString).doubleValue //'Computes/Gets' the value of display text and converts to double
    }
    set {
      if let value = newValue {
        display.text = "\(value)"
      } else {
        display.text = " "
      }
      userIsEnteringNewNumber = false
//      display.text = "\(newValue)" //Sets var displayValue to the returned value.
//      userIsEnteringNewNumber = false
      }
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
    if let value = displayValue {
      if let result = calculatorModel.pushOperand(value) {
        displayValue = result
      } else {
        displayValue = nil
      }
    } else {
      displayValue = nil
    }
    
//    if let result = calculatorModel.pushOperand(displayValue) { //Implicitly unwrapped displayValue after making optional
//      updateHistoryLabel("\(result)")
//      displayValue = result
//    } else {
//      displayValue = 0
//    }
  }
  
  func updateHistoryLabel (text : String) {
    if historyDisplay.text! == "0" {
      historyDisplay.text! = text + " "
    } else {
      historyDisplay.text! += text + " "
    }
  }
  
  @IBAction func clearButtonPressed(sender: AnyObject) {
    displayValue = 0
    historyDisplay.text! = ""
    calculatorModel.clearStack()
  }
  
  @IBAction func operate(sender: UIButton) {
    if userIsEnteringNewNumber {
      enterButtonPressed()
    }
    if let operation = sender.currentTitle {
      updateHistoryLabel("\(operation)")
      if let result = calculatorModel.performOperation(operation) {
        displayValue = result
      } else {
        displayValue = 0
      }
    }
  }
}

