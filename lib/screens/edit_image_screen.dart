import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photoeditor/widget/edit_image_view_model.dart';
import 'package:photoeditor/widget/image_text.dart';
import 'package:screenshot/screenshot.dart';

class EditImageScreen extends StatefulWidget {
  final String selectedImage;

  const EditImageScreen({Key? key, required this.selectedImage})
      : super(key: key);

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _selectedImage,
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                    left: texts[i].left,
                    top: texts[i].top,
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          currentIndex = i;
                          removeText(context);
                        });
                      },
                      onTap: () {
                        setCurrentIndex(context, i);
                      },
                      child: Draggable(
                        feedback: ImageText(textInfo: texts[i]),
                        child: ImageText(textInfo: texts[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            texts[i].top = off.dy - 96;
                            texts[i].left = off.dx;
                          });
                        },
                      ),
                    ),
                  ),
                createdText.text.isNotEmpty
                    ? Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          createdText.text,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.3)),
                        ))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _addNewTextFAB,
    );
  }

  AppBar get _appBar {
    return AppBar(
      backgroundColor: Colors.cyanAccent,
      automaticallyImplyLeading: false,
      title: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            IconButton(
                tooltip: "Save Image",
                onPressed: () {
                  saveToGallery(context);
                },
                icon: const Icon(
                  Icons.save,
                  color: Colors.black,
                )),
            IconButton(
                tooltip: "Increase Font Size",
                onPressed: () {
                  increaseFontSize();
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                )),
            IconButton(
                tooltip: "Decrease Font Size",
                onPressed: () {
                  decreaseFontSize();
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                )),
            IconButton(
                tooltip: "Align Left",
                onPressed: alignLeft,
                icon: const Icon(
                  Icons.format_align_left,
                  color: Colors.black,
                )),
            IconButton(
                tooltip: "Align Center",
                onPressed: alignCenter,
                icon: const Icon(
                  Icons.format_align_center,
                  color: Colors.black,
                )),
            IconButton(
                tooltip: "Align Right",
                onPressed: alignRight,
                icon: const Icon(
                  Icons.format_align_right,
                  color: Colors.black,
                )),
            IconButton(
                tooltip: "Bold",
                onPressed: boldText,
                icon: const Icon(
                  Icons.format_bold,
                  color: Colors.black,
                )),
            IconButton(
                tooltip: "Italic",
                onPressed: italicText,
                icon: const Icon(
                  Icons.format_italic,
                  color: Colors.black,
                )),
            IconButton(
                tooltip: "Add New Line",
                onPressed: addLinesToText,
                icon: const Icon(
                  Icons.space_bar,
                  color: Colors.black,
                )),
            Tooltip(
              message: "Black",
              child: GestureDetector(
                onTap: (){
                  changeTextColor(Colors.black);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Tooltip(
              message: "White",
              child: GestureDetector(
                onTap: (){
                  changeTextColor(Colors.white);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Tooltip(
              message: "Red",
              child: GestureDetector(
                onTap: (){
                  changeTextColor(Colors.red);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Tooltip(
              message: "Green",
              child: GestureDetector(
                onTap: (){
                  changeTextColor(Colors.green);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Tooltip(
              message: "Blue",
              child: GestureDetector(
                onTap: (){
                  changeTextColor(Colors.blue);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Tooltip(
              message: "Yellow",
              child: GestureDetector(
                onTap: (){
                  changeTextColor(Colors.yellow);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.yellow,
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Tooltip(
              message: "Orange",
              child: GestureDetector(
                onTap: (){
                  changeTextColor(Colors.orange);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Tooltip(
              message: "Pink",
              child: GestureDetector(
                onTap: (){
                  changeTextColor(Colors.pink);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.pink,
                ),
              ),
            ),
            const SizedBox(width: 5,),
          ],
        ),
      ),
    );
  }

  Widget get _selectedImage {
    return Center(
      child: Image.file(
        File(widget.selectedImage),
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  Widget get _addNewTextFAB {
    return FloatingActionButton(
      onPressed: () {
        addNewDialog(context);
      },
      backgroundColor: Colors.white,
      tooltip: "Add New Text",
      child: const Icon(
        Icons.edit,
        color: Colors.black,
      ),
    );
  }
}
