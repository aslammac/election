import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:dropdown_search/dropdown_search.dart';
//providers
import '../providers/main_provider.dart';
//models
import '../models/booth_model.dart';
import '../models/contact_model.dart';

class HomeDropdown extends StatefulWidget {
  @override
  _HomeDropdownState createState() => _HomeDropdownState();
}

class _HomeDropdownState extends State<HomeDropdown> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height -
            Scaffold.of(context).appBarMaxHeight,
        child: Neumorphic(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15),
                Container(
                  width: 300,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(8)),
                      depth: 5,
                      lightSource: LightSource.topLeft,
                    ),
                    padding: const EdgeInsets.only(
                        left: 15, top: 4, bottom: 4, right: 17),
                    child: DropdownButton<String>(
                      hint: Text('Select LAC'),
                      underline: Container(
                        height: 0,
                      ),
                      isExpanded: true,
                      value: Provider.of<MainProvider>(context).lacName,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      onChanged: (newValue) {
                        Provider.of<MainProvider>(context, listen: false)
                            .fetchLsga(newValue);
                        // print(controller.value.toString());
                      },
                      items: Provider.of<MainProvider>(context)
                          .lacList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // if (Provider.of<MainProvider>(context).pollingStaionList.isNotEmpty)
                Container(
                  width: 300,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(8)),
                      depth: 5,
                      lightSource: LightSource.topLeft,
                    ),
                    padding: const EdgeInsets.only(
                        left: 15, top: 4, bottom: 4, right: 17),
                    child: DropdownButton<String>(
                      hint: Text('Select LSGA'),
                      underline: Container(
                        height: 0,
                      ),
                      isExpanded: true,
                      value: Provider.of<MainProvider>(context).lsgaName,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      onChanged: (newValue) {
                        Provider.of<MainProvider>(context, listen: false)
                            .fetchBooth(newValue);
                        // print(controller.value.toString());
                      },
                      items: Provider.of<MainProvider>(context)
                                  .lsgaSelectedList !=
                              []
                          ? Provider.of<MainProvider>(context)
                              .lsgaSelectedList
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 300,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(8)),
                      depth: 5,
                      lightSource: LightSource.topLeft,
                    ),
                    padding: const EdgeInsets.only(left: 15, right: 17),
                    child: DropdownSearch<BoothModel>(
                      searchBoxController: controller,
                      showClearButton: true,
                      dropdownSearchDecoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      enabled: Provider.of<MainProvider>(context)
                              .pollingStaionList
                              .isEmpty
                          ? false
                          : true,
                      autoFocusSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        border: null,
                      ),
                      showSearchBox: true,
                      maxHeight: 350,
                      mode: Mode.DIALOG,
                      dropdownBuilderSupportsNullItem: true,
                      showSelectedItem: true,
                      hint: 'Select Polling Station',
                      items: Provider.of<MainProvider>(context)
                          .pollingStaionList
                          .map((e) => e)
                          .toList(),
                      itemAsString: (BoothModel item) => item.boothAsString(),
                      compareFn: (item, selectedItem) =>
                          item.isEqual(selectedItem),
                      onChanged: (value) =>
                          Provider.of<MainProvider>(context, listen: false)
                              .selectPollingBooth(value),
                      selectedItem: Provider.of<MainProvider>(context)
                          .pollingStationNameTemp,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: 300,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(8)),
                      depth: 5,
                      intensity: 1,
                      lightSource: LightSource.topLeft,
                      color: Colors.blueGrey,
                    ),
                    padding: const EdgeInsets.only(
                        left: 15, top: 4, bottom: 4, right: 17),
                    child: TextButton(
                        onPressed: Provider.of<MainProvider>(context).isLoading
                            ? null
                            : () {
                                try {
                                  Provider.of<MainProvider>(context,
                                          listen: false)
                                      .searchContact(context);
                                } catch (e) {
                                  print(e);
                                }
                              },
                        child: Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )),
                  ),
                ),
                // SizedBox(height: ),
                Spacer(),
                FutureBuilder(
                  future: Provider.of<MainProvider>(context).fetchRecent(),
                  builder: (BuildContext ctx, AsyncSnapshot booth) {
                    // if (booth.connectionState == ConnectionState.waiting) {
                    //   return Container(height: 0.0, width: 0.0);
                    // }
                    if (booth.data == false) {
                      return Container(height: 0.0, width: 0.0);
                    }
                    if (booth.data == true) {
                      BoothModel boothData =
                          Provider.of<MainProvider>(context).recentBooth;

                      return Container(
                        width: 300,
                        height: 150,
                        child: GestureDetector(
                          onTap: () =>
                              Provider.of<MainProvider>(context, listen: false)
                                  .searchContact(context, booth: boothData),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(8)),
                              depth: 5,
                              lightSource: LightSource.topLeft,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView(
                                children: [
                                  Text(
                                    'Recent Search',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Divider(),
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      boothData.pollingStation,
                                    ),
                                    subtitle: Text(
                                      boothData.lsga,
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.chevron_right),
                                      onPressed: () =>
                                          Provider.of<MainProvider>(context,
                                                  listen: false)
                                              .searchContact(context,
                                                  booth: boothData),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container(height: 0.0, width: 0.0);
                  },
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
