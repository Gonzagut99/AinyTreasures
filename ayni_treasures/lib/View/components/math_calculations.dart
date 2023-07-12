import 'dart:math';
class MathCalculations {
  //cuando no hay ningun digito decimal
  bool _hasDecimal(double value) {
    return (value - value.toInt()) != 0;
  }
  //cuando hay un solo decimal
  bool _hasOneDecimal(double value) {
    String valueString = value.toString();
    int decimalIndex = valueString.indexOf('.');
    if (decimalIndex == -1) {
      return false;
    }
    String decimalPart = valueString.substring(decimalIndex + 1);
    return decimalPart.length == 1;
  }
  //cuando hay dos decimales
  bool _hasTwoDecimals(double value) {
    String valueString = value.toString();
    int decimalIndex = valueString.indexOf('.');
    if (decimalIndex == -1) {
      return false;
    }
    String decimalPart = valueString.substring(decimalIndex + 1);
    return decimalPart.length == 2;
  }

  //cuando hay más de dos decimales
  double _roundUpAboveThreeDecimals(double value) {
    double roundedValue;
    String decimalPart = value.toStringAsFixed(3).split('.').last;
    String lastnNumber = decimalPart.substring(decimalPart.length - 1);
    int thirdDecimal = int.parse(lastnNumber);
    
    if (thirdDecimal >= 5) {
      roundedValue = double.parse((value + 0.01).toStringAsFixed(2)); // Round up
    } else {
      roundedValue = double.parse(value.toStringAsFixed(2)); // Round down
    }
    return roundedValue;
  }


  //Funcion que retorna un string resultado del redondeo sin importar el numero de decimales
  //solo funciona asi en esta version flutter
  String roundedValueTwoDecimals (double value){
    if (_hasDecimal(value)) {
      if (_hasOneDecimal(value)) {
        return value.toString();
      } else if(_hasTwoDecimals(value)){
        return value.toString();
      } else{
        return _roundUpAboveThreeDecimals(value).toString();
      }
    }else{
      return value.toString();
    }
  }

  //solo funciona asi en esta version flutter
  String roundedValueTwoDecimalsFormatting (String valueStr){
    double value = double.parse(valueStr);
    if (_hasDecimal(value)) {
      if (_hasOneDecimal(value)) {
        return '0';
      } else if(_hasTwoDecimals(value)){
        return '';
      } else{
        return '';
      }
    }else{
      return '0';
    }
  }

  //convertir a kilos
  String convertToKilos(String value){
    return ((double.parse(value))*10).toString();
  }

  //convertir a 50 gr
  String convertTo50Grams(String value){
    return ((double.parse(value))/2).toString();
  }

  String getDiscountedPrice({required String totalPrice, required String discount}){
    final doubleTotalPrice = double.parse(totalPrice);
    //final doubleDiscount = double.parse(discount);
    final discountedprice = doubleTotalPrice-(double.parse(getDiscount(totalPrice:totalPrice, discount: discount)));
    
    return roundedValueTwoDecimals(discountedprice);
  }
  String getDiscount({required String totalPrice, required String discount}){
    final doubleTotalPrice = double.parse(totalPrice);
    final doubleDiscount = double.parse(discount);
    final totalDiscount = doubleTotalPrice*doubleDiscount;
    return roundedValueTwoDecimals(totalDiscount);
  }

  //calcula la cantidad real en kilos o gramos
  String calcActualQuantity({required String selectedMeasure, required String portionQuantity}){
    if (selectedMeasure=='kilos') {
      return '$portionQuantity kilos';
    } else {
      int totalgrams = int.parse(portionQuantity)*50;
      return '$totalgrams gramos';
    }
  }

  String calcActualProductPrice({required String selectedMeasure, required String productPrice}){
    double doubleProductPrice = double.parse(productPrice);
    if (selectedMeasure == 'kilos') {
      doubleProductPrice*=10;
      final rounded = MathCalculations().roundedValueTwoDecimals(doubleProductPrice);
      return rounded;
    } else {
      doubleProductPrice/=2;
      final rounded = MathCalculations().roundedValueTwoDecimals(doubleProductPrice);
      return rounded;
    }
  }
}
