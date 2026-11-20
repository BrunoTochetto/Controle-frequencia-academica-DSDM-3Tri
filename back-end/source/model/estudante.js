

class Estudante {
      constructor(nome, id, idade, turma) {
            this.nome = nome;
            this.#id = id;
            this.idade = idade;
            this.turma = turma;
            this.presenca = 0;
      }

      mudarTurma(ObjetoTurmaNova) {
            this.turma = ObjetoTurmaNova;
      }

      registrarPresenca(presencas = 1) {
            this.presenca += presencas;
      }
}

export {Estudante}