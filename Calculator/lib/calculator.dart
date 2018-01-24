library calculator;

import 'dart:math';
import 'package:built_collection/built_collection.dart' as built;

part 'stack_calculator/state.dart';
part 'stack_calculator/model.dart';
part 'stack_calculator/stack_calculator.dart';

abstract class Calculator {
  digit(int input);
  enter();
  delete();
  decimalPoint();
  add();
  subtract();
  multiply();
  divide();
  power();
  plusMinus();
  swap();
  undo();
  redo();
}

abstract class StateListener {
  void update(CalculatorState model);
}

class CalculatorState {
  List<double> stack;
  bool isSandpit;
  String sandpit;

  CalculatorState(this.stack, this.isSandpit, this.sandpit);
}



