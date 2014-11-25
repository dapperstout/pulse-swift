import Foundation

public class Luhn {

    var characterToCodepoint: Dictionary<Character, Int> = [:]
    var codepointToCharacter: Dictionary<Int, Character> = [:]
    let alphabetSize: Int

    let emulateWrongAlgorithm: Bool // emulate the mistake that was made in the Go version of the algorithm

    public init(_ alphabet: String, emulateWrongAlgorithm: Bool = false) {
        alphabetSize = countElements(alphabet)
        var codepoint: Int = 0
        for character in alphabet {
            characterToCodepoint[character] = codepoint
            codepointToCharacter[codepoint] = character
            codepoint++
        }
        self.emulateWrongAlgorithm = emulateWrongAlgorithm
    }

    public func calculateCheckDigit(string: String) -> Character {
        var sum = 0
        var factor = 2
        var characters = reverse(string)

        if emulateWrongAlgorithm {
            factor = 1
            characters = reverse(characters)
        }

        for character in characters {
            let codepoint = characterToCodepoint[character]!
            let digits = factor * codepoint
            sum += digits / alphabetSize + digits % alphabetSize
            factor = factor == 1 ? 2 : 1
        }

        let check = (-sum).modulo(alphabetSize)
        return codepointToCharacter[check]!;
    }
}

public let LuhnMod10 = Luhn("0123456789")
public let LuhnBase32 = Luhn("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")
public let LuhnBase32Wrong = Luhn("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567", emulateWrongAlgorithm: true)

extension Int {

    func modulo(divisor: Int) -> Int {
        var result = self % divisor
        if (result < 0) {
            result += divisor
        }
        return result
    }
}