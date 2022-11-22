import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:group_chat/group_page.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);


  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Socket.IO Chat"),
        backgroundColor: Color(0xFF0A0E21),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Socket-io.jpg',height: 250,width: 250,),
            SizedBox(height: 50,),
            FloatingActionButton.extended(
              backgroundColor: Color(0xFF0A0E21),
              label: Text("Start Group Chat"),
              icon: Icon(Icons.group,
              size: 24.0,),
              onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: const Text("Please enter your name"),
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                        controller: nameController,
                        validator: (value){
                          if(value == null || value.length<3){
                            return "Invalid Name!";
                          }
                          return null;
                        }
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          nameController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel",style: TextStyle(fontSize: 18),)),
                    TextButton(
                      onPressed: () {
                        if(formKey.currentState!.validate())
                        { String userName = nameController.text;
                        nameController.clear();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                groupPage( name: userName,uuid: uuid.v1(),
                                ),
                          ),
                        );
                        };
                      },

                      child: const Text(
                        "Enter",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ]),
            ),

            ),],
        ),
      ),
    );
    return Container();
  }
}
