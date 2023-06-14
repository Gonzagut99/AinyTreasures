import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../styles.dart';
import '../assets.dart';

class CustomComponents {
  static void callbackNav ({required BuildContext context,required String route}){
      Navigator.pop(context); 
      Navigator.of(context).pushNamed(route);
    }
  static void callbackNavSimple ({dynamic arguments, required BuildContext context,required String route}){
      if (arguments !=null) {
        Navigator.of(context).pushNamed(route,arguments:arguments);
      }else{Navigator.of(context).pushNamed(route);}      
    }
  static PreferredSizeWidget makeAppbar ({Color? color, required String titleAppBar, required BuildContext context}){
    if(color!=null){
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(titleAppBar),
        actions: <Widget>[
          IconButton(onPressed: ()=>{}, icon:cartIcon),
          IconButton(onPressed: ()=>{callbackNavSimple(context: context,route: '/login')}, icon:userButtonIcon),
        ],
      );
    }
    return AppBar(
      title: Text(titleAppBar),
      actions: <Widget>[
          IconButton(onPressed: ()=>{}, icon:cartIcon),
          IconButton(onPressed: ()=>{callbackNavSimple(context: context,route: '/login')}, icon:userButtonIcon),
        ],
    );
  }
  static Text makeText({required String headingType, required String data, required Color color, TextAlign? textAlign }){
    switch (headingType) {
      case 'H1':
        return Text(
          data, 
          style: returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_1'),
          textAlign: textAlign,
        );
      case 'H2':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_2'),
          textAlign: textAlign,
        );
      case 'H3':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_3'),
          textAlign: textAlign,
        );
      case 'H4':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_4'),
          textAlign: textAlign,
        );
      case 'H5':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_5'),
          textAlign: textAlign,
        );
      case 'H6':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_6'),
          textAlign: textAlign,
        );
      case 'P1':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraph_1'),
          textAlign: textAlign,
        );
      case 'P2':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraph_2'),
          textAlign: textAlign,
        );
      case 'P3':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraph_3'),
          textAlign: textAlign,
        );
      case 'PR2':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraphReg_2'),
          textAlign: textAlign,
        );
      case 'PR3':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraphReg_3'),
          textAlign: textAlign,
        );
      default:
        return const Text('');
    }
  }
  static TextStyle returnTextType({required Color color,required Map textType, required String textTypeStr}){
    return TextStyle(
      fontSize: textType[textTypeStr][0],
      color: color,
      fontWeight: textType[textTypeStr][1],
    );
  }
  static Row categoryTitle({required String subtitle}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        makeText(headingType: 'H5', data: subtitle, color: customPrimary),
        makeText(headingType: 'P3', data: 'Ver más', color: customDarkGray)
      ],
    );
  }
  static Card makeGeneralCard({String? title, String? subtitle, String? description, double? width=174, String? price, String? label, required String imageUrl, required double height}){
    if (title != null) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            //color: customTernary,
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),   
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: makeText(headingType: 'H4',color: customBackground, data: title)
                ),              
              ]
            ),
          ),
        ),
      );
    }else if(subtitle!= null&&description!=null){
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        makeText(headingType: 'H6', data: subtitle, color: customBackground),
                        makeText(headingType: 'P3', data: description, color: customBackground),
                      ],
                    )
                  ],
                )
              ]
            ),
          ),
        ),
      );
    }else if(subtitle!= null&&price!=null){
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            makeText(headingType: 'H4', data: subtitle, color: customBackground),
                          ],
                        ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            makeText(headingType: 'H6', data: "Precio: ", color: customBackground),
                            makeText(headingType: 'H5', data: price, color: customBackground)
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ]
            ),
          ),
        ),
      );
    }else{
      return const Card();
    }
    
  }
  static Card makeCardTile({Color? colorText=customBackground, required String title,  required String imageUrl}){
    // if (function!= null) {
    //   return Card(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12)
    //     ),
    //   child: GestureDetector(
    //     onTap: function(),
    //     child: Container(
    //       width: double.infinity,
    //       height: 120,
    //       decoration: BoxDecoration(
    //           image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //       child: Center(child: Row(
    //         children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 16),child:Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [CustomComponents.makeText(headingType: 'H2', data: title, color: colorText!)],
    //         ) ,)],)),
    //     )
    //   ),
      
    // );
    // }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Row(
          children: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [CustomComponents.makeText(headingType: 'H2', data: title, color: colorText!)],
            ) ,)],)),
        )      
    );
  }
  static Widget makeInfoCard({required String title, required String description, required double height, required Color backgroundColor}){
    return Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            /*image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),*/
            borderRadius: BorderRadius.circular(12),
            color: customTernary
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,6,20,6),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    CustomComponents.makeText(headingType:'H6', data: title, color: customPrimary),
                  ]
                  
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 180,
                          child: makeText(headingType: 'P3', data: description, color: customPrimary),)

                      ],
                    )
                  ],
                )
              ]
            ),
          ),
        ); 
  }
  static ElevatedButton makeButton({required Color btnColor, required Function callback, required String content, String? size}){
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
      backgroundColor: btnColor,
      padding: const EdgeInsets.fromLTRB(20,10,20,10),
      //padding: const EdgeInsets.all(20),
    );
    final Color colorText = (btnColor!=customWhite)?customBackground:customPrimary;
    switch (size) {
      case 'Big':        
        return ElevatedButton(        
          onPressed: ()=>{callback()},
          style: buttonStyle,
          child: Center(
            child: makeText(headingType: 'P1', data: content, color: colorText, textAlign: TextAlign.center),
          ),
        ) ;
      case 'Small':        
        return ElevatedButton(        
          onPressed: ()=>{callback()},
          style: buttonStyle,
          child: Center(
            child: makeText(headingType: 'P3', data: content, color: colorText, textAlign: TextAlign.center),
          ),
        ) ;
      default:
        return ElevatedButton(
          onPressed: ()=>{callback()},
          style: buttonStyle,
          child: Center(
            child: makeText(headingType: 'P2', data: content, color: colorText, textAlign: TextAlign.center),
          ),
        );
    }
    
  }
  static SimpleDialog makeSimpleDialog({required BuildContext context, String? title, String? content}){
    return SimpleDialog(
      //title: makeText(headingType: 'H4', data: title!, color: customPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: customWhite,
      contentPadding: const EdgeInsets.all(24),
      title: makeText(headingType: 'H4', data: title!, color: customSecondary, textAlign: TextAlign.center),
      titlePadding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      children: [
         Padding(
          padding: const EdgeInsets.all(0),
          child: Center(
              child: makeText(headingType: 'P2', data: content!, color: customPrimary),
          ),
        )
      ]   
    );
  }

}

