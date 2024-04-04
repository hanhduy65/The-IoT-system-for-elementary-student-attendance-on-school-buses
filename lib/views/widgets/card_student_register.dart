import 'package:flutter/material.dart';

class CardStudentRegister extends StatelessWidget {
  final String? name;
  const CardStudentRegister({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage("assets/image_avt/images1.jpg"),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(
        name ?? "",
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: const Text(
        "02/09/2002",
        style: TextStyle(color: Colors.black),
      ),
      trailing: const IntrinsicHeight(
        child: Column(
          children: [
            Text(
              "HS160643",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            Text(
              "Class: 4A3",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
