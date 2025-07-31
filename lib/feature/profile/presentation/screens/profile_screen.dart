import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('Mitt konto')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.black,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30,
                ),
                title: Text('Faizan Javed', style: TextStyle(color: Colors.white)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('faziimughal22@gmail.com', style: TextStyle(color: Colors.white)),
                    Text('03445821796', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Kontoinställningar'),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Mina betalmetoder'),
            ),
            ListTile(
              leading: Icon(Icons.support),
              title: Text('Support'),
            ),
          ],
        ),
      ),
    );
  }
}