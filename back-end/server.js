import express, { json } from "express";
import cors from "cors";
import { config } from "dotenv";

import { BancoDeDadosVolatil } from "./source/model/bancoDeDados.js";
import { criarRotasTurmas } from "./source/routes/turmas.js";
import { criarRotasEstudantes } from "./source/routes/estudantes.js";

config();

const app = express();
app.use(json());
app.use(cors());

const banco = new BancoDeDadosVolatil();


// banco.criarTurma("DSDM");
// banco.criarTurma("DW 3");
// banco.criarEstudante("Bruno", 1, 16, "DSDM");
// banco.criarEstudante("Bruna", 2, 17, "DSDM");
// banco.criarEstudante("João", 3, 16, "DW 3");

app.get("/api/status", (req, res) => {
  res.json({ message: "Status Ativo" });
});

app.use("/api/turmas", criarRotasTurmas(banco));
app.use("/api/estudantes", criarRotasEstudantes(banco));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Servidor rodando em http://localhost:${PORT}`));