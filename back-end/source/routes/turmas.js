import { Router } from 'express';

export function criarRotasTurmas(banco) {
      const router = Router();

      router.get('/', (req, res) => {
          const resultado = banco.buscarTurmas(
            req.query.q?.toString() ?? '',
            req.query.pagina ?? 1,
            req.query.limite ?? 20,
          );

          res.json(resultado);
      });

      router.post('/', (req, res) => {
          const { identificador, alunos } = req.body;
          if (!identificador) {
            return res.status(400).json({ mensagem: 'O identificador é obrigatório.' });
          }

          const turma = banco.criarTurma(identificador, alunos ?? []);
          res.status(201).json(turma);
      });

      router.get('/:identificador', (req, res) => {
          const turma = banco.buscarTurma(req.params.identificador);
          if (!turma) return res.status(404).json({ mensagem: 'Turma não encontrada.' });

          res.json(turma);
      });

      router.post('/:identificador/faltas', (req, res) => {
          const ids = req.body.estudantesIds;
          if (!Array.isArray(ids)) {
            return res.status(400).json({ mensagem: 'Informe uma lista de estudantesIds.' });
          }

          const turma = banco.registrarFaltas(req.params.identificador, ids);
          if (!turma) return res.status(404).json({ mensagem: 'Turma não encontrada.' });

          res.json(turma);
      });

      return router;
}
