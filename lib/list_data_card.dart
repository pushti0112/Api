import 'package:flutter/material.dart';
import 'package:restapis_get_post_delete/models/data_model.dart';
import 'package:restapis_get_post_delete/size_config.dart';

import 'constants.dart';

class ListDataCard extends StatelessWidget {

  final Data data;
  int index;

  ListDataCard({Key key, @required this.data, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(68),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              margin: EdgeInsets.all(getProportionateScreenWidth(10)),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(data.avatar),
                ),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ) ,
        SizedBox(width: getProportionateScreenWidth(20),),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.firstName + " " + data.lastName,
              style: TextStyle(fontSize: 16,color: Colors.black),
              maxLines: 2,
            ),
            const SizedBox(height: 10,),
            Text.rich(
                TextSpan(
                    text: "${data.id}",
                    style: TextStyle(
                        color: kPrimaryColor),
                    children: [
                      TextSpan(
                          text: " ${data.email}",
                          style: TextStyle(color: kTextColor)
                      )
                    ]
                )
            )

          ],
        )
      ],
    );
  }
}
