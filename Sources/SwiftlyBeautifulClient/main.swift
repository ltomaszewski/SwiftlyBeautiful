import SwiftlyBeautiful

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")


// Printable

@Printable
class Model {
    let abecadlo: String
    let lol: Int
    let kkkk: String
    let subModels: [SubModel]
    
    init(abecadlo: String, lol: Int) {
        self.abecadlo = abecadlo
        self.lol = lol
        self.kkkk = "ABBB"
        self.subModels = [.init(subText: "LOL")]
    }
}

@Printable
class SubModel {
    let subText: String
    
    init(subText: String) {
        self.subText = subText
    }
}

let testModel = Model(abecadlo: "ABBBB", lol: 4)

print(testModel.description)
