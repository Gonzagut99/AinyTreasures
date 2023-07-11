import 'package:ayni_treasures/View/components/custom_components.dart';
import 'package:ayni_treasures/View/styles.dart';
import 'package:flutter/material.dart';

class NumbersGridWidget {
  Widget buildDetailsGrid<T>({
    required BuildContext context,
    required int columns,
    required double horizontalSpace,
    required double verticalSpace,
    required List<T> list,
    required Function callbackWidget
    // required String textDetailSize,
    // required String textLabelSize,
    // required double detailHeight
  }) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns, // Número de columnas en el grid
              crossAxisSpacing: horizontalSpace, // Espacio horizontal entre los elementos
              mainAxisSpacing: verticalSpace, // Espacio vertical entre los elementos
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final item = list[index];
                return makePersonalizedWidget(callbackWidget(item));},
              childCount: list.length,
            ),
          ),
        ],
      ),
    );
  }
  Widget makePersonalizedWidget (Function widget){
    return widget();
  }

  Widget buildDetailColumn ({required String textDetailSizeType, required String textLabelSizeType, required String textDetail, required String textLabel, required double height}){
    return SizedBox(
      height: height,
      child: Column(
        children: [
          CustomComponents.makeText(headingType: textDetailSizeType, data: textDetail, color: customBlack),
          const SizedBox(height: 8,),
          CustomComponents.makeText(headingType: textLabelSizeType, data: textLabel, color: customDarkGray)
        ],
      ),
    );
  }

  
  // static Widget buildCardsGrid(BuildContext context, ){

  // }
}
