import 'package:flutter/material.dart';
import 'package:calculator/calculator.dart' as calc;

void main() {
  runApp(new MyApp());
}

calc.Calculator calculator;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'RPC',
      theme: new ThemeData(primarySwatch: Colors.indigo),
      home: new CalculatorPage(title: 'Calculator', stackWidget: new StackWidget())
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

  void buildButtons() {
    undoButton = new CalcKey('Undo', () => calculator.undo());
    redoButton = new CalcKey('Redo', () => calculator.redo());
    swapButton = new CalcKey('Swap', () => calculator.swap());
    powButton = new CalcKey('x\u207F', () => calculator.power());
    deleteButton = new CalcKey('Delete', () => calculator.delete(), flex: 2);
    plusMinusButton = new CalcKey('+/-', () => calculator.plusMinus());
    divideButton = new CalcKey('\u00F7', () => calculator.divide());
    multiplyButton = new CalcKey('\u00D7', () => calculator.multiply());
    plusButton = new CalcKey('+', () => calculator.add());
    minusButton = new CalcKey('-', () => calculator.subtract());
    enterButton = new CalcKey('Enter', () => calculator.enter(), flex: 2);
    decimalPointButton = new CalcKey('.', () => calculator.decimalPoint());
    digitWidgets = new List<CalcKey>(10);
    for (int i = 0; i < 10; i++) {
      digitWidgets[i] = new CalcKey(i.toString(), () => calculator.digit(i));
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

  @override Widget build(BuildContext context);
}

class RaisedButtonCalcKey extends AbCalcKey {
  RaisedButtonCalcKey(String text, GestureTapCallback onTap,
      {int flex: 1, double padding: 3.0})
      : super(text, onTap, flex: flex, padding: padding);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Flexible(
        flex: flex,
        child: new Container(
            constraints: const BoxConstraints(minHeight: 48.0),
            child: new Padding(
                padding: new EdgeInsets.only(right: padding),
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
        flex: flex,
        child: new Container(
            decoration: new BoxDecoration(
              border: new Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            constraints: const BoxConstraints(minHeight: 56.0),
            child: new RaisedButton(
              color: Colors.indigo,
              onPressed: _onTap,
                child: new Center(
                    child: new Text(text,
                        style: const TextStyle(
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
  final String data;
  StackDisplay(this.data) : super();

  @override Widget build(BuildContext context) {
    return new Text(data, style: const TextStyle(fontSize: 22.0));
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
  final StackWidgets stackWidgets = new StackWidgets();
  @override State<StatefulWidget> createState() {
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

  @override Widget build(BuildContext context) {
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
  final KeypadWidgets keypadWidgets;

  KeypadWidget(this.keypadWidgets) : super();

  @override Widget build(BuildContext context) {
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
  CalculatorPage({Key key, this.title, this.stackWidget}) : super(key: key) {
    buildCalculator();
  }

  final String title;
  final StackWidget stackWidget;

  void buildCalculator() {
    calculator = new calc.StackCalculator(stackWidget);
  }

  @override Widget build(BuildContext context) {
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
