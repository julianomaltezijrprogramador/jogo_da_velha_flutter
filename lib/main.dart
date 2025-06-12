// Importações necessárias
import 'dart:math';
import 'package:flutter/material.dart';

// Constantes do jogo - Definidas globalmente para fácil manutenção
const String tituloApp = 'Jogo da Velha';
const Color corPrimaria = Colors.deepPurple; // Pode ser alterada para personalizar o tema
const Color corFundoCelula = Colors.white;
const double tamanhoFonteCelula = 40.0;
const double tamanhoFonteBotao = 32.0;
const double tamanhoFonteStatus = 20.0;
const double tamanhoFonteResultado = 32.0;

// Função principal que inicia o aplicativo
void main() {
  runApp(const AplicativoPrincipal());
}

// Widget principal do aplicativo
// Obs: StatelessWidget é usado pois não precisamos gerenciar estado neste nível
class AplicativoPrincipal extends StatelessWidget {
  const AplicativoPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tituloApp,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: corPrimaria),
        useMaterial3: true, // Habilita o Material Design 3
      ),
      home: const TelaInicial(),
    );
  }
}

// Tela inicial onde o jogador escolhe seu símbolo (X ou O)
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(tituloApp),
        centerTitle: true,
        backgroundColor: corPrimaria,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Escolha seu símbolo:',
              style: TextStyle(fontSize: tamanhoFonteStatus, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _criarBotaoSimbolo(context, 'X', Colors.black),
                const SizedBox(width: 40),
                _criarBotaoSimbolo(context, 'O', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Cria botão personalizado para seleção do símbolo
  // Parâmetros:
  // - context: Contexto do Flutter para navegação
  // - simbolo: 'X' ou 'O'
  // - corTexto: Cor do símbolo
  Widget _criarBotaoSimbolo(BuildContext context, String simbolo, Color corTexto) {
    return ElevatedButton(
      onPressed: () {
        // Navega para a tela do jogo passando o símbolo escolhido
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JogoDaVelha(simboloJogador: simbolo),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: corFundoCelula,
        minimumSize: const Size(100, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        simbolo,
        style: TextStyle(fontSize: tamanhoFonteBotao, color: corTexto),
      ),
    );
  }
}

// Enum para gerenciar o jogador atual (equivalente a um tipo enumerado no Delphi)
enum Player { user, ai }

// Tela principal do jogo (equivalente a um Form de jogo no Delphi)
class JogoDaVelha extends StatefulWidget {
  final String simboloJogador;

  const JogoDaVelha({super.key, required this.simboloJogador});

  @override
  State<JogoDaVelha> createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  late List<String> _tabuleiro; // Tabuleiro 3x3
  late String _simboloJogador; // Símbolo do usuário
  late String _simboloIA; // Símbolo da IA
  late Player _jogadorAtual; // Jogador atual
  bool _jogoIniciado = false; // Estado do jogo
  bool _jogoTerminado = false; // Jogo terminado
  String _mensagemStatus = ''; // Mensagem de status
  int _vitorias = 0; // Contador de vitórias
  int _derrotas = 0; // Contador de derrotas
  List<int>? _linhaVencedora; // Combinação vencedora (para desenhar a linha)

  // Combinações vencedoras (equivalente a uma constante de array no Delphi)
  static const List<List<int>> _combinacoesVencedoras = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
    [0, 4, 8], [2, 4, 6], // Diagonais
  ];

  @override
  void initState() {
    super.initState();
    _inicializarJogo();
  }

  // Inicializa o jogo (equivalente a um OnCreate no Delphi)
  void _inicializarJogo() {
    _simboloJogador = widget.simboloJogador;
    _simboloIA = _simboloJogador == 'X' ? 'O' : 'X';
    _tabuleiro = List.filled(9, '');
    _jogoIniciado = true;
    _jogoTerminado = false;
    _mensagemStatus = 'Jogo iniciado!';
    _linhaVencedora = null;
    _jogadorAtual = Random().nextBool() ? Player.user : Player.ai;
    if (_jogadorAtual == Player.ai) {
      _mensagemStatus = 'A IA começa jogando';
      Future.delayed(const Duration(milliseconds: 500), _jogadaIA);
    } else {
      _mensagemStatus = 'Você começa jogando';
    }
  }

  // Processa jogada do usuário (equivalente a um evento OnClick no Delphi)
  void _jogadaUsuario(int indice) {
    if (_tabuleiro[indice] != '' || _jogoTerminado || !_jogoIniciado || _jogadorAtual != Player.user) return;

    setState(() {
      _tabuleiro[indice] = _simboloJogador;
    });

    _verificarFimDeJogo();
    if (!_jogoTerminado) {
      _trocarJogador();
      Future.delayed(const Duration(milliseconds: 500), _jogadaIA);
    }
  }

  // Processa jogada da IA
  void _jogadaIA() {
    if (_jogoTerminado) return;

    int? jogada = _encontrarMelhorJogada(_simboloIA) ?? _encontrarMelhorJogada(_simboloJogador) ?? _tabuleiro.indexWhere((celula) => celula == '');
    if (jogada == -1) return;

    setState(() {
      _tabuleiro[jogada] = _simboloIA;
    });

    _verificarFimDeJogo();
    if (!_jogoTerminado) _trocarJogador();
  }

  // Encontra a melhor jogada para ganhar ou bloquear
  int? _encontrarMelhorJogada(String simbolo) {
    for (var combinacao in _combinacoesVencedoras) {
      final valores = combinacao.map((i) => _tabuleiro[i]).toList();
      if (valores.where((v) => v == simbolo).length == 2 && valores.contains('')) {
        return combinacao[valores.indexOf('')];
      }
    }
    return null;
  }

  // Troca o jogador atual
  void _trocarJogador() {
    setState(() {
      _jogadorAtual = _jogadorAtual == Player.user ? Player.ai : Player.user;
      _mensagemStatus = _jogadorAtual == Player.user ? 'Sua vez' : 'Vez da IA';
    });
  }

  // Verifica se o jogo terminou
  void _verificarFimDeJogo() {
    for (var combinacao in _combinacoesVencedoras) {
      if (_tabuleiro[combinacao[0]] != '' &&
          _tabuleiro[combinacao[0]] == _tabuleiro[combinacao[1]] &&
          _tabuleiro[combinacao[1]] == _tabuleiro[combinacao[2]]) {
        _jogoTerminado = true;
        _linhaVencedora = combinacao; // Armazena a combinação vencedora
        if (_tabuleiro[combinacao[0]] == _simboloJogador) {
          _vitorias++;
          _mensagemStatus = 'Você ganhou!';
        } else {
          _derrotas++;
          _mensagemStatus = 'Você perdeu!';
        }
        return;
      }
    }
    if (!_tabuleiro.contains('')) {
      _jogoTerminado = true;
      _mensagemStatus = 'Empate!';
    }
  }

  // Reinicia o jogo (equivalente a um botão de reset no Delphi)
  void _reiniciarJogo() {
    setState(() {
      _tabuleiro = List.filled(9, '');
      _jogoTerminado = false;
      _jogoIniciado = true;
      _mensagemStatus = 'Jogo reiniciado!';
      _linhaVencedora = null;
      _jogadorAtual = Random().nextBool() ? Player.user : Player.ai;
      if (_jogadorAtual == Player.ai) {
        _mensagemStatus = 'A IA começa jogando';
        Future.delayed(const Duration(milliseconds: 500), _jogadaIA);
      } else {
        _mensagemStatus = 'Você começa jogando';
      }
    });
  }

  // Constrói uma célula do tabuleiro
  Widget _construirCelula(int indice) {
    final simbolo = _tabuleiro[indice];
    return GestureDetector(
      onTap: () => _jogadaUsuario(indice),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: corPrimaria),
          color: corFundoCelula,
        ),
        child: Center(
          child: Text(
            simbolo,
            style: TextStyle(
              fontSize: tamanhoFonteCelula,
              fontWeight: FontWeight.bold,
              color: simbolo == 'X' ? Colors.black : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  // Constrói o tabuleiro 3x3 com a linha vencedora
  Widget _construirTabuleiro() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: 9,
            itemBuilder: (context, indice) => _construirCelula(indice),
          ),
          if (_linhaVencedora != null)
            CustomPaint(
              painter: WinningLinePainter(linhaVencedora: _linhaVencedora!),
              size: Size.infinite,
            ),
        ],
      ),
    );
  }

  // Constrói a interface do jogo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(tituloApp),
        centerTitle: true,
        backgroundColor: corPrimaria,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _mensagemStatus,
              style: const TextStyle(fontSize: tamanhoFonteStatus),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(child: _construirTabuleiro()),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Vitórias: ', style: TextStyle(fontSize: 18)),
                Text('$_vitorias', style: const TextStyle(fontSize: 18, color: Colors.green)),
                const SizedBox(width: 16),
                const Text('Derrotas: ', style: TextStyle(fontSize: 18)),
                Text('$_derrotas', style: const TextStyle(fontSize: 18, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 16),
            if (_jogoTerminado)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _mensagemStatus,
                        style: const TextStyle(
                          fontSize: tamanhoFonteResultado,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _reiniciarJogo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: corPrimaria,
                          minimumSize: const Size(220, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Reiniciar Partida',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Desenha a linha sobre a combinação vencedora (equivalente a desenhar em um TCanvas no Delphi)
class WinningLinePainter extends CustomPainter {
  final List<int> linhaVencedora;

  WinningLinePainter({required this.linhaVencedora});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    // Calcula as coordenadas das células no tabuleiro
    final larguraCelula = size.width / 3;
    final alturaCelula = size.height / 3;

    // Mapeia índices para coordenadas do centro das células
    Offset getCelulaCentro(int index) {
      final linha = index ~/ 3;
      final coluna = index % 3;
      return Offset(
        coluna * larguraCelula + larguraCelula / 2,
        linha * alturaCelula + alturaCelula / 2,
      );
    }

    // Define os pontos inicial e final da linha
    final inicio = getCelulaCentro(linhaVencedora[0]);
    final fim = getCelulaCentro(linhaVencedora[2]);

    // Desenha a linha
    canvas.drawLine(inicio, fim, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}