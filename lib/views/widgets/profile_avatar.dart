import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';

Widget profileAvatar(BuildContext context){
  return  Padding(
      padding:const EdgeInsets.only(left: 5),
    child:   GetBuilder<AuthStateController>(
      builder: (controller) =>   CircleAvatar(
          backgroundColor: Colors.grey[800],
          backgroundImage: controller.profileImageUrl == null || controller.profileImageUrl!.isEmpty? NetworkImage(controller.profileImageUrl ?? ""):null,
          child:const Icon(Icons.person_outline,color: Colors.amber,) ,
        ),
    ));
}