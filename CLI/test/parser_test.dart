
import 'package:rpccli/cli.dart' as cli;
import 'package:test/test.dart';

void parser_tests() {
  group('When I instantiate a parser', () {
    var parser;
    group('and give the constructor a string argument', () {
      setUp(() => parser = new cli.CliParser('a string'));
      test('then the parser is correctly constructed',
          () => expect(parser, const TypeMatcher<cli.Parser>()));
    });
  });

  group('Given a parser with several numbers as input,', () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("3 2 4"));
    group("when I get the tokens' iterator", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator);
      group('and I get the first element of the iterable', () {
        cli.Token token;
        setUp(() => token = (tokens..moveNext()).current);
        test('then I am returned a NUMBER token',
            () => expect(token.type, equals(cli.TokenType.NUMBER)));
        test('then I am returned a token with value 3',
            () => expect(token.value, equals('3')));
        group('and I get the next token', () {
          cli.Token token;
          setUp(() => token = (tokens..moveNext()).current);
          test('then I am returned a token with value 2',
              () => expect(token.value, equals('2')));
        });
      });
    });
  });

  group('When I create a parser with a number and a plus', () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("3 +"));
    group("when I get the tokens' iterator and take the second element", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator..moveNext()..moveNext());
      test('then that second element is a plus',
          () => expect(tokens.current.type, equals(cli.TokenType.PLUS)));
    });
  });

  group('When I create a parser with a minus', () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("-"));
    group("when I get the tokens' iterator", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator..moveNext());
      test('then the first element is a minus',
          () => expect(tokens.current.type, equals(cli.TokenType.MINUS)));
    });
  });

  group('When I create a parser with a multiply', () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("*"));
    group("when I get the tokens' iterator", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator..moveNext());
      test('then the first element is a multiply',
          () => expect(tokens.current.type, equals(cli.TokenType.MULTIPLY)));
    });
  });

  group('When I create a parser with a divide', () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("/"));
    group("when I get the tokens' iterator", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator..moveNext());
      test('then the first element is a divide',
          () => expect(tokens.current.type, equals(cli.TokenType.DIVIDE)));
    });
  });

  group(
      'When I create a parser with a carat, the string "pow", the string "exp" and the string "power"',
      () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("^ pow power exp"));
    group("when I get the tokens' iterator", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator..moveNext());
      test('then the first element is a power',
          () => expect(tokens.current.type, equals(cli.TokenType.POWER)));
      test('then the second element is a power', () {
        tokens.moveNext();
        expect(tokens.current.type, equals(cli.TokenType.POWER));
      });
      test('then the third element is a power', () {
        tokens..moveNext()..moveNext();
        expect(tokens.current.type, equals(cli.TokenType.POWER));
      });
      test('then the fourth element is a power', () {
        tokens..moveNext()..moveNext()..moveNext();
        expect(tokens.current.type, equals(cli.TokenType.POWER));
      });
    });
  });

  group('When I create a parser with a floating point number', () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("1.4"));
    group("when I get the tokens' iterator", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator..moveNext());
      test('then the first element is a number', () => expect(tokens.current.type, equals(cli.TokenType.NUMBER)));
      test('then the first element has the correct value', () => expect(tokens.current.value, equals("1.4")));
    });
  });

  group('When I create a parser with a number with two decimal points', () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("1.4.3"));
    group("when I get the tokens' iterator", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator..moveNext());
      test('then the first element is not recognized', () => expect(tokens.current.type, equals(cli.TokenType.UNKNOWN)));
    });
  });

  group('When I create a parser with a negative number', () {
    cli.Parser parser;
    setUp(() => parser = new cli.CliParser("-4"));
    group("when I get the tokens' iterator", () {
      Iterator tokens;
      setUp(() => tokens = parser.tokens.iterator..moveNext());
      test('then the first element is a number', () => expect(tokens.current.type, equals(cli.TokenType.NUMBER)));
      test('then the first element has the correct value', () => expect(tokens.current.value, equals("-4")));
    });
  });



}
