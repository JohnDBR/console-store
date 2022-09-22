import 'dart:io';

class ConsoleHelper {
  static int getIntSafely({int stack = 0, int deft = -1}) {
    String stack_string = String.fromCharCodes(
        Iterable.generate(stack * 2, (_) => ' '.codeUnits.first));
    try {
      return int.parse(stdin.readLineSync().toString());
    } catch (StandardError) {
      print('${stack_string}Wrong!');
    }
    return deft;
  }

  static double getDoubleSafely({int stack = 0, double deft = -1}) {
    String stack_string = String.fromCharCodes(
        Iterable.generate(stack * 2, (_) => ' '.codeUnits.first));
    try {
      return double.parse(stdin.readLineSync().toString());
    } catch (StandardError) {
      print('${stack_string}Wrong!');
    }
    return deft;
  }

  static String getStringSafely({int stack = 0, String deft = ''}) {
    String stack_string = String.fromCharCodes(
        Iterable.generate(stack * 2, (_) => ' '.codeUnits.first));
    try {
      return stdin.readLineSync().toString();
    } catch (StandardError) {
      print('${stack_string}Wrong!');
    }
    return deft;
  }
}
