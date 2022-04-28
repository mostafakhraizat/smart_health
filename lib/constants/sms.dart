import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class SMS extends StatefulWidget {
  const SMS({Key? key}) : super(key: key);

  @override
  _SMSState createState() => _SMSState();
}

class _SMSState extends State<SMS> {
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }


  List<String> people = [];
  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
          message: controller.text, recipients: recipients);
      print(_result);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: controller,
              ),
              InkWell(
                onTap: (){
                  _sendSMS(
                    ['+96176419875']
                  );
                  }
                ,
                child: Text('send'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
