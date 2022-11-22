import 'package:flutter/material.dart';

class receivingMsgWidget extends StatelessWidget {
  final String sender;
  final String msg;
  final String time;
  const receivingMsgWidget({Key? key, required this.msg,required this.sender, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 60,
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.purpleAccent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sender,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      msg,
                      style: TextStyle(color: Colors.white),
                    ),

                  ],
                ),
              ),
            ),
          ),
          Text(time),
          SizedBox(width: 5,),
        ],
      ),
    );
  }
}
