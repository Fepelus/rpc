import 'package:test/test.dart';
import 'package:rpccli/cli.dart' as cli;
import 'package:calculator/calculator.dart' as calc;


calculator_tests() {

  group('Given an unparsed token,', () {
    cli.Token token;
    TestCalculator calculator;
    setUp(() {
      token = new cli.BareToken("nonsense");
      calculator = new TestCalculator();
    });
    group('when I pass a calculator to the token', () =>
      test('then the token throws an exception', () {
        expect(() => token.execute(calculator), throwsA('Bad symbol: "nonsense"'));
      })
    );
  });

  group('Given a number token,', () {
    cli.Token token;
    TestCalculator calculator;
    setUp(() {
      token = new cli.NumberToken(new cli.BareToken("12"));
      calculator = new TestCalculator();
    });
    group('when I pass a calculator to the token', () {
      setUp(() => token.execute(calculator));
      test('then the calculator has the number on the stack', () {
        expect(calculator.digitWasCalled, isTrue);
        expect(calculator.enterWasCalled, isTrue);
      });
    });
  });

  group('Given a number token with a floating point number,', () {
    cli.Token token;
    TestCalculator calculator;
    setUp(() {
      token = new cli.MultiplyToken(new cli.NumberToken(new cli.BareToken("1.2")));
      calculator = new TestCalculator();
    });
    group('when I pass a calculator to the token', () {
      setUp(() => token.execute(calculator));
      test('then the calculator has the number on the stack', () {
        expect(calculator.digitWasCalled, isTrue);
        expect(calculator.decimalPointWasCalled, isTrue);
        expect(calculator.enterWasCalled, isTrue);
        expect(calculator.multiplyWasCalled, isFalse);
      });
    });
  });

  group('Given a plus token,', () {
    cli.Token token;
    TestCalculator calculator;
    setUp(() {
      token = new cli.PlusToken(new cli.BareToken("+"));
      calculator = new TestCalculator();
    });
    group('when I pass a calculator to the token', () {
      setUp(() => token.execute(calculator));
      test('then the calculator has been told to add', () {
        expect(calculator.addWasCalled, isTrue);
      });
    });
  });

  group('Given a minus token,', () {
    cli.Token token;
    TestCalculator calculator;
    setUp(() {
      token = new cli.MinusToken(new cli.BareToken("-"));
      calculator = new TestCalculator();
    });
    group('when I pass a calculator to the token', () {
      setUp(() => token.execute(calculator));
      test('then the calculator has been told to subtract', () {
        expect(calculator.subtractWasCalled, isTrue);
      });
    });
  });

  group('Given a times token,', () {
    cli.Token token;
    TestCalculator calculator;
    setUp(() {
      token = new cli.MultiplyToken(new cli.BareToken("*"));
      calculator = new TestCalculator();
    });
    group('when I pass a calculator to the token', () {
      setUp(() => token.execute(calculator));
      test('then the calculator has been told to multiply', () {
        expect(calculator.multiplyWasCalled, isTrue);
      });
    });
  });

  group('Given a divide token,', () {
    cli.Token token;
    TestCalculator calculator;
    setUp(() {
      token = new cli.DivideToken(new cli.BareToken("/"));
      calculator = new TestCalculator();
    });
    group('when I pass a calculator to the token', () {
      setUp(() => token.execute(calculator));
      test('then the calculator has been told to divide', () {
        expect(calculator.divideWasCalled, isTrue);
      });
    });
  });

  group('Given a power token,', () {
    cli.Token token;
    TestCalculator calculator;
    setUp(() {
      token = new cli.PowerToken(new cli.BareToken("^"));
      calculator = new TestCalculator();
    });
    group('when I pass a calculator to the token', () {
      setUp(() => token.execute(calculator));
      test('then the calculator has been told to take the power', () {
        expect(calculator.powerWasCalled, isTrue);
      });
    });
  });

}

class TestCalculator implements calc.Calculator {
  bool digitWasCalled = false;
  bool enterWasCalled = false;
  bool decimalPointWasCalled = false;
  bool addWasCalled = false;
  bool subtractWasCalled = false;
  bool multiplyWasCalled = false;
  bool divideWasCalled = false;
  bool powerWasCalled = false;
  digit(int input) => this.digitWasCalled = true;
  enter() => this.enterWasCalled = true;
  decimalPoint() => this.decimalPointWasCalled = true;
  add() => this.addWasCalled = true;
  subtract() => this.subtractWasCalled = true;
  multiply() => this.multiplyWasCalled = true;
  divide() => this.divideWasCalled = true;
  power() => this.powerWasCalled = true;
  delete() {}
  plusMinus() {}
  swap() {}
  undo() {}
  redo() {}

}