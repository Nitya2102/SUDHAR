// Remove any import for file_picker
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({super.key});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;
  String? selectedState;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  // Cross-platform image
  File? selectedImageFile;          // Mobile/Desktop
  Uint8List? selectedImageBytes;    // Web

  // Submission message
  String? submitMessage;
  bool submitSuccess = false;

  final List<String> issueCategories = [
    'Road Damage',
    'Garbage',
    'Water Leakage',
    'Street Light',
    'Drainage',
    'Electricity',
    'Public Safety',
    'Other',
  ];

  final List<String> indianStates = [
    'Andhra Pradesh','Arunachal Pradesh','Assam','Bihar','Chhattisgarh','Delhi',
    'Goa','Gujarat','Haryana','Himachal Pradesh','Jharkhand','Karnataka','Kerala',
    'Madhya Pradesh','Maharashtra','Odisha','Punjab','Rajasthan','Tamil Nadu',
    'Telangana','Uttar Pradesh','Uttarakhand','West Bengal',
  ];

  // ---------------- IMAGE PICKER ----------------
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Mobile & Web
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          selectedImageBytes = bytes;
          selectedImageFile = null;
        });
      } else {
        setState(() {
          selectedImageFile = File(image.path);
          selectedImageBytes = null;
        });
      }
    }
  }

  // ---------------- SUBMIT FORM ----------------
  Future<void> submitForm() async {
    var uri = Uri.parse('http://172.18.51.146:8000/report-issue/');
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = titleController.text;
    request.fields['category'] = selectedCategory ?? '';
    request.fields['description'] = descriptionController.text;
    request.fields['state'] = selectedState ?? '';
    request.fields['city'] = cityController.text;
    request.fields['area'] = areaController.text;
    request.fields['pincode'] = pincodeController.text;

    // Mobile/Desktop file
    if (selectedImageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          selectedImageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    // Web file
    if (selectedImageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          selectedImageBytes!,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        submitMessage = "Form submitted successfully!";
        submitSuccess = true;
        _formKey.currentState!.reset();
        selectedImageFile = null;
        selectedImageBytes = null;
        selectedCategory = null;
        selectedState = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    } else {
      setState(() {
        submitMessage = "Failed to submit form. Status code: ${response.statusCode}";
        submitSuccess = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit form: ${response.statusCode}')),
      );
    }

    // Auto-hide the message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        submitMessage = null;
      });
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    cityController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (selectedImageBytes != null) {
      imageWidget = Image.memory(selectedImageBytes!, fit: BoxFit.cover);
    } else if (selectedImageFile != null) {
      imageWidget = Image.file(selectedImageFile!, fit: BoxFit.cover);
    } else {
      imageWidget = const Center(
        child: Icon(Icons.upload, color: Colors.white, size: 48),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC84C4C),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- SUBMIT MESSAGE ----------
                if (submitMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: submitSuccess ? Colors.green[400] : Colors.red[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      submitMessage!,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // ---------- TITLE ----------
                const Text("Title", style: TextStyle(color: Colors.white)),
                TextFormField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),

                // ---------- CATEGORY ----------
                _dropdownBox(
                  value: selectedCategory,
                  hint: "Category",
                  items: issueCategories,
                  onChanged: (val) => setState(() => selectedCategory = val),
                ),
                const SizedBox(height: 24),

                // ---------- IMAGE UPLOAD ----------
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: imageWidget,
                  ),
                ),
                const SizedBox(height: 20),

                // ---------- DESCRIPTION ----------
                const Text("Description", style: TextStyle(color: Colors.white)),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 20),

                // ---------- STATE ----------
                _dropdownBox(
                  value: selectedState,
                  hint: "State",
                  items: indianStates,
                  onChanged: (val) => setState(() => selectedState = val),
                ),
                const SizedBox(height: 16),

                _textField("City", cityController),
                _textField("Area", areaController),
                _textField("Pincode", pincodeController,
                    keyboard: TextInputType.number),
                const SizedBox(height: 30),

                // ---------- SUBMIT ----------
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await submitForm();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F0DB),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _dropdownBox({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F0DB),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
