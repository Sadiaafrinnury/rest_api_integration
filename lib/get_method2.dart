import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rest_api_get_method2/model/model.dart';
import 'package:http/http.dart' as http;

class GetMethod2 extends StatefulWidget {
  const GetMethod2({super.key});

  @override
  State<GetMethod2> createState() => _GetMethod2State();
}

class _GetMethod2State extends State<GetMethod2> {
  List<PhotosModel> photosList = [];

  Future<List<PhotosModel>> getPhotos() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    if (response.statusCode == 200) {
      // Decode the response body
      var data = jsonDecode(response.body) as List;

      // Update the state variable directly
      photosList = data.map((photoData) => PhotosModel.fromJson(photoData)).toList();

      return photosList;
    } else {
      // Throw an exception if the response was not successful
      throw Exception("Failed to load photos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          "Example Two",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<PhotosModel>>(
        future: getPhotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No photos found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final photo = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10), // Add some margin around the card
                  elevation: 5, // Elevation for shadow effect
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Padding inside the card
                    child: Row(
                      children: [
                        Image.network(
                          photo.thumbnailUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10), // Space between image and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                photo.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2, // Limit title to 2 lines
                                overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ID: ${photo.id}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}




