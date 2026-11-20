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

      criarTurma(identificador, alunos) {
            turma = Turma(identificador, alunos)
            this.inserir("turma", turma)
      }

      buscarTurma(identificador) {
            this.#bd

            return turma
      }

      #criarTabela(tabela) {
            this.#bd[tabela] = []
      }
}


export {BancoDeDadosVolatil}