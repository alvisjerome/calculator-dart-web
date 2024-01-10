import 'dart:html';
import 'package:math_expressions/math_expressions.dart';

void main() {
  final displayEl = querySelector('#display') as InputElement;
  final allButtons = querySelectorAll("button[type='button']");

  for (final button in allButtons) {
    button.onClick
        .listen((event) => eventHandler(btn: button, dpEl: displayEl));
  }
}

void eventHandler({required Element btn, required InputElement dpEl}) {
  if (btn.text == '.' &&
      (dpEl.value?[dpEl.value!.length - 1].contains('.') ?? false)) {
    return;
  }
  if (btn.text == 'AC') {
    dpEl.value = '0';
  } else if (btn.text?.trim().isNotEmpty ?? false) {
    dpEl.value = dpEl.value == '0'
        ? dpEl.value = btn.text
        : (dpEl.value ?? '') + (btn.text ?? "");
  } else {
    final regex = RegExp(r'[%÷x\-+.]$');
    final rule = (dpEl.value ?? '').contains(regex);
    final id = btn.id;

    void operations(String value) {
      if (rule) {
        dpEl.value = replaceLastChar(str: (dpEl.value ?? ''), newChar: value);
      } else {
        dpEl.value = "${dpEl.value}$value";
      }
    }

    if (id == Operators.backspace.name) {
      dpEl.value = removeLastChar(dpEl.value ?? '');
    } else if (id == Operators.percent.name) {
      operations(Operators.percent.value);
    } else if (id == Operators.divide.name) {
      operations(Operators.divide.value);
    } else if (id == Operators.multiply.name) {
      operations(Operators.multiply.value);
    } else if (id == Operators.subtract.name) {
      operations(Operators.subtract.value);
    } else if (id == Operators.add.name) {
      operations(Operators.add.value);
    } else if (id == Operators.equals.name) {
      if (dpEl.value![dpEl.value!.length - 1].contains(regex)) {
        dpEl.value = removeLastChar(dpEl.value ?? '');
      }
      dpEl.value = calculate(dpEl.value ?? '');
    }
  }
}

String removeLastChar(String str) {
  if (str.isNotEmpty && str.length > 1) {
    return str.substring(0, str.length - 1);
  } else if (str.length == 1) {
    return '0';
  }
  return str;
}

String replaceLastChar({required String str, required String newChar}) {
  if (str.isEmpty) return str;
  return str.replaceRange(str.length - 1, str.length, newChar);
}

String calculate(String expression) {
  if (expression.contains(Operators.divide.value)) {
    expression = expression.replaceAll(Operators.divide.value, '/');
  }
  if (expression.contains(Operators.multiply.value)) {
    expression = expression.replaceAll(Operators.multiply.value, '*');
  }

  try {
    final p = Parser();
    final exp = p.parse(expression);
    final cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    return "$eval";
  } catch (e) {
    window.alert('$e');
    return "0";
  }
}

enum Operators {
  backspace('backspace'),
  percent('%'),
  divide('÷'),
  multiply('x'),
  subtract('-'),
  add('+'),
  equals('=');

  const Operators(this.value);
  final String value;
}
