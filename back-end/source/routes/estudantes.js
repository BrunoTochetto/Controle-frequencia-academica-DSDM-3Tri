import { Router } from 'express';

export function criarRotasEstudantes(banco) {
      const router = Router();

      router.get('/', (req, res) => {
          const resultado = banco.buscarEstudantes(
            req.query.q?.toString() ?? '',
            req.query.pagina ?? 1,
            req.query.limite ?? 20,
          );

          res.json(resultado);
      });

      router.post('/', (req, res) => {
          const { nome, id, idade, turma } = req.body;

          if (!nome || id == null || idade == null || !turma) {
            return res.status(400).json({
                  mensagem: 'Informe nome, id, idade e turma.',
            });
          }

          const estudante = banco.criarEstudante(nome, Number(id), Number(idade), turma);
          if (!estudante) {
            return res.status(404).json({ mensagem: 'Turma não encontrada.' });
          }

          res.status(201).json(estudante);
      });

      return router;
}
