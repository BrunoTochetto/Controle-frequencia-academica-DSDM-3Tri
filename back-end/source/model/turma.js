
class Turma {
      constructor(identificador, alunos) {
            this.identificador = identificador;

            if (typeof(alunos) == Array) {
                  this.alunos = alunos // Pede array alunos
            } else if (typeof(alunos) == null) {
                  this.alunos = [];
            } else {
                  this.alunos = [alunos];
            }
            
            this.quantidadeAlunos = this.alunos.length;
      }

      registrarAluno() {

      }
      
      removerAluno() {

      }
}

export {Turma}