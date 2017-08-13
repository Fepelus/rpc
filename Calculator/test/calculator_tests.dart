library calculator_tests;

import 'package:calculator/calculator.dart' as c;
import 'package:test/test.dart';

main() {
  group('bootstrapping', () {
    test('the test suite', () => expect(true, isTrue));

    test('the interface', () {
      TestBoundary listener = new TestBoundary();
      c.Calculator calc = new c.StackCalculator(listener);
    });
  });

  group('given you have a new calculator,', () {
    TestBoundary listener;
    c.Calculator calc;
    setUp(() {
      listener = new TestBoundary();
      calc = new c.StackCalculator(listener);
    });
    test("then the calculator has reported that it is not in the sandpit", () =>
        expect(listener.isSandpit, isFalse)
    );
    test("then the calculator has reported that the stack has no entries", () =>
        expect(listener.stack.length, equals(0))
    );
    group('when you send a single digit', () {
      setUp(() => calc.digit(1));
      test('then calculator reports that it is in the sandpit', () =>
          expect(listener.isSandpit, isTrue)
      );
      test('then calculator reports that the sandpit has the digit', () =>
          expect(listener.sandpit, equals('1'))
      );

      group('and you send enter', () {
        setUp(() => calc.enter());
        test('then calculator reports that it is not in the sandpit', () =>
            expect(listener.isSandpit, isFalse)
        );
        test('then the stack has the digit at the top', () {
          expect(listener.stack.length, equals(1));
          expect(listener.stack[0], equals(1.0));
        });
      });

      group('and you send delete', () {
        setUp(() => calc.delete());
        test("then the calculator has reported that it is not in the sandpit", () =>
            expect(listener.isSandpit, isFalse)
        );
        test("then the calculator has reported that the stack has no entries", () =>
            expect(listener.stack.length, equals(0))
        );
      });

      group('and you send a decimal point', () {
        setUp(() => calc.decimalPoint());
        test("then the sandpit has a decimal point", () {
          expect(listener.isSandpit, isTrue);
          expect(listener.sandpit, equals('1.'));
        });
        group('and you send another digit and then enter', () {
          setUp(() {
            calc.digit(9);
            calc.enter();
          });
          test("then the stack has a decimal point", () {
            expect(listener.isSandpit, isFalse);
            expect(listener.sandpit, equals(''));
            expect(listener.stack[0], equals(1.9));
          });
        });
        group('and you send another decimal point', () {
          var countBefore;
          setUp(() {
            countBefore = listener.numberOfUpdates;
            calc.decimalPoint();
          });
          test("then the keypress is ignored", () =>
              expect(listener.numberOfUpdates, equals(countBefore))
          );
        });
      });

      group('and you send a second digit', () {
        setUp(() => calc.digit(2));
        test('then calculator reports that it is still in the sandpit', () =>
            expect(listener.isSandpit, isTrue)
        );
        test('then calculator reports that the sandpit has the digit', () =>
            expect(listener.sandpit, equals('12'))
        );
        group('and you send enter', () {
          setUp(() => calc.enter());
          test('then calculator reports that it is not in the sandpit', () =>
              expect(listener.isSandpit, isFalse)
          );
          test('then the stack has the digit at the top', () {
            expect(listener.stack.length, equals(1));
            expect(listener.stack[0], equals(12.0));
          });
        });
      });
    });
    group('when you send a single digit', () {
      int countBefore;
      setUp(() {
        countBefore = listener.numberOfUpdates;
        calc.undo();
      });
      test('then nothing happens', () => expect(listener.numberOfUpdates, equals(countBefore)));
    });
  });

  group('given you have a calculator with a number on the stack and one on the sandpit,', () {
    TestBoundary listener;
    c.Calculator calc;
    setUp(() {
      listener = new TestBoundary();
      calc = new c.StackCalculator(listener);
      calc.digit(3);
      calc.enter();
      calc.digit(2);
    });
    group('when you press enter', () {
      setUp(() => calc.enter());
      test("then the new number is at the top of the stack", () =>
          expect(listener.stack[0], equals(2.0))
      );
      group('and you press "plusMinus"', () {
        setUp(() => calc.plusMinus());
        test("then the head of the stack has had its sign inverted", () =>
            expect(listener.stack[0], equals(-2.0))
        );
      });
    });
    group('when you press "add"', () {
      setUp(() => calc.add());
      test("then the answer is at the top of the stack", () =>
          expect(listener.stack[0], equals(5.0))
      );
      test("then the stack has only one element", () =>
          expect(listener.stack.length, equals(1))
      );
      test("then the calculator is not in sandpit", () =>
          expect(listener.isSandpit, isFalse)
      );
    });
    group('when you press "subtract"', () {
      setUp(() => calc.subtract());
      test("then the answer is at the top of the stack", () =>
          expect(listener.stack[0], equals(1.0))
      );
    });
    group('when you press "multiply"', () {
      setUp(() => calc.multiply());
      test("then the answer is at the top of the stack", () =>
          expect(listener.stack[0], equals(6.0))
      );
    });
    group('when you press "divide"', () {
      setUp(() => calc.divide());
      test("then the answer is at the top of the stack", () =>
          expect(listener.stack[0], equals(1.5))
      );
    });
    group('when you press "power"', () {
      setUp(() => calc.power());
      test("then the answer is at the top of the stack", () =>
          expect(listener.stack[0], equals(9.0))
      );
    });
    group('when you press "plusMinus"', () {
      setUp(() => calc.plusMinus());
      test("then the sandpit has had its sign inverted", () =>
          expect(listener.sandpit, equals('-2'))
      );
    });
    group('when you press "swap"', () {
      setUp(() => calc.swap());
      test("then the two elements of the stack are your two numbers swapped in order", () {
        expect(listener.stack[0], equals(3.0));
        expect(listener.stack[1], equals(2.0));
        expect(listener.stack.length, equals(2));
      });
    });
  });

  group('given you have a calculator with three numbers on the stack,', () {
    TestBoundary listener;
    c.Calculator calc;
    setUp(() {
      listener = new TestBoundary();
      calc = new c.StackCalculator(listener);
      calc.digit(3);
      calc.digit(3);
      calc.enter();
      calc.digit(4);
      calc.digit(4);
      calc.enter();
      calc.digit(5);
      calc.digit(5);
      calc.enter();
    });
    group('when you press "delete"', () {
      setUp(() => calc.delete());
      test("then the appropriate stack results", () {
        expect(listener.stack[0], equals(44.0));
        expect(listener.stack[1], equals(33.0));
        expect(listener.stack.length, equals(2));
      });
    });
  });

  group('given a bunch of stuff on the undo stack,', () {
    TestBoundary listener;
    c.Calculator calc;
    setUp(() {
      listener = new TestBoundary();
      calc = new c.StackCalculator(listener);
      calc.digit(3);
      calc.enter();
      calc.digit(4);
      calc.multiply();
      calc.digit(5);
      calc.add();
      calc.digit(5);
      calc.decimalPoint();
      calc.digit(3);
      calc.add();
      calc.digit(5);
      calc.enter();
    });
    test('then the calculator is not in sandpit', () => expect(listener.isSandpit, isFalse));
    group('when you press "undo"', ()
    {
      int countBefore;
      setUp(() {
        countBefore = listener.numberOfUpdates;
        calc.undo();
      });
      test("then the listener has been updated", () =>
          expect(listener.numberOfUpdates, equals(countBefore + 1)));
      test("and the calculator has undone the 'enter' and is in sandpit", () =>
          expect(listener.isSandpit, isTrue));
      test("and the previous head of the stack is back on the stack", () =>
          expect(listener.stack[0], equals(22.3)));
      group('and you press "redo', () {
        setUp(() => calc.redo());
        test("then we are not in sandpit", () => expect(listener.isSandpit, isFalse));
        test("then we have re-entered the 5", () =>
            expect(listener.stack[0], equals(5.0))
        );
        group('and you press "undo" again', () {
          setUp(() => calc.undo());
          test("then the previous change is undone", () {
            expect(listener.isSandpit, isTrue);
            expect(listener.stack[0], equals(22.3));
          });
        });
      });
         group('and you press "undo" again', () {
              setUp(() => calc.undo());
              test(
            "then the calculator has undone the digit(5) and is not in sandpit", () {
          expect(listener.isSandpit, isFalse);
          expect(listener.stack[0], equals(22.3));
        });
        group('and you press "undo" again', () {
          setUp(() => calc.undo());
          test(
              "then the calculator has undone the 'add' and is back in sandpit", () {
            expect(listener.isSandpit, isTrue);
            expect(listener.sandpit, equals('5.3'));
            expect(listener.stack[0], equals(17.0));
          });
        });
      });
    });
  });
}

class TestBoundary implements c.StateListener {
  List<double> stack;
  bool isSandpit;
  String sandpit;
  int numberOfUpdates = 0;

  @override
  void update(c.CalculatorState state) {
    this.stack = state.stack;
    this.isSandpit = state.isSandpit;
    this.sandpit = state.sandpit;
    this.numberOfUpdates++;
  }
}