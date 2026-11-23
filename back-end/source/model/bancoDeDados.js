import {Turma} from './turma.js';
import {Estudante} from './estudante.js';

// Cadastrar turmas, estudantes e registrar presenças.
class BancoDeDadosVolatil {
      #bd;

      constructor() {
          this.#bd = {
            estudantes: [],
            turmas: [],
          };
      }

      inserir(tabela, dado) {
          if (!this.#bd[tabela]) throw new Error(`Tabela inexistente: ${tabela}`);
          this.#bd[tabela].push(dado);
          return dado;
      }

      criarTurma(identificador, alunos = []) {
          const turma = new Turma(identificador, alunos);
          return this.inserir('turmas', turma);
      }

      criarEstudante(nome, id, idade, turma) {
          const turmaEncontrada = typeof turma === 'string'
            ? this.buscarTurma(turma)
            : turma;

          if (!turmaEncontrada) return null;

          const estudante = new Estudante(nome, id, idade, turmaEncontrada);
          this.inserir('estudantes', estudante);
          turmaEncontrada.registrarAluno(estudante);

          return estudante;
      }

      buscarTurma(identificador) {
          return this.#bd.turmas.find((turma) => turma.identificador === identificador,);
      }

      // Pagina e limites para a busca no front
      buscarTurmas(consulta = '', pagina = 1, limite = 20) {
          const normalizada = consulta.trim().toLowerCase();
          const filtradas = normalizada ? this.#bd.turmas.filter((turma) =>
                      turma.identificador.toLowerCase().includes(normalizada),
                  ) : this.#bd.turmas;

          return this.paginar(filtradas, pagina, limite);
      }

      buscarEstudantes(consulta = '', pagina = 1, limite = 20) {
          const normalizada = consulta.trim().toLowerCase();
          const filtrados = normalizada ? this.#bd.estudantes.filter((estudante) =>
                      estudante.nome.toLowerCase().includes(normalizada) ||
                      String(estudante.id).includes(normalizada),
                  ) : this.#bd.estudantes;

          return this.paginar(filtrados, pagina, limite);
      }

      registrarPresencas(identificador, idsEstudantes) {
          const turma = this.buscarTurma(identificador);
          if (!turma) return null;

          for (const aluno of turma.alunos) {
            if (idsEstudantes.includes(aluno.id)) {
              aluno.registrarPresenca();
            } else {
              aluno.registrarFalta();
            }
          }

          return turma;
      }

      registrarFaltas(identificador, idsEstudantesFaltosos) {
          const turma = this.buscarTurma(identificador);
          if (!turma) return null;

          for (const aluno of turma.alunos) {
            if (idsEstudantesFaltosos.includes(aluno.id)) {
              aluno.registrarFalta();
            } else {
              aluno.registrarPresenca();
            }
          }

          return turma;
      }

      paginar(itens, pagina, limite) {
          const paginaValida = Math.max(1, Number(pagina));
          const limiteValido = Math.max(1, Number(limite));
          const inicio = (paginaValida - 1) * limiteValido;

          return {
            dados: itens.slice(inicio, inicio + limiteValido),
            pagina: paginaValida,
            limite: limiteValido,
            total: itens.length,
            existeProximaPagina: inicio + limiteValido < itens.length,
          };
      }
}

export { BancoDeDadosVolatil };