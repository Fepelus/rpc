
import 'package:calculator/calculator.dart' as calc;
import 'dart:isolate' as iso;

void isomain(iso.SendPort sendPort) {
  final iso.ReceivePort receivePort = new iso.ReceivePort();
  calc.Calculator calculator;
  sendPort.send(receivePort.sendPort);
  receivePort.listen((String data) {
    if (calculator == null) {
      calculator = new calc.StackCalculator(new Listener(sendPort));
    }
    try {
      (new TranslatedCommand(data)).call(calculator);
    } catch (e) {
      // Ignore
    }
  });
}



class TranslatedCommand {
  Map<String, Function> parseMap = <String, Function>{
    'ENTER': (calc.Calculator c) => c.enter(),
    'UNDO': (calc.Calculator c) => c.undo(),
    'REDO': (calc.Calculator c) => c.redo(),
    'DELETE': (calc.Calculator c) => c.delete(),
    'POWER': (calc.Calculator c) => c.power(),
    'SWAP': (calc.Calculator c) => c.swap(),
    'PLUSMINUS': (calc.Calculator c) => c.plusMinus(),
    'ADD': (calc.Calculator c) => c.add(),
    'SUBTRACT': (calc.Calculator c) => c.subtract(),
    'DIVIDE': (calc.Calculator c) => c.divide(),
    'MULTIPLY': (calc.Calculator c) => c.multiply(),
    'DECIMALPOINT': (calc.Calculator c) => c.decimalPoint(),
    'DIGIT0': (calc.Calculator c) => c.digit(0),
    'DIGIT1': (calc.Calculator c) => c.digit(1),
    'DIGIT2': (calc.Calculator c) => c.digit(2),
    'DIGIT3': (calc.Calculator c) => c.digit(3),
    'DIGIT4': (calc.Calculator c) => c.digit(4),
    'DIGIT5': (calc.Calculator c) => c.digit(5),
    'DIGIT6': (calc.Calculator c) => c.digit(6),
    'DIGIT7': (calc.Calculator c) => c.digit(7),
    'DIGIT8': (calc.Calculator c) => c.digit(8),
    'DIGIT9': (calc.Calculator c) => c.digit(9)
  };
  final String command;
  TranslatedCommand(this.command) {
    if (!parseMap.containsKey(this.command)) {
      throw "parseMap does not contain $command";
    }
  }
  void call(calc.Calculator calculator) {
    parseMap[this.command](calculator);
  }
}

class Listener implements calc.StateListener {
  final iso.SendPort sendPort;
  Listener(this.sendPort);

  @override
  void update(calc.CalculatorState state) {
    sendPort.send(state);
  }


}