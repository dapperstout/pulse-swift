import XCTest
import pulse

class LuhnTests: XCTestCase {

    func testCalculatesCheckDigitForSingleCharacter() {
        XCTAssertEqual(LuhnMod10.calculateCheckDigit("0"), Character("0"))
        XCTAssertEqual(LuhnMod10.calculateCheckDigit("1"), Character("8"))
        XCTAssertEqual(LuhnMod10.calculateCheckDigit("4"), Character("2"))
        XCTAssertEqual(Luhn("ABC").calculateCheckDigit("B"), Character("B"))
    }

    func testSumsDigits() {
        XCTAssertEqual(LuhnMod10.calculateCheckDigit("6"), Character("7"))
        XCTAssertEqual(LuhnMod10.calculateCheckDigit("5"), Character("9"))
        XCTAssertEqual(LuhnMod10.calculateCheckDigit("9"), Character("1"))
    }

    func testDoublesEveryOtherCharacter() {
        XCTAssertEqual(LuhnMod10.calculateCheckDigit("11"), Character("7"))
        XCTAssertEqual(LuhnMod10.calculateCheckDigit("7458"), Character("3"))
    }

    func testBase32() {
        XCTAssertEqual(LuhnBase32.calculateCheckDigit("U"), Character("X"))
    }

    func testEmulatesWrongAlgorithmFromGoVersion() {
        XCTAssertEqual(LuhnBase32Wrong.calculateCheckDigit("P56IOI7MZJNU2"), Character("Y"))
    }
}