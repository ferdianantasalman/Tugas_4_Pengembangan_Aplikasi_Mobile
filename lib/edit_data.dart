import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tugas_pertemuan_4/main.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  final List list;
  final int index;

  Edit({Key? key, required this.list, required this.index}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late TextEditingController title;
  late TextEditingController content;
  final home = Home();

  Future<void> editData() async {
    if (title.text.isNotEmpty && content.text.isNotEmpty) {
      var url = Uri.parse(
          'http://localhost/RestApi//update.php'); // Update API Calling
      final response = await http.post(url, body: {
        'id': widget.list[widget.index]['id'],
        'title': title.text,
        'content': content.text,
      });

      if (response.statusCode == 200) {
        // Jika data berhasil diperbarui
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil diperbarui'),
          ),
        );

        // Memanggil fungsi refreshData untuk memuat ulang data di halaman Home
        const Home().refreshData();

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } else {
        // Jika terjadi kesalahan dalam permintaan API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat mengedit data'),
          ),
        );
      }
    } else {
      // Jika inputan kosong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap isi kedua bidang input'),
        ),
      );
    }
  }

  @override
  void initState() {
    title = TextEditingController(text: widget.list[widget.index]['title']);
    content = TextEditingController(text: widget.list[widget.index]['content']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Data ${widget.list[widget.index]['title']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: title,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Title',
                hintText: 'Enter Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              maxLines: 5,
              controller: content,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Content',
                hintText: 'Enter Content',
                prefixIcon: Icon(Icons.text_snippet_outlined),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: MaterialButton(
              child: Text(
                "Edit Data",
                style: TextStyle(
                    // color: Colors.white,
                    ),
              ),
              color: Colors.amber,
              onPressed: () {
                editData();
              },
              height: 45,
            ),
          )
        ],
      ),
    );
  }
}
