//: Playground - noun: a place where people can play

import UIKit

// Write a function that takes in an array of numbers, and returns the lowest and highest numbers as a tuple

var test = [99,1,7,12,20,88]
var numbers = [8,2,10,15,23,28,22,5,24]

func arrayNumbers(array:[Int]) -> (low: Int, high: Int)
{
    var low:Int
    var lowest: Int = Int()
    
    for number in array
    {
        if number == array.first
        {
            lowest = number
        } else{
            if number < lowest {
                lowest = number
            }
        }
    }
    low = lowest
    
    var high: Int
    var highest: Int = Int()
    
    for number in array
    {
        if number == array.first
        {
            highest = number
        } else {
            if number > highest {
                highest = number
            }
        }
    }
    high = highest
    
    return (high,low)
}

arrayNumbers(test)
arrayNumbers(numbers)
