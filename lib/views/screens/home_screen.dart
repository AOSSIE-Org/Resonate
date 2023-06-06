import 'package:flutter/material.dart';
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
                          Icon(Icons.live_tv),
                          SizedBox(
                            width: 5,
                          ),
                          Text("LIVE"),
                          Spacer(),
                          Icon(Icons.menu_outlined)
                        ],
                      ),
                      Text(
                        "For the love of open source🧑‍💻 #flutter #resonate #aossie",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      Text(
                        "Open Source · Voice Platform · New",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 6,
                          ),
                          for (int i = 0; i < 3; i++)
                            Align(
                              widthFactor: 0.5,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.amber,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      "https://avatars.githubusercontent.com/u/41890434?v=4"),
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("26+ Members",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w100)),
                          Spacer(),
                          Icon(Icons.favorite_outlined, color: Colors.red,),
                          SizedBox(width: 10,),
                          Icon(Icons.share, color: Colors.black,),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black12,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Featured"),
                      Row(
                        children: [
                          CircleAvatar(
                            radius:12,
                            backgroundColor: Colors.amber,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(
                                  "https://avatars.githubusercontent.com/u/41890434?v=4"),
                            ),
                          ),
                          Text("Chandan S Gowda"),
                        ],
                      ),
                      Text("Open Source Contributor, AOSSIE")
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
