import 'dart:convert';

import 'package:busmate/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:momentum/momentum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/login_controller.dart';
import '../../../events/events.dart';

class PlaceAPIGoogleMapSearch extends StatefulWidget {
  final String? stuId;
  const PlaceAPIGoogleMapSearch({super.key, this.stuId});

  @override
  State<PlaceAPIGoogleMapSearch> createState() =>
      _PlaceAPIGoogleMapSearchState();
}

class _PlaceAPIGoogleMapSearchState
    extends MomentumState<PlaceAPIGoogleMapSearch> {
  // String? tokenForSession;
  // var uuid = Uuid();
  List<dynamic> listPlaces = [
    const LocationModel(
        name: "Viettel Hòa Lạc", lat: "21.0106151", long: "105.5246687"),
    const LocationModel(
        name: "Fsoft Academy Building", lat: "21.0109365", long: "105.5175171"),
    const LocationModel(
        name: "Trạm Xăng Dầu Thạch Hòa 39",
        lat: "21.0096946",
        long: "105.5185471"),
    const LocationModel(
        name: "Chung cư Phenikaa", lat: "20.9857815", long: "105.529626")
  ];
  int? selectedValue = 0;
  changeSelectedIndex(v) {
    setState(() {
      selectedValue = v;
    });
  }

  /*
  void makeSuggestion(String input) async {
    String googlePlacesAPIKey = "AIzaSyDU8QUZiekBQuIuv4FLa--C8i-rUZoIkfc";
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundURL?input=$input&key=$googlePlacesAPIKey&sessiontoken=$tokenForSession';
    var responseResult = await http.get(Uri.parse(request));
    var Resultdata = responseResult.body.toString();

    print("result data" + Resultdata);

    if (responseResult.statusCode == 200) {
      setState(() {
        listPlaces = jsonDecode(responseResult.body.toString())['predictions'];
      });
    } else {
      throw Exception("Showing data failed, try again");
    }
  }

  void onModify() {
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(_controller.text);
  }



  @override
  void initState() {
    // TODO: implement initState
     super.initState();
     _controller.addListener(() {
       onModify();
     });
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUpData();
  }

  void setUpData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      selectedValue = sp.getInt("key_indexValueSelect");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ombre_blue.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading:
                Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            title: Text(
              "Choosing location",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                      "Choose one of the following locations to pick up/drop off your child: "),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listPlaces.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                        value: index,
                        groupValue: selectedValue,
                        selected: index == selectedValue,
                        onChanged: changeSelectedIndex,
                        title: Text(listPlaces[index].name),
                        activeColor: Theme.of(context).colorScheme.secondary);
                  },
                ),
                SizedBox(
                  height: 50.h,
                ),
                InkWell(
                  onTap: () async {
                    print(listPlaces[selectedValue!].name +
                        listPlaces[selectedValue!].lat +
                        listPlaces[selectedValue!].long);
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.setString(
                        "key_latBusStop", listPlaces[selectedValue!].lat);
                    sp.setString(
                        "key_longBusStop", listPlaces[selectedValue!].long);
                    sp.setInt("key_indexValueSelect", selectedValue!);
                    Momentum.controller<LoginController>(context)
                        .doSendRegisterBusStop(
                            widget.stuId!,
                            listPlaces[selectedValue!].lat,
                            listPlaces[selectedValue!].long);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Thiết lập bo tròn cho Card
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    surfaceTintColor: Colors.transparent,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Center(
                        child: IntrinsicWidth(
                          child: ListTile(
                            leading: Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void initMomentumState() {
    // TODO: implement initMomentumState
    super.initMomentumState();
    final loginController = Momentum.controller<LoginController>(context);
    loginController.listen<RegisterEvent>(
      state: this,
      invoke: (event) {
        switch (event.action) {
          case true:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Save pick up/ drop off location successful'),
                backgroundColor: Colors.green, // Thay đổi màu sắc ở đây
              ),
            );
            break;
          case false:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Save pick up/ drop off location fail'),
                backgroundColor: Colors.red, // Thay đổi màu sắc ở đây
              ),
            );
            break;
          case null:
            print(event.message);
            break;
          default:
        }
      },
    );
  }
}
