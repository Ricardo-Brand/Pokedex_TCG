class Usuario_db {
  final String uid;
  final String nome;
  final String telefone;
  final String email;

  Usuario_db({
    required this.uid,
    required this.nome,
    required this.telefone,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
  }

  static Usuario_db fromMap(String uid, Map<String, dynamic> map) {
    return Usuario_db(
      uid: uid,
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
    );
  }
}