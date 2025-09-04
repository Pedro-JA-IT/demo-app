import 'package:awesome_dialog/awesome_dialog.dart'; // Import for AwesomeDialog
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEditMoviePage extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>>? document;
  final bool isEditing;
  final String? collectionName; // To know which collection to update/add to

  const AddEditMoviePage({
    super.key,
    this.document,
    required this.isEditing,
    this.collectionName,
  });

  @override
  State<AddEditMoviePage> createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  late TextEditingController _yearController;
  late TextEditingController _rateController;
  late TextEditingController _descriptionController;
  late TextEditingController _directorController;
  late TextEditingController _starController;
  late TextEditingController _genreController;
  late TextEditingController _durationController;
  late TextEditingController _trailerUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.isEditing ? widget.document!['title'] : '');
    _urlController = TextEditingController(
        text: widget.isEditing ? widget.document!['url'] : '');
    _yearController = TextEditingController(
        text: widget.isEditing ? widget.document!['year'].toString() : '');
    _rateController = TextEditingController(
        text: widget.isEditing ? widget.document!['rate'].toString() : '');
    _descriptionController = TextEditingController(
        text: widget.isEditing ? widget.document!['description'] : '');
    _directorController = TextEditingController(
        text: widget.isEditing ? widget.document!['director'] : '');
    // Handle list for stars and genre
    _starController = TextEditingController(
        text: widget.isEditing
            ? (widget.document!['star'] is List
                ? (widget.document!['star'] as List).join(', ')
                : widget.document!['star'])
            : '');
    _genreController = TextEditingController(
        text: widget.isEditing
            ? (widget.document!['genre'] is List
                ? (widget.document!['genre'] as List).join(', ')
                : widget.document!['genre'])
            : '');
    _durationController = TextEditingController(
        text: widget.isEditing ? widget.document!['duration'] : '');
    _trailerUrlController = TextEditingController(
        text: widget.isEditing ? widget.document!['trailerUrl'] : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _yearController.dispose();
    _rateController.dispose();
    _descriptionController.dispose();
    _directorController.dispose();
    _starController.dispose();
    _genreController.dispose();
    _durationController.dispose();
    _trailerUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final movieData = {
          'title': _titleController.text.trim(),
          'url': _urlController.text.trim(),
          'year': int.tryParse(_yearController.text.trim()) ?? 0,
          'rate': double.tryParse(_rateController.text.trim()) ?? 0.0,
          'description': _descriptionController.text.trim(),
          'director': _directorController.text.trim(),
          'star': _starController.text
              .trim()
              .split(',')
              .map((e) => e.trim())
              .toList(), // Convert to list
          'genre': _genreController.text
              .trim()
              .split(',')
              .map((e) => e.trim())
              .toList(), // Convert to list
          'duration': _durationController.text.trim(),
          'trailerUrl': _trailerUrlController.text.trim(),
        };

        if (widget.isEditing) {
          // Update existing movie
          await FirebaseFirestore.instance
              .collection(widget.collectionName ??
                  "Movies") // Use provided collection name or default
              .doc(widget.document!.id)
              .update(movieData);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Success',
            desc: 'Movie updated successfully!',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        } else {
          await FirebaseFirestore.instance
              .collection("moviebody")
              .add(movieData);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Success',
            desc: 'Movie added successfully!',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        }
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Failed to save movie: $e',
          btnOkOnPress: () {},
        ).show();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Movie' : 'Add New Movie',
          style: TextStyle(color: Colors.amber),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.amber),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        elevation: 4,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(
                      _titleController,
                      'Title',
                      (value) =>
                          value!.isEmpty ? 'Please enter a title' : null),
                  _buildTextField(
                      _urlController,
                      'Image URL',
                      (value) =>
                          value!.isEmpty ? 'Please enter an image URL' : null),
                  _buildTextField(
                      _yearController,
                      'Year',
                      (value) =>
                          value!.isEmpty ? 'Please enter the year' : null,
                      keyboardType: TextInputType.number),
                  //to be continued...

                  _buildTextField(
                      _rateController,
                      'Rate',
                      (value) =>
                          value!.isEmpty ? 'Please enter the rate' : null,
                      keyboardType: TextInputType.number),
                  _buildTextField(
                      _descriptionController,
                      'Description',
                      (value) =>
                          value!.isEmpty ? 'Please enter a description' : null,
                      maxLines: 3),
                  _buildTextField(
                      _directorController,
                      'Director',
                      (value) =>
                          value!.isEmpty ? 'Please enter the director' : null),
                  _buildTextField(_starController, 'Stars (comma-separated)',
                      (value) => value!.isEmpty ? 'Please enter stars' : null),
                  _buildTextField(_genreController, 'Genre (comma-separated)',
                      (value) => value!.isEmpty ? 'Please enter genre' : null),
                  _buildTextField(
                      _durationController,
                      'Duration',
                      (value) =>
                          value!.isEmpty ? 'Please enter duration' : null),
                  _buildTextField(
                      _trailerUrlController,
                      'Trailer URL',
                      (value) =>
                          value!.isEmpty ? 'Please enter trailer URL' : null),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveMovie,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.isEditing ? 'Update Movie' : 'Add Movie',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String? Function(String?)? validator,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber[200]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber.shade600, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade600, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[700],
        ),
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }
}
