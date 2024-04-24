import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, this.result, this.onTap}) : super(key: key);

  final ScanResult? result;
  final VoidCallback? onTap;

  // Widget _buildTitle(BuildContext context) {
  //   if ((result?.device.name.length)! > 0) {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           result?.device.name ?? "",
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         Text(
  //           result?.device.id.toString() ?? "",
  //           style: Theme.of(context).textTheme.caption,
  //         )
  //       ],
  //     );
  //   } else {
  //     return Text(result?.device.id.toString() ?? " ");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (result?.device.name.length)! > 0,
      child: ExpansionTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              result?.device.name ?? "",
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              result?.device.id.toString() ?? "",
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        leading: SizedBox(),
        trailing: ElevatedButton(
          child: Text('REGISTER'),
          onPressed: (result?.advertisementData.connectable)! ? onTap : null,
        ),
      ),
    );
  }
}
