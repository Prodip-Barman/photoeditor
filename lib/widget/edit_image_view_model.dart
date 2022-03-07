import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photoeditor/models/text_info.dart';
import 'package:photoeditor/screens/edit_image_screen.dart';
import 'package:photoeditor/utils/utils.dart';
import 'package:photoeditor/widget/default_button.dart';
import 'package:screenshot/screenshot.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController createdText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  List<TextInfo> texts = [];
  int currentIndex = 0;

  saveToGallery(BuildContext context){
    if(texts.isNotEmpty){
      screenshotController.capture().then((Uint8List? image) {
        saveImage(image!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image saved to Gallery"),
          ),
        );
      }).catchError((err) => print(err));
    }
  }

  saveImage(Uint8List bytes) async{
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll(".", "_")
        .replaceAll(":", "-");
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  removeText(BuildContext context){
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Deleted Text"),
      ),
    );
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Selected for Styling"),
      ),
    );
  }

  changeTextColor(Color color){
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize(){
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize(){
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft(){
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter(){
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight(){
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText(){
    setState(() {
      if(texts[currentIndex].fontWeight == FontWeight.bold){
        texts[currentIndex].fontWeight = FontWeight.normal;
      }else{
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText(){
    setState(() {
      if(texts[currentIndex].fontStyle == FontStyle.italic){
        texts[currentIndex].fontStyle = FontStyle.normal;
      }else{
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText(){
    setState(() {
      if(texts[currentIndex].text.contains("\n")){
        texts[currentIndex].text = texts[currentIndex].text.replaceAll("\n", " ");
      }else{
        texts[currentIndex].text = texts[currentIndex].text.replaceAll(" ", "\n");
      }
    });
  }




  addNewText(BuildContext context) {
    setState(() {
      texts.add(TextInfo(textEditingController.text, 0, 0, Colors.black,
          FontWeight.normal, FontStyle.normal, 20, TextAlign.left));
    });
    Navigator.of(context).pop();
  }

  addNewDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Add New Text"),
              content: TextField(
                controller: textEditingController,
                maxLines: 5,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.edit),
                  filled: true,
                  hintText: "Your Text Here",
                ),
              ),
              actions: [
                DefaultButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancle"),
                    color: Colors.green,
                    textColor: Colors.black),
                DefaultButton(
                    onPressed: () {
                      addNewText(context);
                    },
                    child: const Text("Add Text"),
                    color: Colors.red,
                    textColor: Colors.white),
              ],
            ));
  }
}
