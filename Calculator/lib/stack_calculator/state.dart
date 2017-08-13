part of calculator;

abstract class State {
  Model _model;
  State digit(int input);
  State enter();
  State delete();
  State decimalPoint();
  State add();
  State subtract();
  State multiply();
  State divide();
  State power();
  State plusMinus();
  State swap();
}

// immutable
class SandpitState implements State {
  SandpitState(this._model);
  SandpitState.With(Stack stack, String sandpit) {
    this._model = new Model(stack, true, sandpit);
  }

  @override Model _model;

  @override State digit(int input) => new SandpitState(_model.withSandpit(_model.sandpit + input.toString()));

  @override State enter() => new StackState.With(_model.stack.push(_model.sandpit));

  @override State delete() =>
    _model.sandpit.length > 1
      ? new SandpitState(_model.withSandpit(_model.sandpit.substring(0, _model.sandpit.length - 1)))
      : new StackState.With(_model.stack);

  @override State decimalPoint() =>
    _model.sandpit.contains(new RegExp(r'\.'))
        ? this
        : new SandpitState(_model.withSandpit(_model.sandpit + '.'));

  @override State plusMinus() {
    if (double.parse(_model.sandpit) == 0) {
      return this;
    }
    if (_model.sandpit[0] == "-") {
      return new SandpitState(_model.withSandpit(_model.sandpit.substring(0, _model.sandpit.length - 1)));
    }
    return new SandpitState(_model.withSandpit("-" + _model.sandpit));
  }

  @override State add() => this.enter().add();
  @override State subtract() => this.enter().subtract();
  @override State multiply() => this.enter().multiply();
  @override State divide() => this.enter().divide();
  @override State power() => this.enter().power();
  @override State swap() => this.enter().swap();

  @override String toString() => "sandpit: " + _model.stack.toString() + ":'" + _model.sandpit + "'";
}

// immutable
class StackState implements State {
  StackState(this._model);
  StackState.With(Stack stack) {
    this._model = new Model(stack, false, '');
  }

  @override Model _model;

  @override State enter() => this;
  @override State digit(int input) =>  new SandpitState(_model.withSandpit(_model.sandpit + input.toString()));
  @override State delete() =>
    _model.stack.isEmpty
      ? throw 'Cannot delete from an empty stack'
      : new StackState.With(_model.stack.shrink);

  @override State decimalPoint() => new SandpitState.With(_model.stack, "0.");
  @override State add() {
    var addendPop = _model.stack.pop();
    var augendPop = addendPop.stack.pop();
    return new StackState.With(augendPop.stack.push((augendPop.value + addendPop.value).toString()));
  }
  @override State subtract() {
    var subtrahendPop = _model.stack.pop();
    var minuendPop = subtrahendPop.stack.pop();
    return new StackState.With(minuendPop.stack.push((minuendPop.value - subtrahendPop.value).toString()));
  }
  @override State multiply() {
    var multiplierPop = _model.stack.pop();
    var multiplicandPop = multiplierPop.stack.pop();
    return new StackState.With(multiplicandPop.stack.push((multiplicandPop.value * multiplierPop.value).toString()));
  }
  @override State divide() {
    var divisorPop = _model.stack.pop();
    var dividendPop = divisorPop.stack.pop();
    return new StackState.With(dividendPop.stack.push((dividendPop.value / divisorPop.value).toString()));
  }
  @override State power() {
    var exponentPop = _model.stack.pop();
    var nPop = exponentPop.stack.pop();
    return new StackState.With(nPop.stack.push(pow(nPop.value, exponentPop.value).toString()));
  }
  @override State plusMinus() {
    PoppedTuple pop = _model.stack.pop();
    return new StackState.With(pop.stack.push((pop.value * -1).toString()));
  }
  @override State swap() {
    var originalHeadPop = _model.stack.pop();
    var originalDeputyPop = originalHeadPop.stack.pop();

    return new StackState.With(
        originalDeputyPop.stack
            .push(originalHeadPop.value.toString())
            .push(originalDeputyPop.value.toString())
    );
  }
  @override String toString() => "stack: " + _model.stack.toString();

}


