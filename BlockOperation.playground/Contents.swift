import Cocoa
import Foundation

let phrase = "To be, or not to be, that is the question:"
let blockOperation = BlockOperation()

for word in phrase.split(separator: " ") {
    blockOperation.addExecutionBlock {
        print(word)
        Thread.sleep(forTimeInterval: 2)
    }
}

blockOperation.completionBlock = {
    print("I said enough for today")
}

duration {
    blockOperation.start()
}

