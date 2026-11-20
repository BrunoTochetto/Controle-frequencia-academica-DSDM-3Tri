
class Turma {
      constructor(identificador, alunos = null) {
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

      registrarAluno(aluno) {
            this.alunos += aluno;
            this.quantidadeAlunos = this.alunos.length;
      }
      
      removerAluno(aluno) {
            let pos = this.alunos.find(aluno);
            if (!pos) {
                  return "Não foi encontrado o aluno na turma"
            }
            this.alunos.splice(pos, 1);
            this.quantidadeAlunos = this.alunos.length;
      }

      buscarAlunos(nome = False) {
            if (nome) {
                  let alunoAchado;
                  this.alunos.forEach(aluno => {
                        if (aluno.nome == nome) {
                              alunoAchado == aluno;
                              return
                        }
                  });

                  return turmaAchada;
            } else {
                  return this.alunos;
            }
      }
}

export {Turma}