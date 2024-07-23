import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:front_sosmed/widgets/post_text_field.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final ap = FirebaseAuth.instance.currentUser;

  File? _image;

  final imagePicker = ImagePicker();

  get data => null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Postingan Baru"),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(
                    height: 350,
                    width: 350,
                    child: _image == null
                        ? Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.image,
                                  size: 50,
                                ),
                                const Text(
                                  "Pilihlah gambar yang sedang ingin kau bagikan ke dunia.",
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showPictureDialog();
                                  },
                                  child: const Text("Pilih Gambar"),
                                ),
                              ],
                            ),
                          )
                        : Image.file(File(_image!.path))),
                const Gap(20),
                PostTextField(
                  controller: titleController,
                  labelText: 'Judul',
                ),
                const Gap(10),
                PostTextField(
                  controller: descriptionController,
                  labelText: 'Deskripsi',
                ),
                const Gap(30),
                ElevatedButton(
                  child: const Text('Posting'),
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        _image.toString().isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi'),
                            content:
                                const Text('Anda yakin ingin memposting ini ?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  titleController.clear();
                                  descriptionController.clear();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Tidak'),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    var imageName = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    var storageRef = FirebaseStorage.instance
                                        .ref()
                                        .child('image_post/$imageName.jpg');
                                    var uploadTask =
                                        storageRef.putFile(_image!);
                                    var downloadUrl = await (await uploadTask)
                                        .ref
                                        .getDownloadURL();

                                    firestore.collection("User Posts").add({
                                      "Title": titleController.text,
                                      "Description": descriptionController.text,
                                      "TimeStamp": Timestamp.now(),
                                      "Likes": [],
                                      // Add image reference to document
                                      "Image": downloadUrl.toString()
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ya'))
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<void> showPictureDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Action'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  getFromCamera();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getFromGallery();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Gallery'),
              ),
            ],
          );
        });
  }

  // get from gallery
  getFromGallery() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // get from camera
  getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
