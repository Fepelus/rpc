import 'package:rpccli/cli.dart' as cli;
import 'package:calculator/calculator.dart' as calc;
import 'dart:io';

main(List<String> arguments) {
  String input = stdin.readLineSync();
  cli.Parser parser;
  try {
    parser = new cli.CliParser(input);
  } catch (e) {
    print("$e\nPermitted operators: + - * / ^");
    exit(2);
  }
  cli.CliListener listener = new cli.CliListener();
  calc.Calculator calculator = new calc.StackCalculator(listener);
  try {
    parser.tokens.forEach((token) => token.execute(calculator));
  } catch (e) {
    print("$e");
    exit(2);
  }
  print(listener.stackhead);
}

