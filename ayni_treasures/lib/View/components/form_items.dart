import 'package:ayni_treasures/View/components/custom_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../styles.dart';
import '../assets.dart';

class FormItems {
  static SizedBox makeInputItem({required String label, required Function cbOnSaved, required Function cbValidator, required TextInputType inputType, String? hintText, double? width, TextAlign? labelAlign, List<TextInputFormatter>? inputFormatters}) {
  //el label se alinea automaticamente al centro
  final TextAlign deafultAlign = (labelAlign==null)?TextAlign.center:labelAlign; 
  return SizedBox(
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //label
        SizedBox(
          width: double.infinity,
          child: CustomComponents.makeText(headingType: 'H6', data: label, color: customPrimary, textAlign: deafultAlign),
        ),        
        const SizedBox(height: 12),
        //input field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: customInputGray
          ),
          padding:const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none
            ),
            onSaved: (newValue){
              cbOnSaved(newValue);
            },
            validator: (newValue){
              return cbValidator(newValue);
            },
            keyboardType: inputType,
            inputFormatters: inputFormatters,
          ),
        ),
        const SizedBox(height: 18),
      ],
    ),
  );
}
}
