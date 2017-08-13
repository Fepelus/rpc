part of calculator;

class StackCalculator implements Calculator {
  State _currentState;
  StateListener _listener;

  List<State> undoStack = [];
  List<State> redoStack = [];

  StackCalculator(StateListener this._listener) {
    _currentState = new StackState(new Model(new Stack.empty(), false, ''));
    update();
  }

  @override digit(int input) {
    assert(0 <= input && input < 10);
    _do(_currentState.digit(input));
  }

  @override enter() => _do(_currentState.enter());

  @override delete() => _do(_currentState.delete());

  @override decimalPoint() => _do(_currentState.decimalPoint());

  @override add() => _do(_currentState.add());

  @override subtract() => _do(_currentState.subtract());

  @override multiply() => _do(_currentState.multiply());

  @override divide() => _do(_currentState.divide());

  @override power() => _do(_currentState.power());

  @override plusMinus() => _do(_currentState.plusMinus());

  @override swap() => _do(_currentState.swap());

  @override undo() {
    if (undoStack.length > 0) {
      redoStack.add(_currentState);
      _currentState = undoStack.removeLast();
      update();
    }
  }

  @override redo() {
    if (redoStack.length > 0) {
      undoStack.add(_currentState);
      _currentState = redoStack.removeLast();
      update();
    }
  }

  _do(State newState) {
    if (newState != _currentState) {
      undoStack.add(_currentState);
      redoStack.clear();
      _currentState = newState;
      update();
    }
  }

  update() => this._listener.update(_currentState._model.calculatorState());
}

