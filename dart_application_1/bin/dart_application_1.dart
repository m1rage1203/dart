import 'dart:io';
import 'dart:math';

void main() {
  print('Введите первое число:');
  double num1 = double.parse(stdin.readLineSync()!);
  
  print('Введите операцию (+, -, *, /, ~/, %, pow, ==, !=, >, <, >=, <=, &&(оба числа четные), ||(хотя бы одно число четное), !(второе число положительное)):');
  String operation = stdin.readLineSync()!;
  
  print('Введите второе число:');
  double num2 = double.parse(stdin.readLineSync()!);
  
  if (operation == '+') {
    print('Результат: ${num1 + num2}');
  } else if (operation == '-') {
    print('Результат: ${num1 - num2}');
  } else if (operation == '*') {
    print('Результат: ${num1 * num2}');
  } else if (operation == '/') {
    print('Результат: ${num1 / num2}');
  } else if (operation == '~/') {
    print('Результат: ${num1 ~/ num2}');
  } else if (operation == '%') {
    print('Результат: ${num1 % num2}');
  } else if (operation == 'pow') {
    print('Результат: ${pow(num1, num2)}');
  }
  
  else if (operation == '==') {
    print('Результат: ${num1 == num2}');
  } else if (operation == '!=') {
    print('Результат: ${num1 != num2}');
  } else if (operation == '>') {
    print('Результат: ${num1 > num2}');
  } else if (operation == '<') {
    print('Результат: ${num1 < num2}');
  } else if (operation == '>=') {
    print('Результат: ${num1 >= num2}');
  } else if (operation == '<=') {
    print('Результат: ${num1 <= num2}');
  }
  

  else if (operation == '&&') { 
    bool isEven1 = num1 % 2 == 0;
    bool isEven2 = num2 % 2 == 0;
    bool result = isEven1 && isEven2;
    print('Результат: $result');
  } else if (operation == '||') { 
    bool isEven1 = num1 % 2 == 0;
    bool isEven2 = num2 % 2 == 0;
    bool result = isEven1 || isEven2;
    print('Результат: $result');
  } else if (operation == '!') {
    bool isNegative = num2 < 0;
    bool result = !isNegative;  
    print('Результат: $result');
  } else {
    print('Неизвестная операция');
  }
}