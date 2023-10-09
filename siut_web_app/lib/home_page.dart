import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siut_web_app/components/history_bar.dart';
import 'package:siut_web_app/data/api_service.dart';
import 'components/type_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  AnimationController? _controller;
  bool isSearching = false;
  bool isOutputReady = false;
  String output = "";
  final FocusNode searchTextFocus = FocusNode();
  final ApiService apiService = ApiService();
  List<String> queryPrompts = [
    "Show me the names and ages of all patients with diabetes.",
    "Retrieve the list of doctors who specialize in cardiology.",
    "Find the number of patients who visited the emergency department last month.",
    "List all the medications prescribed to patients with hypertension",
    "Retrieve the patient's information, including name, date of birth, and diagnosis, for the patient with ID 12345."
  ];
  String currentText = "";
  List<Map<String, String>> displayPrompts = [];

  Future<String> getOutput() async {
    String output = "";
    if (searchController.text ==
        "Show me the names and ages of all patients with diabetes.") {
      output = " SELECT Name, Age FROM Patients WHERE Diagnosis = 'Diabetes'";
    }
    if (searchController.text ==
        "Retrieve the list of doctors who specialize in cardiology.") {
      output = "SELECT Name FROM Doctors WHERE Specialty = 'Cardiology'";
    }
    if (searchController.text ==
        "Find the number of patients who visited the emergency department last month.") {
      output =
          "SELECT COUNT(*) FROM Visits WHERE Department = 'Emergency' AND Date >= '2023-09-01' AND Date < '2023-10-01'";
    }
    if (searchController.text ==
        "List all the medications prescribed to patients with hypertension") {
      output =
          "SELECT MedicationName FROM Prescriptions WHERE Diagnosis = 'Hypertension'";
    }
    if (searchController.text ==
        "Retrieve the patient's information, including name, date of birth, and diagnosis, for the patient with ID 12345.") {
      output =
          "SELECT Name, DateOfBirth, Diagnosis FROM Patients WHERE PatientID = 12345;";
    }
    else{
      Map<String, dynamic> response = await apiService.get(searchController.text);
      output = response['query']!;
    }
    return output;
  }

  void _handleKeyPress(RawKeyEvent event) async {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (searchTextFocus.hasFocus) {
          processQuery();
        }
      }
    }
  }

  void deleteQuery(int index) {
    queryPrompts.removeAt(index);
    setState(() {});
  }

  void editBtnClicked(String text) {
    searchController.text = text;
  }

  void processQuery() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isOutputReady = false;
      });
      queryPrompts.add(searchController.text);
      setState(() {
        isSearching = true;
      });
      // await Future.delayed(const Duration(milliseconds: 1000));
      output = await getOutput();
      setState(()  {
        isSearching = false;
        isOutputReady = true;
        currentText = searchController.text;
        if (output == "") {
          output = "No Query Generated for given plain text";
        }
        var currentMap = {
          'plain': searchController.text.toString(),
          'query': output
        };
        displayPrompts.add(currentMap);
      });
      searchController.text = "";
      output = "";
      setState(() {});
    }
  }

  @override
  void initState() {
    RawKeyboard.instance.addListener(_handleKeyPress);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 200),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double mobileWidth = MediaQuery.sizeOf(context).width;
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyPress,
      child: Scaffold(
        appBar: mobileWidth < 550
            ? AppBar(
                actions: [
                  TextButton(
                      onPressed: () {
                        displayPrompts.clear();
                        setState(() {});
                      },
                      child: const Text("Clear", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF12486B), fontWeight: FontWeight.bold),))
                ],
              )
            : null,
        drawer: Drawer(
          child: Container(
            width: 250.0, // Width of the sidebar
            color: const Color(0xFFF5FCCD), // White background color
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Search History',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_circle_left_outlined,
                                color: Color(0xFF419197),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ] +
                    List.generate(
                        queryPrompts.length,
                        (index) => HistoryBar(
                              onEdit: editBtnClicked,
                              onDelete: deleteQuery,
                              index: index,
                              text: queryPrompts[index],
                            )) + [
                              const SizedBox(height: 10,),
                              if (queryPrompts.isNotEmpty) Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle
                                ),
                                child: IconButton(icon: const Icon(Icons.delete, color: Colors.white, size: 15,), onPressed: (){
                                  queryPrompts.clear();
                                  setState(() {
                                  });
                                },),
                              )
                            ],
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF12486B),
        body: mobileWidth < 550
            ? Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.765,
                    child: ListView(
                      children: List.generate(
                              displayPrompts.length,
                              (index) => Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/user_icon.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                displayPrompts[index]['plain']!,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        displayPrompts[index]
                                                            ['query']! ==
                                                        "No Query Generated for given plain text"
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 32.0),
                                                        child: Text(
                                                          displayPrompts[index]
                                                              ['query']!,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 15,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    : 
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, right: 10, top: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF419197),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              displayPrompts[index]['query']!,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  )) +
                          [
                            if (isSearching)
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 30, top: 20),
                                child: TypingIndicator(
                                  controller: _controller!,
                                ),
                              ),
                          ],
                    ),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  Container(
                    width: 280.0,
                    color: const Color(0xFFF5FCCD),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
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
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  displayPrompts.clear();
                                  setState(() {});
                                },
                                child: const Text(
                                  "Clear",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins'),
                                ))),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.85,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ListView(
                              children: List.generate(
                                      displayPrompts.length,
                                      (index) => Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20, left: 30),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/user_icon.png',
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          displayPrompts[index]
                                                              ['plain']!,
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                displayPrompts[index]
                                                            ['query']! ==
                                                        "No Query Generated for given plain text"
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 90.0),
                                                        child: Text(
                                                          displayPrompts[index]
                                                              ['query']!,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 18,
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 15,
                                                                left: 80),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xFF419197),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Text(
                                                            displayPrompts[
                                                                    index]
                                                                ['query']!,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ],
                                            ),
                                          )) +
                                  [
                                    if (isSearching)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 30, top: 20),
                                        child: TypingIndicator(
                                          controller: _controller!,
                                        ),
                                      ),
                                  ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF419197),
                                borderRadius: BorderRadius.circular(20)),
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: searchTextFocus,
                                    controller: searchController,
                                    style: const TextStyle(
                                        color: Colors.white), // Text color
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Search in database', // Hint text
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          fontSize: 16), // Hint text color
                                      border: InputBorder.none, // No border
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: processQuery,
                                  icon: const Icon(
                                    Icons.send, // Message send icon
                                    color: Colors.white, // Icon color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
                ],
              ),
              bottomNavigationBar: MediaQuery.sizeOf(context).width < 550 ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
                    child: Container(
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontSize: 16), // Hint text color
                                border: InputBorder.none, // No border
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: processQuery,
                            icon: const Icon(
                              Icons.send, // Message send icon
                              color: Colors.white, // Icon color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : null,
      ),
    );
  }
}
