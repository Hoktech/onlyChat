import 'package:onlychat/ContactAdminPage.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

// استيراد صفحة الحقوق
import 'privacy_policy_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nicknameController = TextEditingController();

  void _showAgeConfirmationDialog() async {
    bool isOldEnough = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Age Confirmation'),
        content: Text('This app is not suitable for children. Are you 18 years or older?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Not old enough
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Old enough
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (isOldEnough) {
      _navigateToChatScreen();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be 18 years or older to use this app.')),
      );
    }
  }

  void _navigateToChatScreen() {
    if (_nicknameController.text.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(nickname: _nicknameController.text.trim()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a nickname')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Only Chat!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: 'Enter your nickname',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showAgeConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                ),
                child: Text('Join Chat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ChatScreen extends StatefulWidget {
  final String nickname;
  ChatScreen({required this.nickname});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
    //_checkPermissions();
  }
  bool isConnecting = true;

  void _initializeSocket() {
    print('try Connected to socket');
    socket = IO.io(
      'https://onlychat.eng-mahmoudsalah.info',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.onConnect((_) {
      setState(() {
        isConnecting = false; // عند الاتصال بنجاح، إخفاء الـ loader
      });
      print('Connected to socket');
    });

    socket.on('receive_message', (data) {
      setState(() {
        print(data.toString());
        print(socket.id);
        if (data['socketID'] != socket.id) {
          messages.add({
            'nickname': data['nickname'],
            'message': data['message'],
            'type': data['type'],
          });
        }
      });
    });

    // إذا فشل الاتصال يمكن تعيين isConnecting إلى false هنا أيضًا
    socket.onConnectError((error) {
      setState(() {
        isConnecting = true; // عند حدوث خطأ، إخفاء الـ loader
      });
      _showErrorDialog( "ConnectError",error.toString());
    });
  }

  void _showErrorDialog(String title, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            'There was an error: $errorMessage\n\n'
                'Please check your internet connection or contact support.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الـ Dialog
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactAdminPage(),
                ));
              },
              child: Text('Contact Admin'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _checkPermissions() async {
  //   if (!await _audioRecorder.hasPermission()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Microphone permission is required')),
  //     );
  //   }
  // }
  //
  // Future<void> startRecording() async {
  //   if (await _audioRecorder.hasPermission()) {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  //
  //     await _audioRecorder.start(
  //       path: path,
  //       encoder: AudioEncoder.aacLc,
  //       bitRate: 128000,
  //     );
  //
  //     setState(() {
  //       _isRecording = true;
  //     });
  //   }
  // }
  //
  // Future<void> stopRecording() async {
  //   final path = await _audioRecorder.stop();
  //
  //   setState(() {
  //     _isRecording = false;
  //   });
  //
  //   if (path != null) {
  //     final bytes = await File(path).readAsBytes();
  //     final base64Audio = base64Encode(bytes);
  //
  //     socket.emit('send_message', {
  //       'message': base64Audio,
  //       'nickname': widget.nickname,
  //       'type': 'audio',
  //     });
  //   }
  // }

  void sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      socket.emit('send_message', {'message': message.trim(), 'nickname': widget.nickname, 'type': 'text'});

      setState(() {
        //messages.add({'nickname': widget.nickname, 'message': message.trim(), 'type': 'text'});
        _messageController.clear();
      });
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Only Chat - ${widget.nickname}'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.headset_mic_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactAdminPage()),
              );
            },
          ),
        ],
      ),
      body: isConnecting
          ? Center(child: CircularProgressIndicator()) :Column(

        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isMe = messages[index]['nickname'] == widget.nickname;
                final isAudio = messages[index]['type'] == 'audio';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isAudio
                        ? ElevatedButton(
                      onPressed: () async {
                        final bytes = base64Decode(messages[index]['message']!);
                        final dir = await getTemporaryDirectory();
                        final file = File('${dir.path}/temp.m4a');
                        await file.writeAsBytes(bytes);

                        await AudioPlayer().play(file.path as Source);
                      },
                      child: Text('Play Audio'),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messages[index]['nickname']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(messages[index]['message']!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       icon: Icon(_isRecording ? Icons.stop : Icons.mic),
          //       onPressed: _isRecording ? stopRecording : startRecording,
          //       color: _isRecording ? Colors.red : Colors.blue,
          //       iconSize: 50,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
