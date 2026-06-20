import 'package:flutter/material.dart';

void main() {
  runApp(const MaegaApp());
}

class MaegaApp extends StatelessWidget {
  const MaegaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}
const red= Color(0xffcf2142);
class ProfileScreen extends StatelessWidget{
const ProfileScreen({super.key});
void open(BuildContext context, Widget page){
  Navigator.push(context, MaterialPageRoute(builder: (_)=>page));
}
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  logo(),
                  const Text(
                    "profile",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  boxIcon(Icons.settings),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: red,
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget boxIcon(IconData icon) {
    return Icon(icon);
  }

  Widget logo() {
    return const Text(
      'Maega',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget bottomBar() {
    return BottomAppBar(
      child: SizedBox(height: 56),
    );
  }
}
