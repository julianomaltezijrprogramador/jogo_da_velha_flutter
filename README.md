# Jogo da Velha em Flutter

Este é um projeto simples de Jogo da Velha desenvolvido com Flutter, ideal para iniciantes que estão aprendendo os conceitos fundamentais da criação de aplicativos móveis. O jogo permite que o usuário jogue contra uma Inteligência Artificial (IA) básica.

O objetivo deste projeto é demonstrar de forma clara e com código comentado os principais conceitos do Flutter, como:
-   Widgets (Stateless e Stateful)
-   Gerenciamento de estado com `setState`
-   Navegação entre telas
-   Layouts com `Column`, `Row` e `GridView`
-   Desenho customizado com `CustomPainter`

## Como Funciona

1.  **Tela Inicial:** O jogador escolhe se quer ser 'X' ou 'O'.
2.  **Início da Partida:** O jogo sorteia aleatoriamente quem começa, o jogador ou a IA.
3.  **Jogabilidade:** O jogador clica em uma célula vazia para fazer sua jogada. Em seguida, a IA faz a sua.
4.  **Inteligência Artificial (IA):** A IA segue uma estratégia simples:
    -   Primeiro, ela verifica se pode vencer na jogada atual.
    -   Se não, ela verifica se o jogador pode vencer na próxima jogada e o bloqueia.
    -   Caso contrário, ela joga no primeiro espaço vazio que encontrar.
5.  **Fim de Jogo:** O jogo exibe uma mensagem de vitória, derrota ou empate. Uma linha vermelha é desenhada sobre a combinação vencedora.
6.  **Placar:** O placar de vitórias e derrotas é atualizado ao final de cada partida.
7.  **Reiniciar:** Após o fim de uma partida, um botão aparece para reiniciar e jogar novamente.

---

## prints
Tela inicial

![tela_inicial](https://github.com/user-attachments/assets/72509666-5f38-4574-935c-5ccef2e93cfb)

Tela de jogo

![tela_de_jogo](https://github.com/user-attachments/assets/934c24e2-4a53-487a-b800-08ee07c5f15c)

Tela de jogo quando tem vencedor

![tela_jogo_quando_tem_vencedor](https://github.com/user-attachments/assets/4451de4b-8f44-4a16-877e-335399a91cf0)

Tela de jogo quando empate

![tela_jogo_quando_empate](https://github.com/user-attachments/assets/d77b4423-2dc9-4889-a21e-0415ab50f72f)

---

## Pré-requisitos

-   Flutter instalado em sua máquina.
-   Um editor de código como VS Code ou Android Studio.
-   Um emulador Android, simulador iOS ou um dispositivo físico para executar o app.

---

## Como Rodar o Projeto

1.  **Clone o repositório:**
    ```sh
    git clone https://github.com/julianomaltezijrprogramador/jogo_da_velha_flutter.git
    ```

2.  **Navegue até a pasta do projeto:**
    ```sh
    cd nome-da-pasta-do-projeto
    ```

3.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```

4.  **Rode o aplicativo:**
    ```sh
    flutter run
    ```

---

## Estrutura do Projeto

Todo o código-fonte está contido em um único arquivo, para facilitar o entendimento de iniciantes:

-   `lib/main.dart`: Contém toda a lógica do aplicativo.
    -   **`MeuAplicativo`**: Widget principal que inicializa o `MaterialApp`.
    -   **`TelaInicial`**: Widget para a tela de seleção de símbolo.
    -   **`JogoDaVelhaTela`**: Widget que gerencia o estado e a lógica do jogo (tabuleiro, jogadas, placar, etc.).
    -   **`PintorLinhaVencedora`**: Classe que usa `CustomPainter` para desenhar a linha de vitória.

---

## Tecnologias Usadas

-   **Flutter**: Framework para criar a interface e a lógica do jogo.
-   **Dart**: Linguagem de programação usada pelo Flutter.

---

## Sugestões de Melhorias

Este é um projeto de aprendizado, mas que pode ser expandido. Algumas ideias:

-   Implementar uma IA mais avançada (usando o algoritmo Minimax, por exemplo).
-   Adicionar sons para as jogadas e para o final da partida.
-   Criar um modo de jogo para dois jogadores no mesmo dispositivo.
-   Salvar o placar e as estatísticas do jogador mesmo após fechar o aplicativo (usando `shared_preferences`).
-   criar um multiplayer entre aplicativos(online).

---

## Autor

Desenvolvido como um projeto de aprendizado em Flutter. Sinta-se à vontade para usar e modificar este código para seus estudos!

