![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Android Studio](https://img.shields.io/badge/Android%20Studio-3DDC84.svg?style=for-the-badge&logo=android-studio&logoColor=white)

![Status](https://img.shields.io/badge/Status-Finalizado-success?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)

[![GitHub](https://img.shields.io/badge/GitHub-0077B5?style=for-the-badge&logo=github&logoColor=white)](github.com/rianeduardo)


# 📑 ACTA - Organize, Estruture, Resolva.

O **ACTA** é um aplicativo de gerenciamento de tarefas (To-Do List) desenvolvido em Flutter. O foco do projeto é oferecer uma experiência fluida de organização pessoal com persistência de dados local e uma interface moderna e intuitiva.

---

## 🚀 Funcionalidades

* **Onboarding Personalizado**: O app memoriza o nome do usuário para uma experiência única.
* **Gestão de Tarefas**: Criação de tarefas com título e descrição opcional.
* **Sistema de Prioridades**: Classificação de tarefas em Alta, Média ou Baixa (com sinalização por cores).
* **Ordenação Inteligente**: As tarefas são organizadas automaticamente por nível de prioridade e data de criação.
* **Persistência de Dados**: Informações salvas localmente, garantindo que nada se perca ao fechar o app.
* **Limpeza**: Opção de remover todas as tarefas de uma vez com confirmação, swipe-to-delete individual.

---

## 🏗️ Arquitetura do Projeto

O projeto foi estruturado utilizando uma **Arquitetura em Camadas (Layered Architecture)**, visando a separação de responsabilidades (SoC) e facilidade de manutenção:

* **Models**: Definição das entidades de dados (`TaskModel`).
* **Views**: Telas da interface do usuário (`Onboarding`, `Home`).
* **Services**: Camada de lógica externa e persistência (`StorageService`).
* **Widgets**: Componentes de interface reutilizáveis (`ModalTarefa`).

---

## 🛠️ Tecnologias Utilizadas

* [Flutter](https://flutter.dev/) - Framework UI.
* [Dart](https://dart.dev/) - Linguagem de programação.
* [Shared Preferences](https://pub.dev/packages/shared_preferences) - Persistência de dados local (Key-Value).
* [Google Fonts](https://pub.dev/packages/google_fonts) - Tipografia personalizada (Inter).

---

## 📥 Como rodar o projeto

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/rianeduardo/acta.git
    ```
2.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```
3.  **Execute o app:**
    ```bash
    flutter run
    ```

---

## 📈 Evolução do Desenvolvimento

Este repositório documenta a evolução do projeto através de commits estruturados:
1.  **UI Layout**: Definição visual e navegação base.
2.  **Data Modeling**: Estruturação dos modelos de dados.
3.  **Persistence**: Implementação do serviço de armazenamento local.
4.  **Business Logic**: Integração final, filtros e ordenação.

---
Desenvolvido por Rian Eduardo - 2026
