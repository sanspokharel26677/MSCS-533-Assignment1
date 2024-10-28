import 'package:flutter/material.dart';

// Entry point of the Flutter application
void main() {
  runApp(MeasuresConverterApp()); // Start the app by running the MeasuresConverterApp widget
}

/// Main application widget that sets up the app-level configurations
class MeasuresConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.lightBlue, // Set the primary color theme to light blue
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue), // Border color for enabled input fields
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue, width: 2.0), // Border color when focused
          ),
        ),
      ),
      home: MeasuresConverterScreen(), // Set the initial screen to MeasuresConverterScreen
    );
  }
}

/// Stateful widget for the Measures Converter screen
/// It allows the user to input a value, select the units to convert from and to, and display the result
class MeasuresConverterScreen extends StatefulWidget {
  @override
  _MeasuresConverterScreenState createState() => _MeasuresConverterScreenState();
}

/// State class for MeasuresConverterScreen
/// Manages the input value, selected units, and the conversion logic
class _MeasuresConverterScreenState extends State<MeasuresConverterScreen> {
  // Controller to capture the user input from the TextField
  final TextEditingController _valueController = TextEditingController();

  // Variables to hold the selected units for conversion
  String _fromUnit = 'meters';
  String _toUnit = 'feet';

  // Variable to store the conversion result for display
  String _result = '';

  // Conversion factors for different units relative to meters
  final Map<String, double> _conversionFactors = {
    'meters': 1.0,
    'feet': 3.28084,
    'kilometers': 0.001,
    'miles': 0.000621371,
  };

  /// Function to perform the unit conversion
  /// It calculates the converted value based on the user input and selected units
  void _convert() {
    // Try to parse the user input as a double, default to 0.0 if invalid
    double inputValue = double.tryParse(_valueController.text) ?? 0.0;

    // Get the conversion factors for the selected units
    double fromFactor = _conversionFactors[_fromUnit] ?? 1.0;
    double toFactor = _conversionFactors[_toUnit] ?? 1.0;

    // Calculate the converted value
    double convertedValue = inputValue * (toFactor / fromFactor);

    // Update the result with the formatted output
    setState(() {
      _result = '$inputValue $_fromUnit are ${convertedValue.toStringAsFixed(3)} $_toUnit';
    });
  }

  @override
  void dispose() {
    // Dispose of the TextEditingController when the widget is removed from the widget tree
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic visual structure for the app
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Measures Converter', // Title in the app bar
          style: TextStyle(color: Colors.white), // Set the font color to white
        ),
        backgroundColor: Colors.lightBlue, // Set the app bar color to light blue
        centerTitle: true, // Center the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Set padding for the screen content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align elements to the start
          children: [
            // Label for the value input
            const Text(
              'Value',
              style: TextStyle(fontSize: 18),
            ),
            // Input field for entering the value
            TextField(
              controller: _valueController, // Link the controller
              keyboardType: TextInputType.number, // Set input type to numbers
              decoration: const InputDecoration(
                hintText: 'Enter value', // Placeholder text for the input
              ),
            ),
            const SizedBox(height: 20), // Space between elements

            // Label for the "From" dropdown
            const Text(
              'From',
              style: TextStyle(fontSize: 18),
            ),
            // Dropdown for selecting the unit to convert from
            SizedBox(
              width: double.infinity, // Extend to the full width
              child: DropdownButton<String>(
                value: _fromUnit, // Current selected unit
                isExpanded: true, // Make the dropdown extend full width
                items: _conversionFactors.keys
                    .map((String unit) => DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit), // Display the unit name
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  // Update the state with the newly selected unit
                  setState(() {
                    _fromUnit = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20), // Space between elements

            // Label for the "To" dropdown
            const Text(
              'To',
              style: TextStyle(fontSize: 18),
            ),
            // Dropdown for selecting the unit to convert to
            SizedBox(
              width: double.infinity, // Extend to the full width
              child: DropdownButton<String>(
                value: _toUnit, // Current selected unit
                isExpanded: true, // Make the dropdown extend full width
                items: _conversionFactors.keys
                    .map((String unit) => DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit), // Display the unit name
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  // Update the state with the newly selected unit
                  setState(() {
                    _toUnit = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20), // Space between elements

            // Button to perform the conversion, centered on the screen
            Center(
              child: ElevatedButton(
                onPressed: _convert, // Trigger the _convert function on press
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300], // Set button background to silverish color
                  foregroundColor: Colors.blue, // Set the font color to blueish
                ),
                child: const Text('Convert'),
              ),
            ),
            const SizedBox(height: 20), // Space between elements

            // Centered Text widget to display the conversion result
            Center(
              child: Text(
                _result, // Display the conversion result
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
