import 'package:flutter/material.dart';

class ChefPage extends StatefulWidget {
  const ChefPage({super.key});

  @override
  State<ChefPage> createState() => _ChefPageState();
}

class _ChefPageState extends State<ChefPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Palov, Kabob, milliy taomlar"),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 400,
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                        image: AssetImage("assets/images/rasm11.jpg"),
                        fit: BoxFit.cover,
                      )),
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    alignment: Alignment.center,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          size: 18,
                                          color: Colors.amber,
                                        ),
                                        Text(
                                          "4.9",
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Hoji aka",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                      Text(
                                        "Toshkent palov ustasi",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 5,),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "20 yil tajriba",
                            style: TextStyle(color: Colors.amber, fontSize: 20),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black12
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Text("1.5mln so'm/200kishi",style: TextStyle(
                                color: Colors.green
                              ),),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone,size: 25,color: Colors.amber,),
                          SizedBox(width: 4,),
                          Text("+998 90 123 45 67"),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,size: 25,color: Colors.amber,),
                          SizedBox(width: 4,),
                          Text("Toshkent,Yunusobot"),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
