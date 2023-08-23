

import 'package:flutter/material.dart';
import 'package:simple_calculator/screens/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen ({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "" ;
  String operand = "" ;
  String number2 = "" ;

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return  Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Align(
                  alignment: Alignment.topRight, // Adjust the alignment as needed
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
                    child: Text(
                      "$number1$operand$number2".isEmpty
                          ?"0"
                      :"$number1$operand$number2",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ),

            // buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: 90,
                        height: value==Btn.calculate?40:70,
                        child: buildButton(value),
                    ),
              )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
       // color: getBtnColor(value) ,
        clipBehavior: Clip.hardEdge,
        // shape: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.white24),
        //   borderRadius: BorderRadius.circular(100) ,
        // ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
                value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ) ,
          ),
        ),
      ),
    );
  }

  // ####
  void onBtnTap (String value){
    if(value== Btn.del){
      delete() ;
      return ;
    }
    if(value== Btn.clr){
      clearAll() ;
      return ;
    }
    if(value== Btn.per){
      convertToPercentage() ;
      return ;
    }
    if(value== Btn.calculate){
      calculate() ;
      return ;
    }
    appendValue(value) ;
  }
  // ######
  // calculate the result
  void calculate (){
    if(number1.isEmpty) return ;
    if(operand.isEmpty) return ;
    if(number2.isEmpty) return ;

    final double num1 = double.parse(number1) ;
    final double num2 = double.parse(number2) ;

    var result = 0.0 ;
    switch(operand){
      case Btn.add:
        result = num1 + num2 ;
        break ;
      case Btn.subtract:
        result = num1 - num2 ;
        break ;
      case Btn.multiply:
        result = num1 * num2 ;
        break ;
      case Btn.divide:
        result = num1 / num2 ;
        break ;
      default:
    }
    setState(() {
      number1 = "$result" ;
      if(number1.endsWith(".0")){
        number1 = number1.substring(0, number1.length -1) ;
      }
      operand = "" ;
      number2 = "" ;
    });
  }
  // ########
  // converts output to percentage
  void convertToPercentage(){
    // ex: 234 + 324
    if(number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty){
      // calculate before conversion
      // To do
      // final res = number1 operand number2 ;
      // number1 = res ;
    }
    if(operand.isNotEmpty){
      // can not be converted
      return ;
    }
    final number = double.parse(number1) ;
    setState(() {
      number1 = "${(number / 100)}" ;
      operand = "" ;
      number2 = "" ;
    });
  }
  //#######
  //clear all output
  void clearAll(){
    setState(() {
      number1 = "" ;
      operand = "" ;
      number2 = "" ;
    });
  }
  //#######
  // deleter one from he end
  void delete (){
    if(number2.isNotEmpty){
      // 12345 => 1234
      number2 = number2.substring(0, number2.length -1) ;
    }
    else if (operand.isNotEmpty){
      operand = "" ;
    }
    else if(number1.isNotEmpty){
      // 12345 => 1234
      number1 = number1.substring(0, number1.length -1) ;
    }
    setState(() {

    });
  }
  // #####
  // append value to the end
  void appendValue (String value){
    // number1 operand number2
    // // 2      +        3
    // if is operand and not dot
    if(value!=Btn.dot && int.tryParse(value)==null){
      if(operand.isNotEmpty && number2.isNotEmpty){
        // calculate the equation before assigning new operand
        calculate() ;

      }
      operand = value ;
    }
    // assign value to number1 variable
    else if(number1.isEmpty || operand.isEmpty) {
      // check if value is dot || number = 1.2
      if(value== Btn.dot && number1.contains(Btn.dot)) return;
      if(value== Btn.dot && number1.isEmpty || number1==Btn.n0) {
        // number 1 = " " || "0"
        value = "0.0" ;
      }
      number1 += value ;
    }
    // assign value to number2 variable
    else if(number2.isEmpty || operand.isNotEmpty) {
      // check if value is dot || number = 1.2
      if(value== Btn.dot && number2.contains(Btn.dot)) return;
      if(value== Btn.dot && number2.isEmpty || number2==Btn.n0) {
        // number 1 = " " || "0"
        value = "0." ;
      }
      number2 += value ;
    }

    setState(() {});
  }

  // ####
  //  Color getBtnColor(value){
  //    return [Btn.del, Btn.clr].contains(value)
  //       ?Colors.blueGrey
  //       :[
  //     Btn.per,
  //     Btn.multiply,
  //     Btn.b1,
  //     Btn.b2,
  //     Btn.divide,
  //     Btn.add,
  //     Btn.subtract,
  //     Btn.calculate
  //   ].contains(value)
  //       ?Colors.blueGrey
  //       :Colors.blueGrey ;
  //
  //  }
}
