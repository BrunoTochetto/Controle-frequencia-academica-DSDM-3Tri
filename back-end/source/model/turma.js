class Turma {
      constructor(identificador, alunos = []) {
          this.identificador = identificador;

          if (Array.isArray(alunos)) {
            this.alunos = alunos;
          } else if (alunos == null) {
            this.alunos = [];
          } else {
            this.alunos = [alunos];
          }

          this.quantidadeAlunos = this.alunos.length;
      }

      registrarAluno(aluno) {
          this.alunos.push(aluno);
          this.quantidadeAlunos = this.alunos.length;
      }

      removerAluno(aluno) {
          const posicao = this.alunos.findIndex((item) => item.id === aluno.id);

          if (posicao === -1) {
            return false;
          }

          this.alunos.splice(posicao, 1);
          this.quantidadeAlunos = this.alunos.length;
          return true;
      }

      buscarAlunos(nome) {
          if (!nome) return this.alunos;

          return this.alunos.filter((aluno) =>
            aluno.nome.toLowerCase().includes(nome.toLowerCase()),
          );
      }

      toJSON() {
          return {
            identificador: this.identificador,
            alunos: this.alunos.map((aluno) => aluno.toJSON?.() ?? aluno),
            quantidadeAlunos: this.quantidadeAlunos,
          };
      }
}

export {Turma}