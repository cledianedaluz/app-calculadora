import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String display = '0'; // Exibição atual na tela
  String userInput = ''; // Armazena a expressão do usuário

  // Função para atualizar a tela
  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        // Lógica para calcular a expressão
        try {
          // Usando o pacote math_expressions para avaliar a expressão
          Parser parser = Parser();
          Expression expression = parser.parse(userInput);
          double result =
              expression.evaluate(EvaluationType.REAL, ContextModel());
          display = result.toString();
        } catch (e) {
          display = 'Erro'; // Caso ocorra erro na expressão
        }
      } else if (buttonText == 'C') {
        // Limpar a tela
        userInput = '';
        display = '0';
      } else {
        // Atualizar a expressão do usuário com o botão pressionado
        userInput += buttonText;
        display = userInput;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenção das dimensões da tela para tornar o layout responsivo
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Aumentando o tamanho da calculadora
    double calculatorWidth = screenWidth * 0.4; // A largura agora é 40% da tela
    double calculatorHeight =
        screenHeight * 0.55; // A altura da calculadora é 55% da tela

    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Cor de fundo mais suave
      body: Center(
        child: Container(
          width: calculatorWidth,
          height: calculatorHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              // Tela de exibição dos resultados (ajuste no tamanho da fonte)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  display,
                  style: TextStyle(
                    fontSize: calculatorWidth *
                        0.15, // Tamanho da fonte ajustado para o display
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid de botões
              Expanded(
                child: GridView.builder(
                  itemCount: 16,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final buttonLabels = [
                      '7',
                      '8',
                      '9',
                      '/',
                      '4',
                      '5',
                      '6',
                      '*',
                      '1',
                      '2',
                      '3',
                      '-',
                      'C',
                      '0',
                      '=',
                      '+'
                    ];

                    // Verifica se o botão atual é o "C" (Limpar)
                    bool isClearButton = buttonLabels[index] == 'C';

                    return Container(
                      width: isClearButton
                          ? calculatorWidth * 0.85
                          : calculatorWidth * 0.4, // Botão "C" maior
                      child: ElevatedButton(
                        onPressed: () => buttonPressed(buttonLabels[index]),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          buttonLabels[index],
                          style: TextStyle(
                              fontSize: calculatorWidth *
                                  0.12), // Tamanho dos botões ajustado
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
