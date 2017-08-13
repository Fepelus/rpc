import 'dart:isolate' as iso;
import 'package:flutter/material.dart';
import 'package:calculator/calculator.dart' as calc;
import './calculator_isolate.dart';

void main() {
  calculatorIsolate = new CalculatorIsolate();
  calculatorIsolate.connect();
  runApp(new MyApp());
}

CalculatorIsolate calculatorIsolate;

class CalculatorIsolate {
  List<calc.StateListener> listeners = new List<calc.StateListener>();
  iso.SendPort sendPort;
  void connect() {
    final iso.ReceivePort receivePort = new iso.ReceivePort();
    iso.Isolate.spawn(isomain, receivePort.sendPort).then<iso.Isolate>((_) {
      receivePort.listen((dynamic msg) =>
          (msg is iso.SendPort) ? sendPort = msg : notify(msg));
    });
  }

  void notify(calc.CalculatorState data) => listeners
      .forEach((calc.StateListener l) => l.update(data));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'RPC',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting
        // the app, try changing the primarySwatch below to Colors.green
        // and then invoke "hot reload" (press "r" in the console where
        // you ran "flutter run", or press Run > Hot Reload App in IntelliJ).
        // Notice that the counter didn't reset back to zero -- the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: new CalculatorPage(title: 'Calculator'),
    );
  }
}

class KeypadWidgets {
  Widget undoButton;
  Widget redoButton;
  Widget swapButton;
  Widget powButton;
  Widget deleteButton;
  Widget plusMinusButton;
  Widget divideButton;
  Widget multiplyButton;
  Widget plusButton;
  Widget minusButton;
  Widget decimalPointButton;
  Widget enterButton;
  List<Widget> digitWidgets;

  KeypadWidgets() {
    buildButtons();
  }

  void send(String command) => calculatorIsolate.sendPort.send(command);

  void buildButtons() {
    undoButton = new CalcKey('Undo', () => send('UNDO'));
    redoButton = new CalcKey('Redo', () => send('REDO'));
    swapButton = new CalcKey('Swap', () => send('SWAP'));
    powButton = new CalcKey('x\u207F', () => send('POWER'));
    deleteButton = new CalcKey('Delete', () => send('DELETE'), flex: 2);
    plusMinusButton = new CalcKey('+/-', () => send('PLUSMINUS'));
    divideButton = new CalcKey('\u00F7', () => send('DIVIDE'));
    multiplyButton = new CalcKey('\u00D7', () => send('MULTIPLY'));
    plusButton = new CalcKey('+', () => send('ADD'));
    minusButton = new CalcKey('-', () => send('SUBTRACT'));
    enterButton = new CalcKey('Enter', () => send('ENTER'), flex: 2);
    decimalPointButton = new CalcKey('.', () => send('DECIMALPOINT'));
    digitWidgets = new List<CalcKey>(10);
    for (int i = 0; i < 10; i++) {
      digitWidgets[i] = new CalcKey(i.toString(), () => send('DIGIT$i'));
    }
  }
}

abstract class AbCalcKey extends StatelessWidget {
  AbCalcKey(this.text, this.onTap, {this.flex: 1, this.padding: 3.0});

  final String text;
  final GestureTapCallback onTap;
  final int flex;
  final double padding;

  void _onTap() {
    try {
      onTap();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context);
}

class RaisedButtonCalcKey extends AbCalcKey {
  RaisedButtonCalcKey(String text, GestureTapCallback onTap,
      {int flex: 1, double padding: 3.0})
      : super(text, onTap, flex: flex, padding: padding);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Flexible(
        flex: this.flex,
        child: new Container(
            constraints: new BoxConstraints(minHeight: 48.0),
            child: new Padding(
                padding: new EdgeInsets.only(right: this.padding),
                child: new RaisedButton(
                    onPressed: _onTap,
                    child: new Center(
                        child: new Text(text,
                            style: new TextStyle(
                                fontSize: (orientation == Orientation.portrait)
                                    ? 14.0
                                    : 18.0)))))));
  }
}

class CalcKey extends AbCalcKey {
  CalcKey(String text, GestureTapCallback onTap,
      {int flex: 1, double padding: 3.0})
      : super(text, onTap, flex: flex, padding: padding);

  @override
  Widget build(BuildContext context) {
    return new Flexible(
        flex: this.flex,
        child: new Container(
            decoration: new BoxDecoration(
              border: new Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            constraints: new BoxConstraints(minHeight: 56.0),
            child: new RaisedButton(
              color: Colors.indigo,
              onPressed: _onTap,
                child: new Center(
                    child: new Text(text,
                        style: new TextStyle(
                            fontSize: 18.0, color: Colors.white
                        )
                    )
                )
            )
        )
    );
  }
}

class StackDisplay extends StatelessWidget {
  String data;
  StackDisplay(this.data) : super();

  @override
  Widget build(BuildContext context) {
    return new Text(this.data, style: new TextStyle(fontSize: 24.0));
  }
}

class StackWidgets implements calc.StateListener {
  StackWidgets() {
    buildWidgets();
  }

  List<String> stackText = <String>['', '', '', '', '', '', ''];
  List<Widget> stackWidgets;
  String sandpitText = '';
  Widget sandpit;
  List<Widget> get all {
    return <Widget>[
      stackWidgets[6],
      stackWidgets[5],
      stackWidgets[4],
      stackWidgets[3],
      stackWidgets[2],
      stackWidgets[1],
      stackWidgets[0],
      sandpit
    ];
  }

  void buildWidgets() {
    stackWidgets = new List<StackDisplay>(7);
    for (int i = 0; i < 7; i++) {
      stackWidgets[i] = new StackDisplay(stackText[i]);
    }
    sandpit = new StackDisplay(sandpitText);
  }

  @override
  void update(calc.CalculatorState state) {
    sandpitText = state.sandpit;
    for (int i = 0; i < 6; i++) {
      stackText[i] = i < state.stack.length ? state.stack[i].toString() : '';
    }
    stackText[6] = (!state.isSandpit && state.stack.length > 6) ? state.stack[6].toString() : '';
  }
}

class StackWidget extends StatefulWidget implements calc.StateListener {
  StackState currentStackState;
  StackWidgets stackWidgets = new StackWidgets();
  @override
  State<StatefulWidget> createState() {
    currentStackState = new StackState(stackWidgets);
    return currentStackState;
  }

  @override
  void update(calc.CalculatorState state) {
    if (currentStackState != null) {
      currentStackState.update(state);
    }
  }
}

class StackState extends State<StackWidget> implements calc.StateListener {
  StackWidgets stackWidgets;
  StackState(this.stackWidgets) : super();

  @override
  Widget build(BuildContext context) {
    stackWidgets.buildWidgets();
    return new Container(
        padding: const EdgeInsets.all(12.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: stackWidgets.all));
  }

  @override
  void update(calc.CalculatorState state) => setState(() => stackWidgets.update(state));
}

class KeypadWidget extends StatelessWidget {
  KeypadWidgets keypadWidgets;

  KeypadWidget(this.keypadWidgets) : super();

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(12.0),
        child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                keypadWidgets.undoButton,
                keypadWidgets.swapButton,
                keypadWidgets.deleteButton
              ]),
              new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                keypadWidgets.redoButton,
                keypadWidgets.powButton,
                keypadWidgets.plusMinusButton,
                keypadWidgets.divideButton
              ]),
              new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                keypadWidgets.digitWidgets[7],
                keypadWidgets.digitWidgets[8],
                keypadWidgets.digitWidgets[9],
                keypadWidgets.multiplyButton
              ]),
              new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                keypadWidgets.digitWidgets[4],
                keypadWidgets.digitWidgets[5],
                keypadWidgets.digitWidgets[6],
                keypadWidgets.minusButton
              ]),
              new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                keypadWidgets.digitWidgets[1],
                keypadWidgets.digitWidgets[2],
                keypadWidgets.digitWidgets[3],
                keypadWidgets.plusButton
              ]),
              new Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    keypadWidgets.decimalPointButton,
                    keypadWidgets.digitWidgets[0],
                    keypadWidgets.enterButton
                  ])
            ]));
  }
}

class CalculatorPage extends StatelessWidget {
  CalculatorPage({Key key, this.title}) : super(key: key) {
    buildCalculator();
  }

  final String title;

  StackWidget stackWidget;
  KeypadWidgets keypadWidgets;
  calc.Calculator calculator;

  void buildCalculator() {
    stackWidget = new StackWidget();
    calculatorIsolate.listeners.add(stackWidget);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(title)),
        body: new Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
              new Expanded(flex: 5, child: stackWidget),
              new Expanded(
                  flex: 8, child: new KeypadWidget(new KeypadWidgets()))
            ])));
  }
}
