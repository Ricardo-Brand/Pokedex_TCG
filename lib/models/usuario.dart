/// Classe que representa o usuário do app.
/// Usa o padrão Singleton para garantir que apenas um usuário exista por vez.
class Usuario {
  // 🔹 Atributos do usuário
  final String nome;
  final String telefone;
  final String email;
  final String senha;

  // Construtor privado — impede criação externa
  Usuario._({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
  });

  // Instância única (singleton)
  static Usuario? _instancia;

  // Retorna o usuário atual, se existir
  static Usuario get instancia {
    if (_instancia == null) {
      throw Exception('Usuário ainda não foi criado!');
    }
    return _instancia!;
  }

  // Cria o usuário (apenas um pode existir)
  static void criar({
    required String nome,
    required String telefone,
    required String email,
    required String senha,
  }) {
    _instancia ??= Usuario._(
      nome: nome,
      telefone: telefone,
      email: email,
      senha: senha,
    );
  }

  // Verifica se existe um usuário com o email e senha informados
  static Usuario? existe(String email, String senha) {
    if (_instancia == null) return null;
    if (_instancia!.email == email && _instancia!.senha == senha) {
      return _instancia;
    }
    return null;
  }

  // Remove o usuário atual (ex: logout)
  static void limpar() {
    _instancia = null;
  }

  // Converte o usuário para Map (ex: salvar localmente)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
    };
  }

  // Cria um usuário a partir de um Map (ex: JSON)
  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario._(
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      senha: map['senha'],
    );
  }

  @override
  String toString() {
    return 'Usuario(nome: $nome, telefone: $telefone, email: $email)';
  }
}
