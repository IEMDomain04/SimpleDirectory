import 'package:account_directory/pages/directoryList.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF371375), //Background Color of the App
      //Widget for OverFlow
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Column(
            // Title
            children: [
              Text("Directory",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.white)),
              SizedBox(height: 30.0),

              // Icon
              Center(
                child: Image.asset("assets/DirectoryIcon.png",
                    width: 180, height: 180),
              ),
              SizedBox(height: 50),

              // Simple "Enter" Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DirectoryList(),
                    ),
                  );
                },
                child: Image.asset("assets/EnterButton.png"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
