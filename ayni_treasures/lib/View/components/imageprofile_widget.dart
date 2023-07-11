import 'package:ayni_treasures/View/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import '../assets.dart';

class ImageProfileWidget extends StatelessWidget {

  final String imagePath;
  final ValueChanged<ImageSource> onClicked;

  const ImageProfileWidget({
    super.key,
    required this.imagePath,
    required this.onClicked,    
    });

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Stack(
        children: [
          buildImage(context),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(customPrimary)
          )
        ]
      ),
    );
  }

  //Construye la imagen de fondo del circulo
  Widget buildImage(BuildContext context){
    //const AssetImage('assets/images/genericuser_asset.jpg')
    final ImageProvider<Object> image;
    if ((imagePath.startsWith("https://"))) {
      image = NetworkImage(imagePath);
    } else {
      image = AssetImage(imagePath);
    }

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit:BoxFit.cover,
          width: 128,
          height:128,
          child: InkWell(
            onTap: ()async{
              //capturamos la opcion escogida por el usuario
              final source = await showImageSourceMenu (context);
              //enviamos el resultado, ya sea camara o galería
              if (source == null) return;
              onClicked(source);
            },
            )    
        ),
      ),
    );
  }

  //Crea el icono de edicion
  Widget buildEditIcon(Color color)=> 
    buildCircle(
      color: customWhite,
      paddingAll: 3,
      child: buildCircle(
        color: customPrimary,
        paddingAll: 8,
        child: const Icon(
          Icons.edit,
          color: customWhite,
          size:20,
        ),
      ),
    );

  //Crea el circulo alrededor del icono de edicion
  Widget buildCircle({
    required Widget child,
    required double paddingAll,
    required Color color
  }) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(paddingAll),
        color: color,
        child: child,
      ),
    );
  
  //Muestra menu popup
  Future<ImageSource?> showImageSourceMenu(BuildContext context) async{
    return showModalBottomSheet(
      context: context, 
      builder: (context)=> Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Cámara'),
            onTap: ()=> Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Galería'),
            onTap: ()=> Navigator.of(context).pop(ImageSource.gallery),
          )
        ],));
  }
}