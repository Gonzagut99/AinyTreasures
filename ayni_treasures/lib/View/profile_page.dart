import 'package:ayni_treasures/Controller/user_preferences.dart';
import 'package:ayni_treasures/View/components/custom_components.dart';
import 'package:ayni_treasures/View/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../Entity/user_entity.dart';
import 'components/imageprofile_widget.dart';
import 'components/singleton_envVar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = UserPreferences.setMyUser(appData.currentUserId);
    return Scaffold(
      appBar: CustomComponents.makeSimpleAppbar(context:context,title: 'Perfil de Usuario'),
      body: FutureBuilder<User>(
        future: UserPreferences.setMyUser(appData.currentUserId),
        builder: (context, currentUser) {
          if (currentUser.hasData) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ImageProfileWidget(
                  imagePath: currentUser.data!.profileimage,
                  onClicked: (imagesource) async{},
                ),
                const SizedBox(height: 24,),
                buildName(currentUser.data),
                const SizedBox(height: 24,),
                userDetails(currentUser.data),
                const SizedBox(height: 24,),
                buildMoreDetails(currentUser.data),
                const SizedBox(height: 24,)
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  Widget buildName(User? user)=>
  Column(
    children: [
      CustomComponents.makeText(
        headingType: 'H5', 
        data: "${user!.username} ${user.lastname}", 
        color: customBlack),
      const SizedBox(height: 16,),
      CustomComponents.makeText(
        headingType: 'PR2', 
        data: user.email, 
        color: customDarkGray),
      const SizedBox(height: 16,),
    ],
  );

  Widget userDetails(User? user)=>
    IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomComponents.makeText(headingType: 'H6', data: user!.region, color: customBlack,softWrap: true, maxLines: 2),
                const SizedBox(height: 4,),
                CustomComponents.makeText(headingType: 'P3', data: 'Departamento', color: customDarkGray)
              ],
            ),
          ),
          buildDivider(),
          SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomComponents.makeText(headingType: 'H6', data: user.province, color: customBlack,softWrap: true, maxLines: 2),
                const SizedBox(height: 4,),
                CustomComponents.makeText(headingType: 'P3', data: 'Provincia', color: customDarkGray)
              ],
            ),
          ),
          buildDivider(),
          SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomComponents.makeText(headingType: 'H6', data: user.district, color: customBlack,softWrap: true, maxLines: 2),
                const SizedBox(height: 4,),
                CustomComponents.makeText(headingType: 'P3', data: 'Distrito', color: customDarkGray)
              ],
            ),
          ),
        ],
      ),
    );

  Widget buildDivider()=> const SizedBox(height: 36,child: VerticalDivider());

  Widget buildMoreDetails(User? user)=> Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 36),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomComponents.makeText(headingType: 'H4', data: 'Más detalles:', color: customBlack),
        Row(
          children: [
            CustomComponents.makeText(headingType: 'H6', data: 'Edad: ', color: customBlack),
            const SizedBox(height: 4,),
            CustomComponents.makeText(headingType: 'P3', data: '${user!.age}', color: customBlack),
          ],
        ),
        Row(
          children: [
            CustomComponents.makeText(headingType: 'H6', data: 'Id: ', color: customBlack),
            const SizedBox(height: 4,),
            CustomComponents.makeText(headingType: 'P3', data: user.userid, color: customBlack),
          ],
        )
      ],
    ),
  );

}