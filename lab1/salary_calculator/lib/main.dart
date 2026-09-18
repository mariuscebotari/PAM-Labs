import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SalaryCalculator()));
}

class SalaryCalculator extends StatefulWidget {
  const SalaryCalculator({super.key});

  @override
  State<SalaryCalculator> createState() => _SalaryCalculatorState();
}

class _SalaryCalculatorState extends State<SalaryCalculator> {
  // 1. Controller for reading gross salary from TextField
  final TextEditingController grossController = TextEditingController();

  // 2. Calculation variables
  double taxRate = 0.20; // Default 20%
  double taxAmount = 0;
  double netSalary = 0;

  // 3. Calculation function
  void calculateSalary() {
    double gross = double.tryParse(grossController.text) ?? 0;
    setState(() {
      taxAmount = gross * taxRate;
      netSalary = gross - taxAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salary Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // INPUT: Gross salary
            TextField(
              controller: grossController,
              decoration: const InputDecoration(
                labelText: 'Enter gross salary',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // UI CONTROL 1: RadioGroup for selecting tax rate
            RadioGroup<double>(
              groupValue: taxRate,
              onChanged: (val) {
                if (val != null) {
                  setState(() => taxRate = val);
                }
              },
              child: const Column(
                children: [
                  RadioListTile<double>(
                    title: Text('Standard (20% tax)'),
                    value: 0.20,
                  ),
                  RadioListTile<double>(
                    title: Text('Reduced (10% tax)'),
                    value: 0.10,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // UI CONTRoL 2: ElevatedButton to trigger calculation
            ElevatedButton(
              onPressed: calculateSalary,
              child: const Text('Calculate'),
            ),

            const SizedBox(height: 20),

            // OUTPUT: Net salary and tax amount
            Text('Tax amount: ${taxAmount.toStringAsFixed(2)}'),
            Text('Net salary: ${netSalary.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
