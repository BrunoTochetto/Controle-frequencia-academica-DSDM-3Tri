import {Turma} from "./turma";
import { Estudante } from "./estudante";
// Cadastrar turmas, estudantes e registrar presenças.
class BancoDeDadosVolatil {
      #bd = {};
      constructor() {
            this.#bd = #bd;
            this.#criarTabela("estudantes")
            this.#criarTabela("turma")
      }

      inserir(tabela, dado) {
            if (this.#bd[tabela]) {

            }
      }

      criarTurma(identificador, alunos = null) {
            turma = Turma(identificador, alunos);
            this.inserir("turma", turma);
      }

      buscarTurma(identificador) {
            let turmaAchada;
            this.#bd["turma"].forEach(turma => {
                  if (turma.identificador == identificador) {
                        turmaAchada == turma;
                        return
                  }
            });

            return turmaAchada;
      }

      #criarTabela(tabela) {
            this.#bd[tabela] = []
      }
}


export {BancoDeDadosVolatil}