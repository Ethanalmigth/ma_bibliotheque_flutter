import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookScreen extends StatefulWidget {
  static const String id = 'add_book_screen';

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  String description = '';

  void addBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('books').add({
          'title': title,
          'author': author,
          'description': description,
          'added_by': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un livre'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Titre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le titre du livre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Auteur'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'auteur du livre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    author = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: addBook,
                  child: Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                   // primary: Colors.yellow, // Couleur du bouton
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AddBookScreen extends StatefulWidget {
  static const String id = 'add_book_screen';

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  String description = '';
  File? _selectedImage;
  File? _selectedDocument;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    PermissionStatus photoPermissionStatus = await Permission.photos.status;
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;

    if (photoPermissionStatus.isGranted && cameraPermissionStatus.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } else {
      if (!photoPermissionStatus.isGranted) {
        await Permission.photos.request();
      }
      if (!cameraPermissionStatus.isGranted) {
        await Permission.camera.request();
      }

      if (await Permission.photos.isGranted && await Permission.camera.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permissions de l\'appareil photo ou de la galerie non accordées'),
        ));
      }
    }
  }

  Future<void> _pickDocument() async {
    PermissionStatus storagePermissionStatus = await Permission.storage.status;

    if (storagePermissionStatus.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _selectedDocument = File(result.files.single.path!);
        });
      }
    } else {
      await Permission.storage.request();

      if (await Permission.storage.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          setState(() {
            _selectedDocument = File(result.files.single.path!);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission de stockage non accordée'),
        ));
      }
    }
  }


  Future<String> _uploadFile(File file, String path) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors du téléchargement du fichier: $e'),
      ));
      rethrow;
    }
  }

  void addBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      User? user = _auth.currentUser;
      if (user != null) {
        String? imageUrl;
        String? documentUrl;

        try {
          if (_selectedImage != null) {
            imageUrl = await _uploadFile(_selectedImage!, 'book_images/${user.uid}_${DateTime.now().millisecondsSinceEpoch}');
          }

          if (_selectedDocument != null) {
            documentUrl = await _uploadFile(_selectedDocument!, 'book_documents/${user.uid}_${DateTime.now().millisecondsSinceEpoch}');
          }

          await _firestore.collection('books').add({
            'title': title,
            'author': author,
            'description': description,
            'added_by': user.uid,
            'image_url': imageUrl,
            'document_url': documentUrl,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Livre ajouté avec succès!'),
          ));

          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erreur lors de l\'ajout du livre: $e'),
          ));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un livre'),
        backgroundColor: Colors.yellow,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Titre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le titre du livre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Auteur'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'auteur du livre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    author = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _pickImage,
                  child: Text('Sélectionner une image'),
                ),
                _selectedImage == null
                    ? Text('Aucune image sélectionnée.')
                    : Image.file(_selectedImage!),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _pickDocument,
                  child: Text('Sélectionner un document'),
                ),
                _selectedDocument == null
                    ? Text('Aucun document sélectionné.')
                    : Text('Document sélectionné: ${_selectedDocument!.path.split('/').last}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: addBook,
                  child: Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.yellow, // Couleur du bouton
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
