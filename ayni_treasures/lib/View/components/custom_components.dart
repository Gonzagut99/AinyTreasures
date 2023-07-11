import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../styles.dart';
import '../assets.dart';

class CustomComponents {
  static void callbackNav ({required BuildContext context,required String route}){
      Navigator.pop(context); 
      Navigator.of(context).pushNamed(route);
    }
    //Sin pop para eliminar el contexto anterior, se usa cunando la appbar es simple por lo general
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
          IconButton(onPressed: ()=>{callbackNavSimple(context: context,route: '/cart')}, icon:cartIcon),
          IconButton(onPressed: ()=>{callbackNavSimple(context: context,route: '/profile')}, icon:userButtonIcon),
        ],
      );
    }
    return AppBar(
      title: Text(titleAppBar),
      actions: <Widget>[
          IconButton(onPressed: ()=>{callbackNavSimple(context: context,route: '/cart')}, icon:cartIcon),
          IconButton(onPressed: ()=>{callbackNavSimple(context: context,route: '/profile')}, icon:userButtonIcon),
        ],
    );
  }
  //Appbar simple que solo tiene el botòn de back
  static PreferredSizeWidget makeSimpleAppbar ({required BuildContext context, String? title, Color? color, Color? colorLeadingIcon}){
    return AppBar(
      leading: BackButton(color: colorLeadingIcon ?? customPrimary,),
      title: title!=null?Text(title):const Text(''),
      backgroundColor: color ?? customBackground,
      elevation: color==null?0:10,
    );
  }
  //Crea textos de diferentes clases
  static Text makeText({required String headingType, required String data, required Color color, TextAlign? textAlign, TextOverflow? textOverflowType, bool? softWrap, int? maxLines}){
    switch (headingType) {
      case 'H1':
        return Text(
          data, 
          style: returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_1'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'H2':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_2'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'H3':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_3'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'H4':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_4'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'H5':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_5'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'H6':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'heading_6'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'P1':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraph_1'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'P2':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraph_2'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'P3':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraph_3'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'PR2':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraphReg_2'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
        );
      case 'PR3':
        return Text(
          data,
          style:returnTextType(color: color,textType: customFontSizeWeight,textTypeStr: 'paragraphReg_3'),
          textAlign: textAlign,
          overflow: textOverflowType,
          softWrap: softWrap,
          maxLines: maxLines,
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
  static InkWell makeGeneralCard({String? title, String? subtitle, String? description, double? width=174, String? price, String? label, Function? callback, required String imageUrl, required double height}){
    if (title != null) {
      return InkWell(
        onTap: callback!=null?callback():()=>{},
        splashColor: customDarkGray,
        child: Ink(
          color: customBackground,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                //color: customTernary,
                color: Colors.black,
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                  image: NetworkImage(imageUrl), 
                  fit: BoxFit.cover),   
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
          ),
        ),
      );
    }else if(subtitle!= null&&description!=null){
      return InkWell(
        onTap:callback!=null?callback():()=>{},
        splashColor: customDarkGray,
        child: Ink(
          color: customBackground,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: customBlack,
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                  image: NetworkImage(imageUrl), 
                  fit: BoxFit.cover),
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
          ),
        ),
      );
    }else if(subtitle!= null&&price!=null){
      return InkWell(
        onTap: callback!=null?callback():()=>{},
        splashColor: customDarkGray,
        child: Ink(
          color: customBackground,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                  image: NetworkImage(imageUrl), 
                  fit: BoxFit.cover),
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
          ),
        ),
      );
    }else{
      return const InkWell(child: Card());
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
          color: Colors.black,

          image: DecorationImage(
            image: NetworkImage(imageUrl), 
            fit: BoxFit.cover, 
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),),
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
  static ElevatedButton makeButtonWithIcon({required Color btnColor, required Function callback, required String content,required Widget iconParam, String? size}){
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
        return ElevatedButton.icon(
          icon: iconParam,    
          onPressed: ()=>{callback()},
          style: buttonStyle,
          label: makeText(headingType: 'P1', data: content, color: colorText, textAlign: TextAlign.center),
        ) ;
      case 'Small':        
        return ElevatedButton.icon(   
          icon: iconParam,         
          onPressed: ()=>{callback()},
          style: buttonStyle,
          label: makeText(headingType: 'P3', data: content, color: colorText, textAlign: TextAlign.center),
        ) ;
      default:
        return ElevatedButton.icon(
          icon: iconParam,    
          onPressed: ()=>{callback()},
          style: buttonStyle,
          label: makeText(headingType: 'P2', data: content, color: colorText, textAlign: TextAlign.center),
        );
    }
    
  }
  static SimpleDialog makeSimpleDialog({required BuildContext context, String? title, String? content, }){
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
        ),
      ]   
    );
  }

  static SimpleDialog makeSimpleDialogWithButtons({required BuildContext context, required String title,required String content, required Function callbackFn, required String mainBtnContent}){
    return SimpleDialog(
      //title: makeText(headingType: 'H4', data: title!, color: customPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: customWhite,
      contentPadding: const EdgeInsets.all(24),
      // title: makeText(headingType: 'H4', data: title!, color: customSecondary, textAlign: TextAlign.center),
      // titlePadding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      children: [
        Container(child:makeText(headingType: 'H4', data: title, color: customSecondary, textAlign: TextAlign.center) ,),
        const SizedBox(height:8),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Center(
              child: makeText(headingType: 'P2', data: content, color: customPrimary),
          ),
          
        ),
        const SizedBox(height:12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: (){Navigator.of(context).pop();}, 
              child: CustomComponents.makeText(headingType: 'H5', data: 'Cerrar', color: customPrimary)),
            CustomComponents.makeButton(
              btnColor: customSecondary, 
              callback: callbackFn, 
              content: mainBtnContent,
              size: 'Big')
          ],
        )
      ]   
    );
  }

  static SimpleDialog makeSimpleDialogWithCloseButton({required BuildContext context, String? title, String? content, }){
    return SimpleDialog(
      //title: makeText(headingType: 'H4', data: title!, color: customPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: customWhite,
      contentPadding: const EdgeInsets.all(24),
      children: [
        Container(child:makeText(headingType: 'H4', data: title!, color: customSecondary, textAlign: TextAlign.center) ,),
        const SizedBox(height:8),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Center(
              child: makeText(headingType: 'P2', data: content!, color: customPrimary),
          ),
        ),
        const SizedBox(height:12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: (){Navigator.of(context).pop();}, 
              child: CustomComponents.makeText(headingType: 'H5', data: 'Cerrar', color: customPrimary)),
          ],
        )
      ]   
    );
  }
}

