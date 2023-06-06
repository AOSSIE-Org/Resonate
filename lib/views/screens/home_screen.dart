import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.amber,
                  AppColor.yellowColor,
                ]),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.circlePlay, color: Colors.green,size: 20,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Happening Now", style: TextStyle(color: Colors.black45),),
                          Spacer(),
                          FaIcon(FontAwesomeIcons.ellipsis, color: Colors.black,),
                        ],
                      ),
                      SizedBox(height: Get.height*0.01,),
                      Text(
                        "For the love of open source🧑‍💻 #flutter #resonate #aossie",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(height: Get.height*0.005,),
                      Text(
                        "Open Source · Voice Platform · New",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100, color: Colors.black54),
                      ),
                      SizedBox(height: Get.height*0.01,),

                    ],
                  ),
                ),
                Container(
                  color: Colors.black12,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 6,
                          ),
                          for (int i = 0; i < 3; i++)
                            Align(
                              widthFactor: 0.5,
                              child: CircleAvatar(
                                radius: 19,
                                backgroundColor: Color.fromRGBO(230, 171, 49, 1),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                      "https://avatars.githubusercontent.com/u/41890434?v=4"),
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("26+ Joined",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w100, color: Colors.black54)),
                          Spacer(),
                          FaIcon(FontAwesomeIcons.thumbsUp, color: Colors.black,),
                          SizedBox(width: 10,),
                          Icon(Icons.share, color: Colors.black,),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     CircleAvatar(
                      //       radius:12,
                      //       backgroundColor: Colors.amber,
                      //       child: CircleAvatar(
                      //         radius: 10,
                      //         backgroundImage: NetworkImage(
                      //             "https://avatars.githubusercontent.com/u/41890434?v=4"),
                      //       ),
                      //     ),
                      //     Text("Chandan S Gowda"),
                      //   ],
                      // ),
                      // Text("Open Source Contributor, AOSSIE")
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
