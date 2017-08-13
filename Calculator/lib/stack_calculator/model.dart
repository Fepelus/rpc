part of calculator;

//immutable
class Model {
  Stack stack;
  bool isInSandpit;
  String sandpit;

  Model(Stack inStack, bool this.isInSandpit, String this.sandpit) {
    this.stack = new Stack(inStack.list);
  }

  Model withStack(Stack newstack) => new Model(newstack, this.isInSandpit, this.sandpit);

  Model withSandpit(String newSandpit) => new Model(this.stack, true, newSandpit);

  Model withEmptySandpit() =>  new Model(this.stack, false, '');

  CalculatorState calculatorState() => new CalculatorState(stack.list.reversed.toList(), isInSandpit, sandpit);
}

//immutable
class Stack {

  built.BuiltList<double> _stack;

  Stack(built.BuiltList<double> input) {
    this._stack = input;
  }

  Stack.empty() {
    this._stack = new built.BuiltList<double>();
  }

  get isEmpty => _stack.isEmpty;

  get list => _stack;

  Stack push(String input) => new Stack(_stack.rebuild((b) => b.add(double.parse(input))));

  PoppedTuple pop() => new PoppedTuple(shrink, _stack[_stack.length - 1]);

  get shrink => isEmpty
      ?  throw 'Cannot pop empty stack'
      : new Stack(_stack.rebuild((b) => b.removeLast()));


  @override String toString() => _stack.toString();
}

class PoppedTuple<Stack, double> {
  Stack _stack;
  double _value;

  PoppedTuple(Stack this._stack, double this._value);

  get stack => _stack;

  get value => _value;
}

