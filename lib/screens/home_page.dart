import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoeditor/screens/edit_image_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(Icons.upload_file),
          onPressed: () async{
            XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
            if(file != null){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditImageScreen(selectedImage: file.path),),);
            }
          },
        ),
      ),
    );
  }
}
