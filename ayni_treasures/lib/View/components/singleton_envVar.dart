//Singleton
class CustomAppData {
  static final CustomAppData _appData = CustomAppData._internal();
  
  //Index-> current button ->BottomNavbar
  int singletonIndex = 0;
  //current user logged usuario actual logeado
  String? currentUserId = '';

  factory CustomAppData() {
    return _appData;
  }
  CustomAppData._internal();
}

final appData = CustomAppData();
