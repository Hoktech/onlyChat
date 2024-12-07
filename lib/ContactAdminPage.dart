import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class ContactAdminPage extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Admin'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a message to the app admin:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your message here...',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _sendEmail(context),
                child: Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail(BuildContext context) async  {
    try {
      await emailjs.send(
        'service_oxnxvhj',
        'template_isb6tqq',
        {
          'to_email': 'hoktechb@gmail.com',
          'message': _messageController.text,
        },
        const emailjs.Options(
            publicKey: 'zsb5wAKbuVOeAYogB',
            privateKey: '32piN8sINPv3_o_keSY7P',
            limitRate: const emailjs.LimitRate(
              id: 'app',
              throttle: 10000,
            )),
      );
      print('SUCCESS!');
    } catch (error) {
      if (error is emailjs.EmailJSResponseStatus) {
        print('ERROR... $error');
      }
      print(error.toString());
    }
  }
}
