import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy / حقوق الاستخدام وسياسة الخصوصية'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy Policy Section
              Text(
                'Privacy Policy / سياسة الخصوصية',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This app provides instant chat services without storing any data on the client’s device. The database is automatically deleted, and no personal information such as names or messages is saved after the session ends.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'هذا التطبيق يقدم خدمة شات لحظي دون تخزين أي بيانات على جهاز العميل. يتم حذف قاعدة البيانات تلقائيًا، ولا يتم حفظ أي معلومات شخصية مثل الأسماء أو الرسائل بعد انتهاء الجلسة.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Terms of Use Section
              Text(
                'Terms of Use / حقوق الاستخدام',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This app is allowed for instant communication purposes only. The app administration is not responsible for any misuse or inappropriate content shared. All users must comply with local laws and policies while using the app.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'يُسمح باستخدام هذا التطبيق لأغراض التواصل الفوري فقط. لا تتحمل إدارة التطبيق مسؤولية أي إساءة استخدام أو محتوى غير لائق يتم مشاركته. يجب على جميع المستخدمين احترام القوانين والسياسات المحلية عند استخدام التطبيق.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Data Protection Section
              Text(
                'Data Protection / حماية البيانات',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'All data stored in the database is deleted once the session or server is closed. No identifying or personal information is retained about users.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'يتم حذف جميع البيانات المخزنة في قاعدة البيانات بمجرد إغلاق الجلسة أو الخادم. لا يتم الاحتفاظ بأي معلومات تعريفية أو شخصية عن المستخدمين.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Modifications Section
              Text(
                'Modifications / التعديلات',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This policy may be modified from time to time. It is recommended to review it periodically to ensure compliance with the terms.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'قد يتم تعديل هذه السياسة من وقت لآخر. يُنصح بمراجعتها دوريًا لضمان الالتزام بالشروط.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
