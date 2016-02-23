////: Playground - noun: a place where people can play

import UIKit
////Given an array of ints of odd length, return a new array length 3 containing the elements from the middle of the array. The array length will be at least 3.

func oddArray(array: [Int]) -> [Int]
{
    let element = array.count / 2
    let firstElement = element - 1
    let thirdElement = element + 1
    
    return [array[firstElement], array[element], array[thirdElement]]
}

let test = [1,2,3,4,5,6,7,8,9,10,11]
let randomNumbers = [8,3,6,88,18,23,22,28,4]

oddArray(test)
oddArray(randomNumbers)
