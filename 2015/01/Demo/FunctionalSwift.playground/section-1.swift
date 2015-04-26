import UIKit


// Imperativer Ansatz mit Seiteneffekte
let numbers = Array(1...10)
var total = 0

func addNumbers0() {
    for number in numbers {
        total += number
    }
}

addNumbers0(); total
addNumbers0(); total
addNumbers0(); total
addNumbers0(); total

// Ansatz ohne Seiteneffekte
func addNumbers1(numbers: [Int]) -> Int {
    var sum = 0
    for number in numbers {
        sum += number
    }
    return sum
}
addNumbers1(numbers)
addNumbers1(numbers)
addNumbers1(numbers)


// Funktionaler Ansatz
func addNumbers2(numbers: [Int]) -> Int {
    //func reduce<U>(initial: U, combine: (U, T) -> U) -> U
    return numbers.reduce(0, combine: { (sum: Int, number: Int) in
        return sum + number
    })
}

addNumbers2(numbers)
addNumbers2(numbers)
addNumbers2(numbers)


// kürzer mit Trailing Closure
func addNumbers3(numbers: [Int]) -> Int {
    return numbers.reduce(0) { sum, number in
        sum + number
    }
}
addNumbers3(numbers)
addNumbers3(numbers)
addNumbers3(numbers)


// noch kürzer
let add: (Int, Int) -> Int = {sum, number in sum + number}
numbers.reduce(0, add)
numbers.reduce(0, add)
numbers.reduce(0, add)


// am kürzesten
numbers.reduce(0, +)
numbers.reduce(0, +)
numbers.reduce(0, +)

reduce(numbers, 0, +)


// map
var squares0: [Int] = []
for number in numbers {
    squares0.append(number * number)
}
squares0


let squares1 = numbers.map { $0 * $0 }
squares1
// let squares1 = map(numbers) { $0 * $0 }


// filter
var odds0: [Int] = []
for number in numbers {
    if number % 2 == 1 {
        odds0.append(number)
    }
}
odds0


let odds1 = numbers.filter { $0 % 2 == 1 }
odds1
// let odds1 = filter(numbers) { $0 % 2 == 1 }


enum Result {
    case Value(AnyObject)
    case Error(String)
}

struct GHCalculator {
    static func divide(x: Double, by y: Double) -> Result {
        if y != 0 {
            return .Value(x / y)
        } else {
            return .Error("Division by zero not allowed.")
        }
    }
}

let result = GHCalculator.divide(2.5, by: 2.6)
switch result {
case .Value(let quotient):
    "The result is \(quotient)."
case .Error(let errorMessage):
    println(errorMessage)
}


//enum Result<T> {
//    case Value(T)
//    case Error(NSError)
//}
//enum Bla {
//    case Foo
//    case Bar
//}
//
//let result = Result<Bla>.Value(.Foo)
//
//switch result {
//case .Value(let value) where value == .Foo:
//    println(value)
//case .Value(let value):
//    println(value)
//case .Error(let error):
//    break
//}



