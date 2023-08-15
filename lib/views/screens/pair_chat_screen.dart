import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PairChatScreen extends StatelessWidget {
  const PairChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Be polite and respect the other person's opinion. Avoid rude comments.",
                    style: TextStyle(color: Colors.amber),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical:20),
            color: Colors.black,
            height: Get.height*0.16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton(onPressed: (){}, child: Icon(Icons.mic),),
                    SizedBox(height: Get.height*0.005,),
                    Text("Mute")
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(onPressed: (){}, child: Icon(Icons.volume_up),),
                    SizedBox(height: Get.height*0.005,),
                    Text("Speaker")
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(onPressed: (){}, child: Icon(Icons.cancel_outlined),backgroundColor: Colors.redAccent,),
                    SizedBox(height: Get.height*0.005,),
                    Text("End")
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
