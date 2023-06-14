import 'package:flutter/material.dart';

typedef Widget AsyncWidgetBuilder<T>(BuildContext context, T? data);
typedef Future<T> AsyncDataFetcher<T>();

//Fabrica de FutureBuilders
class CustomFutureBuilder<T> extends StatelessWidget {
  final AsyncDataFetcher<T> future;
  final AsyncWidgetBuilder<T> builder;
  final Widget? loadingWidget;

  const CustomFutureBuilder({
    super.key, 
    required this.future,
    required this.builder,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return loadingWidget ?? const CircularProgressIndicator();
        }
      },
    );
  }
  //Modo de uso: ejemplo
  // CustomFutureBuilder<Album>(
  //   future: () => fetchAlbum(),
  //   builder: (context, album) {
  //     return Text(album.title);
  //   },
  //   loadingWidget: CircularProgressIndicator(),
  // );

}
