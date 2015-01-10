import UIKit

class Stack {
  var items = [Int]()

  //Function: Remove last item from stack.
  func pop() -> Int? {
    if !items.isEmpty {
      var lastItem = items.last!
      items.removeLast()
      return lastItem
    } else {
      return nil
    } //end if
  } //end func
  
  //Function: Add item to end of stack.
  func push(newItem: Int) -> Int {
    items.append(newItem)
    return items.last!
  } //end func
  
  //Function: Return last item value from end of stack.
  func peek() -> Int? {
    if !items.isEmpty {
      return items.last!
    } else {
      return nil
    } //end if
  } //end func
  
  //Function: Return number of items in stack
  func count() -> Int {
    return items.count
  } //end func
}

var newStack = Stack()
newStack.count()
newStack.push(100)
newStack.push(50)
newStack.peek()
newStack.pop()
newStack.count()