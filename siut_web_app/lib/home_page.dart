import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siut_web_app/components/history_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  List<String> queryPrompts = [];

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (event.isShiftPressed) {
          setState(() {
            searchController.text += '\n';
            searchController.selection = TextSelection.collapsed(
                offset: searchController.text.length); 
          });
        } else {
          if (searchController.text.isNotEmpty) {
            queryPrompts.add(searchController.text);
            searchController.text = "";
            setState(() {});
          }
        }
      }
    }
  }

  void deleteQuery(int index) {
    queryPrompts.removeAt(index);
    setState(() {});
  }

  void editBtnClicked(String text){
    searchController.text = text;
  }

  @override
  void initState() {
    RawKeyboard.instance.addListener(_handleKeyPress);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyPress,
      child: Scaffold(
        backgroundColor: const Color(0xFF12486B),
        body: Row(
          children: <Widget>[
            Container(
              width: 280.0, // Width of the sidebar
              color: const Color(0xFFF5FCCD), // White background color
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Your Search History',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ] +
                      List.generate(
                          queryPrompts.length,
                          (index) => HistoryBar(
                                onEdit: editBtnClicked,
                                onDelete: deleteQuery,
                                index: index,
                                text: queryPrompts[index],
                              )),
                ),
              ),
            ),
            // Main content
            Expanded(
                child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.90,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF419197),
                      borderRadius: BorderRadius.circular(20)),
                  width: 500,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(
                              color: Colors.white), // Text color
                          decoration: const InputDecoration(
                            hintText: 'Search in database', // Hint text
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 16), // Hint text color
                            border: InputBorder.none, // No border
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Add your send message logic here
                          queryPrompts.add(searchController.text);
                          searchController.text = "";
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.send, // Message send icon
                          color: Colors.white, // Icon color
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}


