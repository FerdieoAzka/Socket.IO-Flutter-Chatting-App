import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'msg.dart';
import 'receive_msg_widget.dart';
import 'sender_msg_widget.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class groupPage extends StatefulWidget {
  final String name;
  final String uuid;
  const groupPage({Key? key, required this.name, required this.uuid})
      : super(key: key);

  @override
  State<groupPage> createState() => _groupPageState();
}

class _groupPageState extends State<groupPage> {
  IO.Socket? socket;
  List<msgType> listMsg = [];
  TextEditingController msgController = TextEditingController();
  var uuidMsg = Uuid();
  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io("http://localhost:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.onConnect((_) {
      print("connected to frontend");
      socket!.on("sendMsgFromServer", (msg) {
        setState(() {
          if (msg["uuid"] != widget.uuid) {
            listMsg.add(msgType(
                msg: msg["msg"],
                type: msg["type"],
                sender: msg["senderName"],
                time: msg["time"],
                id: msg["uuidMsg"]));
          }
        });
      });
        socket!.on("deleteMsg", (uuidMsg) {
          setState(() {
            listMsg.removeWhere((element) => element.id == uuidMsg['uuidMsg']);
        });
      });
    });
  }

  void sendMsg(String msg, String senderName, String uuidMsg) {
    msgType ownMsg = msgType(
        msg: msg,
        type: "ownMsg",
        sender: senderName,
        time: DateFormat.Hm().format(DateTime.now()),
        id: uuidMsg);
    listMsg.add(ownMsg);
    setState(() {
      listMsg;
    });
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "senderName": senderName,
      "uuid": widget.uuid,
      "time": DateFormat.Hm().format(DateTime.now()),
      "uuidMsg": uuidMsg,
    });
  }

  void unsendMsg(String uuidMsg) {
    socket!.emit('unsendMsg', {
      "uuidMsg": uuidMsg,
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Socket.IO Chat Room"),
          centerTitle: false,
          backgroundColor: Color(0xFF0A0E21),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: listMsg.length,
                  itemBuilder: (context, index) {
                    if (listMsg[index].type == "ownMsg") {
                      return GestureDetector(
                        onLongPress: () => showDialog(
                          context: context,
                          builder: (BuildContext) => AlertDialog(
                            title: Text("Do you want to unsend this message?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel",style: TextStyle(fontSize: 18),),),
                              TextButton(
                                  onPressed: () {
                                    unsendMsg(listMsg[index].id);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Unsend",style: TextStyle(color:Colors.red,fontSize: 18),)),
                            ],
                          ),
                        ),
                        child: sendingMsgWidget(
                            msg: listMsg[index].msg,
                            sender: listMsg[index].sender,
                            time: listMsg[index].time),
                      );
                    } else {
                      return receivingMsgWidget(
                          msg: listMsg[index].msg,
                          sender: listMsg[index].sender,
                          time: listMsg[index].time);
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: msgController,
                      decoration: InputDecoration(
                        hintText: 'Start typing here ... ',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFFEB1555),
                          ),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                msgController.clear();
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.purple,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                String message = msgController.text;
                                if (message.length > 0) {
                                  sendMsg(
                                    message,
                                    widget.name,
                                    uuidMsg.v1(),
                                  );
                                  msgController.clear();
                                }
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
