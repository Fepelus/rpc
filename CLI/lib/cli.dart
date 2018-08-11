// Copyright (c) 2017, paddy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library cli;

import 'package:calculator/calculator.dart' as calc;

abstract class Parser {
  Iterable<Token> tokens;
}

class CliParser implements Parser {
  Iterable<Token> tokens;
  CliParser(String input) {
    tokens = _lex(input).map((s) => new PowerToken(new DivideToken(
        new MultiplyToken(new MinusToken(
            new PlusToken(new NumberToken(new BareToken(s))))))));
  }
}

List<String> _lex(String input) => input.split(new RegExp(r'\s+'));

abstract class Token {
  TokenType type;
  String value;
  execute(calc.Calculator calculator);
}

class BareToken implements Token {
  String _input;
  BareToken(this._input) {
    // print("TKN: " + this._input + "\n");
    this.value = _input;
  }
  @override TokenType type = TokenType.UNKNOWN;
  @override var value;
  @override execute(calc.Calculator calculator) {
    throw 'Bad symbol: "' + value + '"';
  }

}

abstract class OperatorToken implements Token {
  Token innerToken;
  OperatorToken(this.innerToken);
  get value => innerToken.value;
  set value(String in_value) => innerToken.value = in_value;
  get type => innerToken.type;
  set type(TokenType in_type) => innerToken.type = in_type;
}

class NumberToken extends OperatorToken {
  NumberToken(inToken) : super(inToken);
  bool isANumber() => new RegExp(r'^-?\d+(\.\d+)?$').hasMatch(innerToken.value);
  get type => isANumber() ? TokenType.NUMBER : innerToken.type;
  @override execute(calc.Calculator calculator) {
    if (!isANumber()) {
      innerToken.execute(calculator);
      return;
    }
    value.split("").forEach((ch) {
      if (ch == '-') {
        calculator.plusMinus();
      } else if (ch == '.') {
        calculator.decimalPoint();
      } else {
        calculator.digit(int.parse(ch));
      }
    });
    calculator.enter();
  }

}

class PlusToken extends OperatorToken {
  PlusToken(Token inToken) : super(inToken);
  bool isPlus() => "+" == innerToken.value;
  get type => isPlus() ? TokenType.PLUS : innerToken.type;
  @override execute(calc.Calculator calculator) => isPlus() ? calculator.add() : innerToken.execute(calculator);
}

class MinusToken extends OperatorToken {
  MinusToken(Token inToken) : super(inToken);
  bool isMinus() => "-" == innerToken.value;
  get type => isMinus() ? TokenType.MINUS : innerToken.type;
  @override execute(calc.Calculator calculator) => isMinus() ? calculator.subtract() : innerToken.execute(calculator);
}

class MultiplyToken extends OperatorToken {
  MultiplyToken(Token inToken) : super(inToken);
  bool isMultiply() => "*" == innerToken.value;
  get type => isMultiply() ? TokenType.MULTIPLY : innerToken.type;
  @override execute(calc.Calculator calculator) => isMultiply() ? calculator.multiply() : innerToken.execute(calculator);
}

class DivideToken extends OperatorToken {
  DivideToken(Token inToken) : super(inToken);
  bool isDivide() => "/" == innerToken.value;
  get type => isDivide() ? TokenType.DIVIDE : innerToken.type;
  @override execute(calc.Calculator calculator) => isDivide() ? calculator.divide() : innerToken.execute(calculator);
}

class PowerToken extends OperatorToken {
  PowerToken(Token inToken) : super(inToken);
  bool isPower() => ['^', 'pow', 'power', 'exp'].contains(innerToken.value);
  get type => isPower() ? TokenType.POWER : innerToken.type;
  @override execute(calc.Calculator calculator) => isPower() ? calculator.power() : innerToken.execute(calculator);
}

enum TokenType { UNKNOWN, NUMBER, PLUS, MINUS, MULTIPLY, DIVIDE, POWER }

class CliListener implements calc.StateListener {
  double stackhead;
  void update(calc.CalculatorState state) {
    if (state.stack.length == 0) {
      return;
    }
    stackhead = state.stack[0];
  }

}
