
// A importação 'dart:math' é usada aqui especificamente para a função Random(),
// que nos permite sortear quem começa o jogo (o usuário ou a IA).
import 'dart:math';

// A importação 'package:flutter/material.dart' é o coração do Flutter.
// Ela contém todos os widgets e ferramentas visuais (como Text, Scaffold, Color, etc.)
// que usamos para construir a interface do aplicativo.
import 'package:flutter/material.dart';

// --- Constantes Globais do Jogo ---
// Manter constantes em um só lugar facilita a manutenção e a alteração de
// valores que se repetem pelo código, como cores e tamanhos de fonte.
const tituloAplicativo = 'Jogo da Velha';
const corPrincipal = Colors.deepPurple;
const corFundoCelula = Colors.white;
const tamanhoFonteCelula = 40.0;
const tamanhoFonteBotao = 32.0;
const tamanhoFonteStatus = 20.0;
const tamanhoFonteResultado = 32.0;

// A função main() é o ponto de entrada de qualquer aplicativo Dart/Flutter.
// É a primeira coisa que é executada.
// runApp() infla o widget principal (neste caso, 'MeuAplicativo') e o anexa à tela.
void main() {
  runApp(const MeuAplicativo());
}

// StatelessWidget é um widget que não tem um estado mutável. Uma vez construído,
// ele não muda. Perfeito para a estrutura principal do app.
class MeuAplicativo extends StatelessWidget {
  // O construtor 'const' indica que este widget pode ser otimizado pelo compilador,
  // pois seus valores são definidos em tempo de compilação.
  const MeuAplicativo({super.key});

  // O método build() é onde a interface do widget é descrita.
  // Ele retorna a árvore de widgets que compõe a UI.
  @override
  Widget build(BuildContext context) {
    // MaterialApp é um widget essencial que fornece muitas funcionalidades
    // necessárias para um aplicativo, como navegação (rotas), tema, etc.
    return MaterialApp(
      title: tituloAplicativo, // Título usado pelo sistema operacional.
      theme: ThemeData(
        // Define o tema visual do aplicativo.
        colorScheme: ColorScheme.fromSeed(seedColor: corPrincipal),
        //useMaterial3: true, // Habilita o design mais moderno do Material Design 3.
      ),
      home: const TelaInicial(), // Define a primeira tela a ser exibida.
      debugShowCheckedModeBanner: false, // Remove o banner "Debug" no canto da tela.
    );
  }
}

// --- Tela de Seleção de Símbolo ('X' ou 'O') ---
// Esta tela é um StatelessWidget porque ela apenas exibe opções e navega para
// a próxima tela, sem precisar gerenciar nenhum estado interno que mude com o tempo.
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold é um layout básico do Material Design. Ele fornece uma estrutura
    // padrão com AppBar, Body, FloatingActionButton, etc.
    return Scaffold(
      appBar: AppBar(
        title: const Text(tituloAplicativo),
        centerTitle: true, // Centraliza o título na AppBar.
        backgroundColor: corPrincipal, // Cor de fundo da AppBar.
        foregroundColor: Colors.white, // Cor do texto e ícones na AppBar.
      ),
      body: Center(
        // Center alinha seu widget filho no centro da área disponível.
        child: Column(
          // Column organiza seus filhos em uma coluna vertical.
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza a coluna verticalmente.
          children: [
            const Text(
              'Escolha seu símbolo:',
              style: TextStyle(fontSize: tamanhoFonteStatus, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32), // Usado para criar um espaço vertical.
            Row(
              // Row organiza seus filhos em uma linha horizontal.
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza a linha horizontalmente.
              children: [
                _botaoEscolhaSimbolo(context, 'X', Colors.black),
                const SizedBox(width: 40), // Espaço horizontal entre os botões.
                _botaoEscolhaSimbolo(context, 'O', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método privado para criar os botões de escolha.
  // Extrair a lógica de criação de um widget para um método ajuda a manter
  // o método build() mais limpo e legível.
  Widget _botaoEscolhaSimbolo(BuildContext context, String simbolo, Color corTexto) {
    return ElevatedButton(
      onPressed: () {
        // Navigator.push() é como o Flutter lida com a navegação entre telas.
        // Ele "empurra" uma nova rota (tela) para a pilha de navegação.
        Navigator.push(
          context,
          MaterialPageRoute(
            // O builder cria a próxima tela, passando o símbolo escolhido como parâmetro.
            builder: (context) => JogoDaVelhaTela(simboloUsuario: simbolo),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        // Define a aparência do botão.
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

// Enum para representar os jogadores. Usar um enum torna o código mais legível
// e seguro do que usar strings ou inteiros (ex: `currentPlayer = "user"`).
enum Jogador { usuario, ia }

// --- Tela Principal do Jogo ---
// StatefulWidget é usado aqui porque a tela do jogo precisa gerenciar estados
// que mudam durante a partida, como o tabuleiro, o jogador atual, o placar, etc.
class JogoDaVelhaTela extends StatefulWidget {
  final String simboloUsuario; // Recebe o símbolo escolhido na tela anterior.

  const JogoDaVelhaTela({super.key, required this.simboloUsuario});

  // createState() cria o objeto de estado associado a este widget.
  // A lógica do jogo ficará na classe _JogoDaVelhaTelaState.
  @override
  State<JogoDaVelhaTela> createState() => _JogoDaVelhaTelaState();
}

// O State é a classe que contém a lógica e os dados mutáveis para um StatefulWidget.
// O underscore (_) no início do nome da classe a torna privada para este arquivo.
class _JogoDaVelhaTelaState extends State<JogoDaVelhaTela> {
  // --- Variáveis de Estado ---
  // A palavra-chave 'late' indica que a variável será inicializada mais tarde,
  // mas antes de ser usada pela primeira vez (neste caso, em initState).
  late List<String> _tabuleiro; // Lista de 9 strings para representar o tabuleiro.
  late String _simboloUsuario; // Símbolo do usuário ('X' ou 'O').
  late String _simboloIA; // Símbolo da IA (o oposto do usuário).
  late Jogador _jogadorAtual; // Quem tem a vez de jogar.
  bool _jogoFinalizado = false; // Flag para indicar se o jogo acabou.
  String _mensagemStatus = ''; // Mensagem exibida para o usuário (ex: "Sua vez").
  int _vitorias = 0; // Contador de vitórias do usuário.
  int _derrotas = 0; // Contador de derrotas do usuário.
  List<int>? _linhaVencedora; // Armazena os índices da linha vencedora para desenhá-la.

  // Uma lista constante de todas as combinações de vitória possíveis no jogo da velha.
  // Cada sublista contém os 3 índices do tabuleiro que formam uma linha.
  static const List<List<int>> _combinacoesVitoria = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
    [0, 4, 8], [2, 4, 6], // Diagonais
  ];

  // initState() é chamado uma única vez quando o widget é inserido na árvore de widgets.
  // É o lugar perfeito para inicializar dados, listeners, etc.
  @override
  void initState() {
    super.initState();
    _inicializarJogo();
  }

  // Método para configurar ou resetar o estado inicial do jogo.
  void _inicializarJogo() {
    // Acessamos a propriedade do widget pai (JogoDaVelhaTela) usando 'widget'.
    _simboloUsuario = widget.simboloUsuario;
    _simboloIA = _simboloUsuario == 'X' ? 'O' : 'X'; // Define o símbolo da IA.

    // Cria o tabuleiro como uma lista de 9 posições vazias.
    _tabuleiro = List.filled(9, '');
    _jogoFinalizado = false;
    _linhaVencedora = null;

    // Sorteia quem começa a partida.
    _jogadorAtual = Random().nextBool() ? Jogador.usuario : Jogador.ia;

    if (_jogadorAtual == Jogador.ia) {
      _mensagemStatus = 'A IA começa jogando';
      // Future.delayed é usado para dar um pequeno atraso antes da jogada da IA,
      // para que a jogada não seja instantânea e o usuário perceba o que aconteceu.
      Future.delayed(const Duration(milliseconds: 500), _jogadaDaIA);
    } else {
      _mensagemStatus = 'Você começa jogando';
    }
  }

  // Este método é chamado sempre que o usuário toca em uma célula.
  void _jogadaDoUsuario(int indice) {
    // Condições de guarda: a função retorna imediatamente se...
    // a célula já estiver preenchida, ou
    // o jogo já tiver terminado, ou
    // não for a vez do usuário.
    // Isso previne jogadas inválidas.
    if (_tabuleiro[indice] != '' || _jogoFinalizado || _jogadorAtual != Jogador.usuario) {
      return;
    }

    // setState() é o método mais importante em um StatefulWidget. Ele notifica o Flutter
    // que o estado interno mudou, e que a UI precisa ser reconstruída (o método build será chamado novamente)
    // para refletir essa mudança.
    setState(() {
      _tabuleiro[indice] = _simboloUsuario;
    });

    _verificarFimDeJogo();
    if (!_jogoFinalizado) {
      _alternarJogador();
      Future.delayed(const Duration(milliseconds: 500), _jogadaDaIA);
    }
  }

  // Lógica da Inteligência Artificial.
  void _jogadaDaIA() {
    if (_jogoFinalizado) return;

    // A estratégia da IA é simples, mas eficaz para um jogo básico:
    // 1. Tenta vencer: Procura uma jogada que complete uma linha para a IA.
    // 2. Tenta bloquear: Procura uma jogada que impeça o usuário de vencer na próxima rodada.
    // 3. Joga no primeiro espaço vazio: Se nenhuma das anteriores for possível, joga no primeiro espaço disponível.
    //
    // SUGESTÃO DE MELHORIA: Para uma IA "imbatível", poderia ser implementado o algoritmo Minimax.
    // Ele explora todas as jogadas possíveis e escolhe a que maximiza suas chances de vitória.
    int? melhorJogada = _encontrarJogadaEstrategica(_simboloIA) ?? // 1. Tenta vencer
                         _encontrarJogadaEstrategica(_simboloUsuario) ?? // 2. Tenta bloquear
                         _encontrarPrimeiraJogadaVazia(); // 3. Pega o que estiver disponível

    if (melhorJogada != -1) {
      setState(() {
        _tabuleiro[melhorJogada] = _simboloIA;
      });

      _verificarFimDeJogo();
      if (!_jogoFinalizado) {
        _alternarJogador();
      }
    }
  }
  
  // Função auxiliar para encontrar a primeira célula vazia.
  int _encontrarPrimeiraJogadaVazia() {
      // indexWhere retorna o índice do primeiro elemento que satisfaz a condição.
      // Se nenhum for encontrado, retorna -1.
    return _tabuleiro.indexWhere((celula) => celula == '');
  }

  // Lógica para encontrar uma jogada de vitória ou de bloqueio.
  int? _encontrarJogadaEstrategica(String simbolo) {
    for (var combinacao in _combinacoesVitoria) {
      // Para cada combinação de vitória, pega os valores atuais do tabuleiro.
      final valores = combinacao.map((i) => _tabuleiro[i]).toList();
      
      // Verifica se a combinação tem DUAS casas preenchidas pelo símbolo em questão
      // E UMA casa vazia.
      if (valores.where((v) => v == simbolo).length == 2 && valores.contains('')) {
        // Se sim, retorna o índice da casa vazia, que é a jogada estratégica.
        return combinacao[valores.indexOf('')];
      }
    }
    // Se nenhuma jogada estratégica for encontrada, retorna null.
    return null;
  }

  // Alterna o jogador atual e atualiza a mensagem de status.
  void _alternarJogador() {
    setState(() {
      _jogadorAtual = (_jogadorAtual == Jogador.usuario) ? Jogador.ia : Jogador.usuario;
      _mensagemStatus = (_jogadorAtual == Jogador.usuario) ? 'Sua vez' : 'Vez da IA';
    });
  }

  // Verifica se houve um vencedor ou se o jogo empatou.
  void _verificarFimDeJogo() {
    // 1. Verificar vitória
    for (var combinacao in _combinacoesVitoria) {
      String valor1 = _tabuleiro[combinacao[0]];
      String valor2 = _tabuleiro[combinacao[1]];
      String valor3 = _tabuleiro[combinacao[2]];

      // Se a primeira casa não está vazia e todas as três são iguais...
      if (valor1 != '' && valor1 == valor2 && valor2 == valor3) {
        setState(() {
          _jogoFinalizado = true;
          _linhaVencedora = combinacao; // Armazena a linha para ser desenhada na UI.
          if (valor1 == _simboloUsuario) {
            _vitorias++;
            _mensagemStatus = 'Você ganhou!';
          } else {
            _derrotas++;
            _mensagemStatus = 'Você perdeu!';
          }
        });
        return; // Sai da função, pois o jogo acabou.
      }
    }

    // 2. Verificar empate
    // Se não houve vencedor e o tabuleiro não contém mais casas vazias...
    if (!_jogoFinalizado && !_tabuleiro.contains('')) {
      setState(() {
        _jogoFinalizado = true;
        _mensagemStatus = 'Empate!';
      });
    }
  }

  // Reinicia o jogo, mantendo o placar de vitórias e derrotas.
  void _reiniciarPartida() {
    setState(() {
      // Chama a mesma função de inicialização, que reseta todas as variáveis de estado da partida.
      _inicializarJogo();
    });
  }
  
  // --- Métodos de Construção da UI ---

  // Constrói uma única célula (quadrado) do tabuleiro.
  Widget _construirCelula(int indice) {
    final simbolo = _tabuleiro[indice];
    return GestureDetector(
      // GestureDetector é um widget que detecta gestos, como toques.
      onTap: () => _jogadaDoUsuario(indice),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: corPrincipal.withOpacity(0.5)), // Borda da célula
          color: corFundoCelula,
        ),
        child: Center(
          child: Text(
            simbolo,
            style: TextStyle(
              fontSize: tamanhoFonteCelula,
              fontWeight: FontWeight.bold,
              // Define a cor do símbolo (X ou O).
              color: simbolo == 'X' ? Colors.black : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  // Constrói o tabuleiro 3x3 completo.
  Widget _construirTabuleiro() {
    return AspectRatio(
      // AspectRatio força seu filho a ter uma proporção específica (1:1 = quadrado).
      aspectRatio: 1.0,
      child: Stack(
        // Stack permite empilhar widgets um sobre o outro.
        // Usamos isso para desenhar a linha de vitória por cima do tabuleiro.
        children: [
          GridView.builder(
            // GridView.builder é uma forma eficiente de criar uma grade.
            physics: const NeverScrollableScrollPhysics(), // Impede o scroll do grid.
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 colunas.
            ),
            itemCount: 9, // 9 itens no total.
            itemBuilder: (context, index) => _construirCelula(index), // Constrói cada célula.
          ),
          // Se houver uma linha vencedora, desenha o CustomPaint.
          if (_linhaVencedora != null)
            CustomPaint(
              // CustomPaint permite desenhar formas personalizadas na tela.
              painter: PintorLinhaVencedora(linhaVencedora: _linhaVencedora!),
              size: Size.infinite, // Ocupa todo o espaço do Stack.
            ),
        ],
      ),
    );
  }

  // O método build principal da tela do jogo.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(tituloAplicativo),
        centerTitle: true,
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Área de Status ---
            Text(
              _mensagemStatus,
              style: const TextStyle(fontSize: tamanhoFonteStatus),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // --- Tabuleiro do Jogo ---
            // Expanded faz com que o tabuleiro ocupe o máximo de espaço vertical possível,
            // empurrando o placar e o botão de reinício para baixo.
            Expanded(
              child: _construirTabuleiro(),
            ),
            const SizedBox(height: 24),
            
            // --- Placar ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Vitórias: ', style: TextStyle(fontSize: 18)),
                Text('$_vitorias', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(width: 24),
                const Text('Derrotas: ', style: TextStyle(fontSize: 18)),
                Text('$_derrotas', style: const TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            
            // --- Botão de Reiniciar (visível apenas quando o jogo termina) ---
            // Usamos um if para renderizar condicionalmente o botão.
            if (_jogoFinalizado)
              ElevatedButton(
                onPressed: _reiniciarPartida,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrincipal,
                  minimumSize: const Size(220, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Reiniciar Partida',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            // Se o jogo não terminou, exibe um container vazio para manter o layout consistente.  
            else 
              const SizedBox(height: 50), // Reserva o espaço do botão
          ],
        ),
      ),
    );
  }
}


// --- Classe para Desenhar a Linha de Vitória ---
// CustomPainter é uma classe de baixo nível que nos dá um Canvas para desenhar.
// É ideal para gráficos personalizados que não são facilmente criados com widgets padrão.
class PintorLinhaVencedora extends CustomPainter {
  final List<int> linhaVencedora;

  PintorLinhaVencedora({required this.linhaVencedora});

  @override
  void paint(Canvas canvas, Size size) {
    // Configura o "pincel" (Paint) para a linha.
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.8)
      ..strokeWidth = 8.0 // Espessura da linha.
      ..strokeCap = StrokeCap.round // Deixa as pontas da linha arredondadas.
      ..style = PaintingStyle.stroke;

    // Calcula a largura e altura de cada célula com base no tamanho total do canvas.
    final larguraCelula = size.width / 3;
    final alturaCelula = size.height / 3;

    // Função auxiliar para encontrar o centro de uma célula a partir de seu índice (0 a 8).
    Offset getCentroCelula(int index) {
      final linha = index ~/ 3; // Divisão inteira para obter a linha (0, 1 ou 2).
      final coluna = index % 3; // Resto da divisão para obter a coluna (0, 1 ou 2).
      return Offset(
        coluna * larguraCelula + larguraCelula / 2, // Coordenada X do centro.
        linha * alturaCelula + alturaCelula / 2, // Coordenada Y do centro.
      );
    }

    // Obtém as coordenadas do centro da primeira e da última célula da combinação vencedora.
    final inicio = getCentroCelula(linhaVencedora[0]);
    final fim = getCentroCelula(linhaVencedora[2]);

    // Desenha a linha no canvas.
    canvas.drawLine(inicio, fim, paint);
  }

  // Este método determina se o pintor precisa ser redesenhado.
  // Retornar 'true' aqui é uma abordagem simples que garante que a linha seja
  // redesenhada sempre que o widget for reconstruído. Para otimizações, poderíamos
  // comparar o oldDelegate.linhaVencedora com o atual.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
