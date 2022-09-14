import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  List<String> list = [];
  var deleteIndex = -1;
  var value = "";
  @override
  void initState(){
    load();
  }
  void load() async{
   final prefs = await SharedPreferences.getInstance();

    setState(() {
      list = (prefs.getStringList('items'))!;
    });
  }
  void addTask() async{
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      list.add(value);
    });
    await prefs.setStringList('items', list);
  }
  void deleteTask(){
    setState(() {
      list.removeAt(deleteIndex);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: Scaffold(
      body: Center(
        // ignore: prefer_const_constructors
        child: SizedBox(
          width: 300,
          height: 500,
          child: Card(
           elevation: 10,
           child: Column(children: [
            //textField
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(4),
              ),
              width: 250,
              margin: EdgeInsets.only(top: 30)
              ,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Enter TODO Task",
                  hintStyle: TextStyle(
                    
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (text){
                  value = text;
                }  ,
              ),
            ),
            //button
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(onPressed: (){
                    addTask();
                  }, child: Text("Add Task"),

                  ),
                  
                )
              )
            ),
            //slidingWindow
            Container(
              width: 250,
              height: 200,
              child: ListView(children: [
              for(int i = 0; i < list.length; i++) ... [
              Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(4),
              ),
              width: 250,
              height: 50,
              margin: EdgeInsets.only(top: 30)
              ,
              child: ListTile( 
                title: Text(list[i],style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),),
                trailing: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      deleteIndex = i;
                      deleteTask();
                    },
                    child: Icon(Icons.delete, color: Colors.red,)))
              ),
              )
              ]
              ],)
            ),
           ],)
          ),
        ), 
        ),
     ),
    );
  }
}

