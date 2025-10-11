// 14-agregacao.dart  
// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() => {
        'nome': _nome,
      };

  @override
  String toString() => 'Dependente($_nome)';
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() => {
        'nome': _nome,
        'dependentes': _dependentes.map((d) => d.toJson()).toList(),
      };

  @override
  String toString() => 'Funcionario($_nome, dependentes: ${_dependentes.length})';
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() => {
        'nomeProjeto': _nomeProjeto,
        'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
      };

  @override
  String toString() => 'EquipeProjeto($_nomeProjeto, funcionarios: ${_funcionarios.length})';
}

void main() {

  final dep1 = Dependente('Ana');
  final dep2 = Dependente('Beatriz');
  final dep3 = Dependente('Carlos Jr.');
  final dep4 = Dependente('Davi');

  final func1 = Funcionario('João', [dep1, dep2]); // João tem Ana e Beatriz
  final func2 = Funcionario('Mariana', [dep3]);    // Mariana tem Carlos Jr.
  final func3 = Funcionario('Pedro', [dep4]);      // Pedro tem Davi
  final func4 = Funcionario('Lucas', []);          // Lucas sem dependentes

  final listaFuncionarios = [func1, func2, func3, func4];

  final equipe = EquipeProjeto('Projeto Mobile X', listaFuncionarios);

  final encoder = JsonEncoder.withIndent('  ');
  final jsonStr = encoder.convert(equipe.toJson());
  print(jsonStr);
}
