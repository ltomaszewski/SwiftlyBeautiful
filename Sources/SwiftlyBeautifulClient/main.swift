import SwiftlyBeautiful

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

@Printable
class Model {
    let abecadlo: String
    let lol: Int
    let kkkk: String
    
    init(abecadlo: String, lol: Int) {
        self.abecadlo = abecadlo
        self.lol = lol
        self.kkkk = "ABBB"
    }
}

let testModel = Model(abecadlo: "ABBBB", lol: 4)

print(testModel.description)
