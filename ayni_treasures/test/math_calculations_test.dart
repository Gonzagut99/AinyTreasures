import 'package:ayni_treasures/View/components/math_calculations.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  group('MathCalculations', () {
    late MathCalculations mathCalculations;

    setUp(() {
      mathCalculations = MathCalculations();
    });

    test('roundedValueTwoDecimalsFormatting debeañadir ceros segun corresponda', () {
      // Test case 1: Un valor que en double es entero, es decir que tiene 0 como decimal se le debe añadir un '0'
      expect(mathCalculations.roundedValueTwoDecimalsFormatting('10.0'), '0');
      
      // Test case 2: valor con un solo decimal se le debe añadir un '0'
      expect(mathCalculations.roundedValueTwoDecimalsFormatting('10.5'), '0');
      
      // Test case 3: valor que cuando hay dos decimales no añade ningun cero, retorna ''
      expect(mathCalculations.roundedValueTwoDecimalsFormatting('10.55'), '');
    });

    test('convertToKilos debe convertir a kilos correctamente', () {
      expect(mathCalculations.convertToKilos('5'), '50.0');
    });

    test('convertTo50Grams debe convertir a 50 grams correctly', () {
      expect(mathCalculations.convertTo50Grams('100'), '50.0');
    });

    test('getDiscountedPrice debe calcular el precio descontado', () {
      expect(
        mathCalculations.getDiscountedPrice(totalPrice: '100', discount: '0.2'),
        '80.0',
      );
    });

    test('getDiscount debe calcular el monto de descuento', () {
      expect(
        mathCalculations.getDiscount(totalPrice: '100', discount: '0.2'),
        '20.0',
      );
    });

    test('calcActualQuantity debe calcular el valor real de la cantidad', () {
      expect(
        mathCalculations.calcActualQuantity(selectedMeasure: 'kilos', portionQuantity: '5'),
        '5 kilos',
      );
      
      expect(
        mathCalculations.calcActualQuantity(selectedMeasure: 'grams', portionQuantity: '10'),
        '500 gramos',
      );
    });

    test('calcActualProductPrice debe calcular el precio verdadero del precio del producto', () {
      expect(
        mathCalculations.calcActualProductPrice(selectedMeasure: 'kilos', productPrice: '10'),
        '100.0',
      );
      
      expect(
        mathCalculations.calcActualProductPrice(selectedMeasure: 'grams', productPrice: '20'),
        '10.0',
      );
    });
  });
}